// src/routes/batches.js
const express = require('express');
const { PrismaClient } = require('@prisma/client');

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
        },
        _count: {
          select: {
            orders: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    // Добавляем подсчет участников
    const batchesWithStats = batches.map(batch => ({
      ...batch,
      participantsCount: batch._count.orders,
      productsCount: batch.batchItems.length,
      isActive: batch.status === 'active' && new Date() < batch.endDate
    }));

    res.json({ batches: batchesWithStats });

  } catch (error) {
    console.error('Ошибка получения закупок:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/batches/:id - Получить закупку по ID
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
            }
          }
        }
      }
    });

    if (!batch) {
      return res.status(404).json({
        error: 'Закупка не найдена'
      });
    }

    // Добавляем статистику
    const batchWithStats = {
      ...batch,
      participantsCount: batch.orders.length,
      productsCount: batch.batchItems.length,
      isActive: batch.status === 'active' && new Date() < batch.endDate
    };

    res.json({ batch: batchWithStats });

  } catch (error) {
    console.error('Ошибка получения закупки:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;