// src/routes/batches.js - ОБНОВЛЕННАЯ ВЕРСИЯ С API ДЛЯ ПАНЕЛИ

const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');
const { 
  updateBatchStatistics, 
  getBatchProgressData, 
  getActiveBatchForUser 
} = require('../utils/batchCalculations');

const router = express.Router();
const prisma = new PrismaClient();


// GET /api/batches/:id/test - Тестовый endpoint для отладки
router.get('/:id/test', async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);
    
    // Получаем партию
    const batch = await prisma.batch.findUnique({
      where: { id: batchId }
    });
    
    if (!batch) {
      return res.status(404).json({ error: 'Партия не найдена' });
    }
    
    // Получаем все заказы партии
    const orders = await prisma.order.findMany({
      where: { batchId: batchId },
      include: {
        orderItems: true,
        user: {
          select: {
            id: true,
            phone: true,
            firstName: true
          }
        }
      }
    });
    
    // Считаем статистику
    const totalAmount = orders.reduce((sum, order) => {
      return sum + parseFloat(order.totalAmount);
    }, 0);
    
    const uniqueUsers = new Set(orders.map(o => o.userId));
    
    res.json({
      batch: {
        id: batch.id,
        title: batch.title,
        status: batch.status,
        targetAmount: parseFloat(batch.targetAmount),
        currentAmount: parseFloat(batch.currentAmount),
        progressPercent: batch.progressPercent,
        participantsCount: batch.participantsCount
      },
      calculated: {
        ordersCount: orders.length,
        totalAmount: totalAmount,
        uniqueUsers: uniqueUsers.size,
        progressPercent: Math.round((totalAmount / parseFloat(batch.targetAmount)) * 100)
      },
      orders: orders.map(o => ({
        id: o.id,
        userId: o.userId,
        userName: o.user.firstName,
        status: o.status,
        totalAmount: parseFloat(o.totalAmount),
        itemsCount: o.orderItems.length,
        createdAt: o.createdAt
      }))
    });
    
  } catch (error) {
    console.error('❌ Ошибка теста:', error);
    res.status(500).json({ error: error.message });
  }
});


// POST /api/batches/:id/recalculate - Ручной пересчет статистики
router.post('/:id/recalculate', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);
    
    console.log(`🔄 Ручной пересчет статистики для партии #${batchId}`);
    
    // Вызываем функцию пересчета
    const result = await updateBatchStatistics(batchId);
    
    if (result.success) {
      res.json({
        success: true,
        message: 'Статистика пересчитана',
        data: result
      });
    } else {
      res.status(400).json({
        success: false,
        error: result.error
      });
    }
    
  } catch (error) {
    console.error('❌ Ошибка пересчета:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка сервера'
    });
  }
});

// GET /api/batches - Получить все закупки
router.get('/', async (req, res) => {
  try {
    const { status = 'active' } = req.query;
    
    const batches = await prisma.batch.findMany({
      where: {
        ...(status !== 'all' && { status })
      },
      include: {
        batchItems: {
          include: {
            product: {
              include: {
                category: true
              }
            }
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.json({ 
      success: true,
      batches: batches.map(batch => ({
        ...batch,
        targetAmount: parseFloat(batch.targetAmount),
        currentAmount: parseFloat(batch.currentAmount),
        marginPercent: parseFloat(batch.marginPercent)
      }))
    });

  } catch (error) {
    console.error('❌ Ошибка получения закупок:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/batches/active - Получить активную партию (БЕЗ АВТОРИЗАЦИИ)
router.get('/active', async (req, res) => {  // УБРАЛИ authenticateToken
  try {
    const activeBatch = await prisma.batch.findFirst({
      where: {
        status: { in: ['active', 'collecting', 'ready'] }  // Только активные статусы
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    if (!activeBatch) {
      return res.json({
        success: true,
        batch: null,
        message: 'Нет активных партий'
      });
    }

    res.json({
      success: true,
      batch: {
        id: activeBatch.id,
        title: activeBatch.title,
        status: activeBatch.status,
        targetAmount: parseFloat(activeBatch.targetAmount),
        currentAmount: parseFloat(activeBatch.currentAmount),
        participantsCount: activeBatch.participantsCount,
        progressPercent: activeBatch.progressPercent,
        createdAt: activeBatch.createdAt
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения активной партии:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/batches/active/user - Получить активную закупку с данными пользователя
router.get('/active/user', authenticateToken, async (req, res) => {
  try {
    const userId = req.user?.id;
    
    if (!userId) {
      return res.status(401).json({
        success: false,
        error: 'Пользователь не авторизован'
      });
    }

    // Используем существующую функцию getActiveBatchForUser
    const { getActiveBatchForUser } = require('../utils/batchCalculations');
    const batchData = await getActiveBatchForUser(userId);
    
    if (!batchData) {
      return res.json({
        success: true,
        batch: null,
        message: 'Нет активных закупок'
      });
    }

    res.json({
      success: true,
      batch: batchData
    });

  } catch (error) {
    console.error('❌ Ошибка получения активной закупки для пользователя:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});


// GET /api/batches/:id/progress - Получить подробную статистику закупки
router.get('/:id/progress', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user?.id;
    
    const batchData = await getBatchProgressData(parseInt(id), userId);
    
    res.json({
      success: true,
      batch: batchData
    });

  } catch (error) {
    console.error('❌ Ошибка получения статистики закупки:', error);
    
    if (error.message.includes('не найдена')) {
      return res.status(404).json({
        success: false,
        error: 'Закупка не найдена'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/batches/:id/recalculate - Пересчитать статистику закупки (админ)
router.post('/:id/recalculate', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Проверяем права (в будущем добавить проверку на админа)
    // if (!req.user.isAdmin) {
    //   return res.status(403).json({ error: 'Недостаточно прав' });
    // }
    
    const result = await updateBatchStatistics(parseInt(id));
    
    if (!result.success) {
      return res.status(400).json({
        success: false,
        error: result.error
      });
    }

    res.json({
      success: true,
      message: 'Статистика успешно пересчитана',
      data: result
    });

  } catch (error) {
    console.error('❌ Ошибка пересчета статистики:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/batches/:id - Получить закупку по ID с полной информацией
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const batch = await prisma.batch.findUnique({
      where: { id: parseInt(id) },
      include: {
        batchItems: {
          include: {
            product: {
              include: {
                category: true
              }
            }
          }
        },
        orders: {
          include: {
            user: {
              select: {
                id: true,
                firstName: true,
                lastName: true
              }
            },
            orderItems: {
              include: {
                product: true
              }
            }
          }
        }
      }
    });

    if (!batch) {
      return res.status(404).json({
        success: false,
        error: 'Закупка не найдена'
      });
    }

    // Преобразуем Decimal в числа для JSON
    const batchData = {
      ...batch,
      targetAmount: parseFloat(batch.targetAmount),
      currentAmount: parseFloat(batch.currentAmount),
      marginPercent: parseFloat(batch.marginPercent)
    };

    res.json({ 
      success: true,
      batch: batchData 
    });

  } catch (error) {
    console.error('❌ Ошибка получения закупки:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/batches - Создать новую закупку (админ)
router.post('/', authenticateToken, async (req, res) => {
  try {
    const {
      title,
      description,
      startDate,
      endDate,
      deliveryDate,
      minParticipants = 5,
      maxParticipants,
      targetAmount = 3000000,
      marginPercent = 20,
      pickupAddress
    } = req.body;

    // Валидация обязательных полей
    if (!title || !startDate || !endDate) {
      return res.status(400).json({
        success: false,
        error: 'Обязательные поля: title, startDate, endDate'
      });
    }

    const newBatch = await prisma.batch.create({
      data: {
        title,
        description,
        startDate: new Date(startDate),
        endDate: new Date(endDate),
        deliveryDate: deliveryDate ? new Date(deliveryDate) : null,
        minParticipants: parseInt(minParticipants),
        maxParticipants: maxParticipants ? parseInt(maxParticipants) : null,
        targetAmount: parseFloat(targetAmount),
        marginPercent: parseFloat(marginPercent),
        pickupAddress,
        status: 'active',
        // Новые поля уже имеют значения по умолчанию
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        autoLaunch: true
      }
    });

    console.log(`✅ Создана новая закупка: ${newBatch.id} - ${newBatch.title}`);

    res.status(201).json({
      success: true,
      message: 'Закупка успешно создана',
      batch: {
        ...newBatch,
        targetAmount: parseFloat(newBatch.targetAmount),
        currentAmount: parseFloat(newBatch.currentAmount),
        marginPercent: parseFloat(newBatch.marginPercent)
      }
    });

  } catch (error) {
    console.error('❌ Ошибка создания закупки:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/batches/start-collection - Начать сбор денег
router.post('/start-collection', authenticateToken, async (req, res) => {
  try {
    const { targetAmount, title = 'Коллективная закупка' } = req.body;

   // 🔥 ДОБАВИТЬ ЭТИ 5 СТРОК:
    if (req.user?.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Недостаточно прав для управления сбором денег'
      });
    }

    if (!targetAmount || targetAmount <= 0) {
      return res.status(400).json({
        success: false,
        error: 'Укажите корректную целевую сумму'
      });
    }

    // Ищем активную партию или создаем новую
    let activeBatch = await prisma.batch.findFirst({
      where: {
        status: { in: ['active', 'collecting'] }
      }
    });

    if (activeBatch) {
      // Обновляем существующую партию И СБРАСЫВАЕМ СЧЕТЧИКИ
      activeBatch = await prisma.batch.update({
        where: { id: activeBatch.id },
        data: {
          targetAmount: parseFloat(targetAmount),
          status: 'collecting',
          currentAmount: 0,           // СБРОС суммы
          participantsCount: 0,       // СБРОС участников
          progressPercent: 0,         // СБРОС прогресса
          collectionStartDate: new Date(), // ЗАПИСЫВАЕМ ДАТУ НАЧАЛА НОВОГО СБОРА          
          updatedAt: new Date(),
          lastCalculated: new Date()  // Обновляем время последнего расчета
        }
      });
      
      console.log(`✅ Начат НОВЫЙ сбор денег. Партия: ${activeBatch.id}, счетчики сброшены`);
      
    } else {
      // Создаем новую партию
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      
      const nextWeek = new Date();
      nextWeek.setDate(nextWeek.getDate() + 7);

      activeBatch = await prisma.batch.create({
        data: {
          title,
          description: 'Автоматически созданная партия для сбора заказов',
          startDate: new Date(),
          endDate: nextWeek,
          targetAmount: parseFloat(targetAmount),
          status: 'collecting',
          currentAmount: 0,
          participantsCount: 0,
          progressPercent: 0,
          collectionStartDate: new Date() // ЗАПИСЫВАЕМ ДАТУ НАЧАЛА СБОРА       
        }
      });
      
      console.log(`✅ Создана новая партия для сбора: ${activeBatch.id}`);
    }

    console.log(`✅ Сбор денег начат. Партия: ${activeBatch.id}, Цель: ${targetAmount}₽`);

    res.json({
      success: true,
      message: `Сбор денег начат! Целевая сумма: ${targetAmount}₽`,
      batch: {
        id: activeBatch.id,
        title: activeBatch.title,
        targetAmount: parseFloat(activeBatch.targetAmount),
        currentAmount: parseFloat(activeBatch.currentAmount),
        status: activeBatch.status
      }
    });

  } catch (error) {
    console.error('❌ Ошибка начала сбора денег:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/batches/stop-collection - Завершить сбор денег
router.post('/stop-collection', authenticateToken, async (req, res) => {
  try {

      // 🔥 ДОБАВИТЬ ЭТИ 5 СТРОК:
    if (req.user?.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Недостаточно прав для управления сбором денег'
      });
    }

    // Ищем активную партию
    const activeBatch = await prisma.batch.findFirst({
      where: {
status: { 
          in: ['collecting', 'ready']  // Добавили 'ready' к поиску
        }      
}
    });

    if (!activeBatch) {
      return res.status(400).json({
        success: false,
        error: 'Нет активного сбора денег'
      });
    }

    // Переводим в статус "готова"
    const updatedBatch = await prisma.batch.update({
      where: { id: activeBatch.id },
      data: {
        status: 'completed',
        updatedAt: new Date()
      }
    });

    console.log(`✅ Сбор денег завершен. Партия: ${activeBatch.id}`);

    res.json({
      success: true,
      message: 'Сбор денег завершен! Партия готова к отправке.',
      batch: {
        id: updatedBatch.id,
        title: updatedBatch.title,
        targetAmount: parseFloat(updatedBatch.targetAmount),
        currentAmount: parseFloat(updatedBatch.currentAmount),
        status: updatedBatch.status
      }
    });

  } catch (error) {
    console.error('❌ Ошибка завершения сбора денег:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/batches/active - Получить активную партию
router.get('/active', async (req, res) => {
  try {
    const activeBatch = await prisma.batch.findFirst({
      where: {
        status: { in: ['active', 'collecting'] }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    if (!activeBatch) {
      return res.json({
        success: true,
        batch: null,
        message: 'Нет активных партий'
      });
    }

    res.json({
      success: true,
      batch: {
        id: activeBatch.id,
        title: activeBatch.title,
        status: activeBatch.status,
        targetAmount: parseFloat(activeBatch.targetAmount),
        currentAmount: parseFloat(activeBatch.currentAmount),
        participantsCount: activeBatch.participantsCount,
        progressPercent: activeBatch.progressPercent,
        createdAt: activeBatch.createdAt
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения активной партии:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/batches/:id/title - Обновить название закупки
router.put('/:id/title', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    const { title } = req.body;

    console.log(`🔄 Обновление названия закупки ${id}: "${title}"`);

    // Проверяем входные данные
    if (!title || title.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Название закупки не может быть пустым'
      });
    }

    if (title.length > 100) {
      return res.status(400).json({
        success: false,
        error: 'Название слишком длинное (максимум 100 символов)'
      });
    }

    // Обновляем закупку
    const updatedBatch = await prisma.batch.update({
      where: { id: parseInt(id) },
      data: { 
        title: title.trim(),
        updatedAt: new Date()
      }
    });

    console.log(`✅ Название закупки обновлено: ${id} -> "${title}"`);

    res.json({
      success: true,
      message: 'Название закупки обновлено',
      batch: {
        id: updatedBatch.id,
        title: updatedBatch.title,
        updatedAt: updatedBatch.updatedAt
      }
    });

  } catch (error) {
    console.error('❌ Ошибка обновления названия закупки:', error);
    
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Закупка не найдена'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;
