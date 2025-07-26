const express = require('express');
const { PrismaClient } = require('@prisma/client');

const router = express.Router();
const prisma = new PrismaClient();

// GET /api/orders - Получить заказы (для конкретного пользователя или все)
router.get('/', async (req, res) => {
  try {
    const { userId, status, page = 1, limit = 10 } = req.query;
    
    const where = {
      ...(userId && { userId: parseInt(userId) }),
      ...(status && { status })
    };

    const [orders, total] = await Promise.all([
      prisma.order.findMany({
        where,
        include: {
          user: {
            select: {
              id: true,
              phone: true,
              firstName: true,
              lastName: true
            }
          },
          address: true,
          batch: {
            select: {
              id: true,
              title: true,
              status: true
            }
          },
          orderItems: {
            include: {
              product: {
                select: {
                  id: true,
                  name: true,
                  imageUrl: true,
                  unit: true
                }
              }
            }
          }
        },
        orderBy: {
          createdAt: 'desc'
        },
        skip: (parseInt(page) - 1) * parseInt(limit),
        take: parseInt(limit)
      }),
      prisma.order.count({ where })
    ]);

    res.json({
      orders,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('Ошибка получения заказов:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/orders - Создать новый заказ
router.post('/', async (req, res) => {
  try {
    const { userId, batchId, addressId, items, notes } = req.body;

    if (!userId || !addressId || !items || items.length === 0) {
      return res.status(400).json({
        error: 'Обязательные поля: userId, addressId, items'
      });
    }

    // Рассчитываем общую стоимость
    let totalAmount = 0;
    for (const item of items) {
      const product = await prisma.product.findUnique({
        where: { id: item.productId }
      });
      
      if (!product) {
        return res.status(400).json({
          error: `Товар с ID ${item.productId} не найден`
        });
      }
      
      totalAmount += parseFloat(product.price) * item.quantity;
    }

    // Создаем заказ с позициями
    const order = await prisma.order.create({
      data: {
        userId,
        batchId,
        addressId,
        totalAmount,
        notes,
        orderItems: {
          create: items.map(item => ({
            productId: item.productId,
            quantity: item.quantity,
            price: item.price
          }))
        }
      },
      include: {
        user: {
          select: {
            id: true,
            phone: true,
            firstName: true,
            lastName: true
          }
        },
        address: true,
        orderItems: {
          include: {
            product: true
          }
        }
      }
    });

    res.status(201).json({
      message: 'Заказ создан успешно',
      order
    });

  } catch (error) {
    console.error('Ошибка создания заказа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/orders/:id - Обновить статус заказа
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['pending', 'confirmed', 'paid', 'shipped', 'delivered', 'cancelled'];
    
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        error: 'Недопустимый статус заказа'
      });
    }

    const order = await prisma.order.update({
      where: { id: parseInt(id) },
      data: { status },
      include: {
        user: {
          select: {
            id: true,
            phone: true,
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
    });

    res.json({
      message: 'Статус заказа обновлен',
      order
    });

  } catch (error) {
    console.error('Ошибка обновления заказа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/orders/:id - Получить заказ по ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const order = await prisma.order.findUnique({
      where: { id: parseInt(id) },
      include: {
        user: {
          select: {
            id: true,
            phone: true,
            firstName: true,
            lastName: true
          }
        },
        address: true,
        batch: true,
        orderItems: {
          include: {
            product: true
          }
        }
      }
    });

    if (!order) {
      return res.status(404).json({
        error: 'Заказ не найден'
      });
    }

    res.json({ order });

  } catch (error) {
    console.error('Ошибка получения заказа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;