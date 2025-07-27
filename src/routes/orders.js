// src/routes/orders.js - ОБНОВЛЕННАЯ ВЕРСИЯ С ЗАЩИТОЙ
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');
const { 
  checkUserStatus, 
  checkProductAvailability 
} = require('../middleware/safety');

const router = express.Router();
const prisma = new PrismaClient();

// Применяем проверку статуса пользователя ко всем маршрутам
router.use(authenticateToken);
router.use(checkUserStatus);

// POST /api/orders - Создать заказ с проверкой товаров
router.post('/', checkProductAvailability, async (req, res) => {
  try {
    const { addressId, batchId, items, notes } = req.body;

    if (!addressId || !items || items.length === 0) {
      return res.status(400).json({
        error: 'Адрес и товары обязательны'
      });
    }

    // Рассчитываем общую сумму с актуальными ценами
    const totalAmount = items.reduce((sum, item) => {
      return sum + (parseFloat(item.price) * parseInt(item.quantity));
    }, 0);

    // Создаем заказ в транзакции
    const order = await prisma.$transaction(async (tx) => {
      // Создаем заказ
      const newOrder = await tx.order.create({
        data: {
          userId: req.user.id,
          addressId: parseInt(addressId),
          batchId: batchId ? parseInt(batchId) : null,
          totalAmount: parseFloat(totalAmount.toFixed(2)),
          notes: notes || null,
          status: 'pending'
        }
      });

      // Создаем позиции заказа
      await tx.orderItem.createMany({
        data: items.map(item => ({
          orderId: newOrder.id,
          productId: parseInt(item.productId),
          quantity: parseInt(item.quantity),
          price: parseFloat(item.price)
        }))
      });

      return newOrder;
    });

    console.log(`✅ Заказ создан: ${order.id} на сумму ${totalAmount}`);

    res.status(201).json({
      success: true,
      message: 'Заказ создан успешно',
      order: {
        id: order.id,
        totalAmount: order.totalAmount,
        status: order.status,
        createdAt: order.createdAt
      }
    });

  } catch (error) {
    console.error('❌ Ошибка создания заказа:', error);
    
    if (error.code === 'P2003') {
      return res.status(400).json({
        error: 'Неверные данные заказа'
      });
    }

    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// Остальные маршруты...
module.exports = router;