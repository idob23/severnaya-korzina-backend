// src/routes/orders.js
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// GET /api/orders - Получить заказы пользователя
router.get('/', authenticateToken, async (req, res) => {
  try {
    const { page = 1, limit = 10, status } = req.query;
    
    const where = {
      userId: req.user.id,
      ...(status && status !== 'all' && { status })
    };

    const orders = await prisma.order.findMany({
      where,
      include: {
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
    });

    const total = await prisma.order.count({ where });

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

// GET /api/orders/:id - Получить заказ по ID
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;
    
    const order = await prisma.order.findUnique({
      where: { id: parseInt(id) },
      include: {
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

    // Проверяем права доступа
    if (order.userId !== req.user.id) {
      return res.status(403).json({
        error: 'Доступ запрещен'
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

// POST /api/orders - Создать новый заказ
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { addressId, batchId, items, notes } = req.body;

    if (!addressId || !items || items.length === 0) {
      return res.status(400).json({
        error: 'Адрес и товары обязательны'
      });
    }

    // Проверяем адрес
    const address = await prisma.address.findFirst({
      where: {
        id: addressId,
        userId: req.user.id
      }
    });

    if (!address) {
      return res.status(400).json({
        error: 'Указанный адрес не найден'
      });
    }

    // Вычисляем общую стоимость
    const totalAmount = items.reduce((sum, item) => {
      return sum + (parseFloat(item.price) * item.quantity);
    }, 0);

    // Создаем заказ
    const order = await prisma.order.create({
      data: {
        userId: req.user.id,
        addressId,
        batchId: batchId || null,
        totalAmount,
        notes: notes || null,
        orderItems: {
          create: items.map(item => ({
            productId: item.productId,
            quantity: item.quantity,
            price: parseFloat(item.price)
          }))
        }
      },
      include: {
        address: true,
        batch: true,
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

module.exports = router;