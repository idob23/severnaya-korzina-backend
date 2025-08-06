// src/utils/batchCalculations.js - Утилиты для расчета статистики закупок

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

/**
 * Обновляет статистику закупки (вызывается при изменении заказов)
 * @param {number} batchId - ID закупки
 * @returns {Promise<Object>} Обновленная статистика
 */
async function updateBatchStatistics(batchId) {
  try {
    console.log(`🔄 Обновление статистики для закупки ${batchId}`);

    // Сначала получаем информацию о закупке и дате начала сбора
    const currentBatch = await prisma.batch.findUnique({
      where: { id: parseInt(batchId) },
      select: { 
        targetAmount: true, 
        status: true,
        collectionStartDate: true  // ПОЛУЧАЕМ ДАТУ НАЧАЛА СБОРА
      }
    });

    if (!currentBatch) {
      throw new Error(`Закупка с ID ${batchId} не найдена`);
    }

    // Определяем с какой даты считать заказы
    const startDate = currentBatch.collectionStartDate || new Date('2000-01-01');
    
    // Получаем только заказы ПОСЛЕ начала текущего сбора
    const orders = await prisma.order.findMany({
      where: {
        batchId: parseInt(batchId),
        status: {
          in: ['pending', 'confirmed', 'paid'] // Учитываем только активные заказы
        },
        createdAt: {
          gte: startDate  // ТОЛЬКО заказы после начала сбора!
        }
      },
      select: {
        id: true,
        userId: true,
        totalAmount: true,
        status: true,
        createdAt: true
      }
    });

    console.log(`📊 Найдено ${orders.length} заказов после ${startDate.toISOString()}`);

    // Вычисляем статистику
    const currentAmount = orders.reduce((sum, order) => {
      return sum + parseFloat(order.totalAmount);
    }, 0);

    // Подсчитываем уникальных участников
    const uniqueUserIds = new Set(orders.map(order => order.userId));
    const participantsCount = uniqueUserIds.size;

    // Вычисляем процент выполнения
    const progressPercent = Math.min(
      Math.round((currentAmount / parseFloat(currentBatch.targetAmount)) * 100),
      100
    );

    // Определяем новый статус
    let newStatus = currentBatch.status;
    if (currentAmount >= parseFloat(currentBatch.targetAmount) && 
        currentBatch.status === 'collecting') {
      newStatus = 'ready'; // Готова к отправке
    }

    // Обновляем закупку
    const updatedBatch = await prisma.batch.update({
      where: { id: parseInt(batchId) },
      data: {
        currentAmount: currentAmount,
        participantsCount: participantsCount,
        progressPercent: progressPercent,
        lastCalculated: new Date(),
        status: newStatus
      }
    });

    console.log(`✅ Статистика обновлена:`, {
      batchId,
      currentAmount,
      participantsCount,
      progressPercent,
      status: newStatus,
      ordersCount: orders.length,
      sinceDate: startDate.toISOString()
    });

    return {
      success: true,
      batchId: parseInt(batchId),
      currentAmount,
      participantsCount,
      progressPercent,
      status: newStatus,
      targetAmount: parseFloat(currentBatch.targetAmount),
      isReady: newStatus === 'ready'
    };

  } catch (error) {
    console.error(`❌ Ошибка обновления статистики закупки ${batchId}:`, error);
    return {
      success: false,
      error: error.message
    };
  }
}
/**
 * Получает текущую статистику закупки для информационной панели
 * @param {number} batchId - ID закупки
 * @param {number} userId - ID пользователя (для расчета личного вклада)
 * @returns {Promise<Object>} Статистика закупки
 */
async function getBatchProgressData(batchId, userId = null) {
  try {
    // Получаем данные закупки
    const batch = await prisma.batch.findUnique({
      where: { id: parseInt(batchId) },
      include: {
        orders: userId ? {
          where: { userId: parseInt(userId) },
          select: { totalAmount: true }
        } : false
      }
    });

    if (!batch) {
      throw new Error(`Закупка с ID ${batchId} не найдена`);
    }

    // Вычисляем личный вклад пользователя
    let userContribution = 0;
    if (userId && batch.orders) {
      userContribution = batch.orders.reduce((sum, order) => {
        return sum + parseFloat(order.totalAmount);
      }, 0);
    }

    // Определяем мотивационный текст
    const getMotivationalText = (progress) => {
      if (progress < 30) return 'Нужно больше участников! 🚀';
      if (progress < 50) return 'Отличное начало! 💪';
      if (progress < 70) return 'Больше половины! Продолжаем! 🔥';
      if (progress < 90) return 'Почти готово! Последний рывок! ⚡';
      if (progress < 100) return 'Ещё чуть-чуть! 🎯';
      return 'Цель достигнута! Готовим машину! 🚛';
    };

    // Определяем цвет прогресса
    const getProgressColor = (progress) => {
      if (progress < 30) return 'red';
      if (progress < 70) return 'orange';
      if (progress < 90) return 'blue';
      return 'green';
    };

    const result = {
      id: batch.id,
      title: batch.title,
      status: batch.status,
      targetAmount: parseFloat(batch.targetAmount),
      currentAmount: parseFloat(batch.currentAmount),
      participantsCount: batch.participantsCount,
      progressPercent: batch.progressPercent,
      userContribution: userContribution,
      motivationalText: getMotivationalText(batch.progressPercent),
      progressColor: getProgressColor(batch.progressPercent),
      isReady: batch.status === 'ready',
      canLaunch: batch.progressPercent >= 100 && batch.status === 'ready',
      lastCalculated: batch.lastCalculated,
      autoLaunch: batch.autoLaunch,
      marginPercent: parseFloat(batch.marginPercent)
    };

    return result;

  } catch (error) {
    console.error(`❌ Ошибка получения статистики закупки ${batchId}:`, error);
    throw error;
  }
}

/**
 * Получает активную закупку для информационной панели
 * @param {number} userId - ID пользователя
 * @returns {Promise<Object|null>} Данные активной закупки или null
 */
async function getActiveBatchForUser(userId = null) {
  try {
    // Находим активную закупку
    const activeBatch = await prisma.batch.findFirst({
      where: {
        status: {
          in: ['active', 'collecting', 'ready']
        }
      },
      orderBy: {
        createdAt: 'desc' // Самая свежая активная закупка
      }
    });

    if (!activeBatch) {
      return null;
    }

    // Получаем полную статистику этой закупки
    return await getBatchProgressData(activeBatch.id, userId);

  } catch (error) {
    console.error('❌ Ошибка получения активной закупки:', error);
    return null;
  }
}

/**
 * Middleware для автоматического обновления статистики при изменении заказа
 */
async function updateBatchOnOrderChange(orderId, action = 'update') {
  try {
    // Получаем заказ с информацией о закупке
    const order = await prisma.order.findUnique({
      where: { id: parseInt(orderId) },
      select: { batchId: true }
    });

    if (order && order.batchId) {
      // Обновляем статистику закупки
      await updateBatchStatistics(order.batchId);
      
      console.log(`🔄 Статистика закупки ${order.batchId} обновлена после ${action} заказа ${orderId}`);
    }

  } catch (error) {
    console.error('❌ Ошибка обновления статистики после изменения заказа:', error);
  }
}

module.exports = {
  updateBatchStatistics,
  getBatchProgressData,
  getActiveBatchForUser,
  updateBatchOnOrderChange
};
