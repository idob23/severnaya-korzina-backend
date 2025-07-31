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

// GET /api/batches/active - Получить активную закупку для информационной панели
router.get('/active', authenticateToken, async (req, res) => {
  try {
    const userId = req.user?.id;
    
    const activeBatchData = await getActiveBatchForUser(userId);
    
    if (!activeBatchData) {
      return res.json({
        success: true,
        batch: null,
        message: 'Нет активных закупок'
      });
    }

    res.json({
      success: true,
      batch: activeBatchData
    });

  } catch (error) {
    console.error('❌ Ошибка получения активной закупки:', error);
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

module.exports = router;