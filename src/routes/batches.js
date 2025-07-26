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

    // Добавляем подсчет участников и товаров
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
                lastName: true,
                phone: true
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
        error: 'Закупка не найдена'
      });
    }

    // Добавляем статистику
    const batchWithStats = {
      ...batch,
      participantsCount: batch.orders.length,
      productsCount: batch.batchItems.length,
      isActive: batch.status === 'active' && new Date() < batch.endDate,
      totalOrdersAmount: batch.orders.reduce((sum, order) => sum + parseFloat(order.totalAmount), 0)
    };

    res.json({ batch: batchWithStats });

  } catch (error) {
    console.error('Ошибка получения закупки:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/batches - Создать новую закупку (для админки)
router.post('/', async (req, res) => {
  try {
    const {
      title,
      description,
      startDate,
      endDate,
      deliveryDate,
      minParticipants,
      maxParticipants,
      pickupAddress,
      products
    } = req.body;

    if (!title || !startDate || !endDate) {
      return res.status(400).json({
        error: 'Обязательные поля: title, startDate, endDate'
      });
    }

    const batch = await prisma.batch.create({
      data: {
        title,
        description,
        startDate: new Date(startDate),
        endDate: new Date(endDate),
        deliveryDate: deliveryDate ? new Date(deliveryDate) : null,
        minParticipants: minParticipants || 5,
        maxParticipants,
        pickupAddress,
        batchItems: {
          create: products?.map(product => ({
            productId: product.productId,
            price: product.price,
            discount: product.discount || 0
          })) || []
        }
      },
      include: {
        batchItems: {
          include: {
            product: true
          }
        }
      }
    });

    res.status(201).json({
      message: 'Закупка создана успешно',
      batch
    });

  } catch (error) {
    console.error('Ошибка создания закупки:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/batches/:id - Обновить закупку
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['active', 'closed', 'completed', 'cancelled'];
    
    if (status && !validStatuses.includes(status)) {
      return res.status(400).json({
        error: 'Недопустимый статус закупки'
      });
    }

    const batch = await prisma.batch.update({
      where: { id: parseInt(id) },
      data: req.body,
      include: {
        batchItems: {
          include: {
            product: true
          }
        }
      }
    });

    res.json({
      message: 'Закупка обновлена',
      batch
    });

  } catch (error) {
    console.error('Ошибка обновления закупки:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;