// src/routes/orders.js - ОБНОВЛЕННАЯ ВЕРСИЯ С АВТООБНОВЛЕНИЕМ СТАТИСТИКИ

const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');
const { 
  checkUserStatus, 
  checkProductAvailability 
} = require('../middleware/safety');
const { updateBatchOnOrderChange } = require('../utils/batchCalculations');

const router = express.Router();
const prisma = new PrismaClient();

// Применяем проверку статуса пользователя ко всем маршрутам
router.use(authenticateToken);
router.use(checkUserStatus);


// === НОВЫЕ ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ОСТАТКАМИ ===

/**
 * Проверяет доступность товаров и уменьшает maxQuantity при создании заказа
 * @param {Array} items - массив товаров для заказа
 * @param {PrismaClient} prisma - инстанс Prisma для транзакций
 * @returns {Promise<void>} - выбрасывает ошибку если товара недостаточно
 */
async function processOrderStock(items, prisma) {
  for (const item of items) {
    const product = await prisma.product.findUnique({
      where: { id: item.productId }
    });

    if (!product) {
      throw new Error(`Товар с ID ${item.productId} не найден`);
    }

    // Если у товара есть ограничение по количеству
    if (product.maxQuantity !== null) {
      if (product.maxQuantity < item.quantity) {
        throw new Error(
          `Товара "${product.name}" осталось только ${product.maxQuantity} ${product.unit}. Вы пытаетесь заказать ${item.quantity}`
        );
      }

      // Уменьшаем остаток
      await prisma.product.update({
        where: { id: item.productId },
        data: {
          maxQuantity: product.maxQuantity - item.quantity
        }
      });
      
      console.log(`📦 Уменьшен остаток товара "${product.name}": было ${product.maxQuantity}, стало ${product.maxQuantity - item.quantity}`);
    }
  }
}

/**
 * Возвращает остатки при отмене заказа
 * @param {number} orderId - ID заказа
 * @param {PrismaClient} prisma - инстанс Prisma
 * @returns {Promise<void>}
 */
async function returnOrderStock(orderId, prisma) {
  const orderItems = await prisma.orderItem.findMany({
    where: { orderId },
    include: { product: true }
  });

  for (const item of orderItems) {
    if (item.product.maxQuantity !== null) {
      await prisma.product.update({
        where: { id: item.productId },
        data: {
          maxQuantity: item.product.maxQuantity + item.quantity
        }
      });
      
      console.log(`✅ Возвращен остаток товара "${item.product.name}": +${item.quantity}`);
    }
  }
}

// === МОДИФИЦИРОВАННЫЙ POST /api/orders - С УПРАВЛЕНИЕМ ОСТАТКАМИ ===
// Заменить существующий POST маршрут на этот:

router.post('/', checkProductAvailability, async (req, res) => {
  const transaction = await prisma.$transaction(async (tx) => {
    try {
      console.log('🔄 Начинаем создание заказа с проверкой остатков...');
      const { addressId, items, notes } = req.body;

      if (!addressId || !items || items.length === 0) {
        throw new Error('Товары обязательны');
      }

      // Проверяем и уменьшаем остатки
      await processOrderStock(items, tx);

      // Проверяем/создаем адрес
      let validAddressId = parseInt(addressId) || 1;
      const addressExists = await tx.address.findFirst({
        where: { 
          id: validAddressId,
          userId: req.user.id 
        }
      });

      if (!addressExists) {
        console.log('⚠️ Адрес не найден, создаем дефолтный...');
        const defaultAddress = await tx.address.create({
          data: {
            userId: req.user.id,
            title: 'Основной адрес',
            address: 'пос. Усть-Нера, ул. Ленина',
            isDefault: true
          }
        });
        validAddressId = defaultAddress.id;
      }

      // Находим активную закупку
      const activeBatch = await tx.batch.findFirst({
  where: { 
    status: { 
      in: ['active', 'collecting']  // ✅ Правильный синтаксис Prisma
    } 
  },
  orderBy: { createdAt: 'desc' }
});

console.log(`🎯 Найдена активная партия: ${activeBatch ? `#${activeBatch.id} (${activeBatch.status})` : 'НЕТ'}`);

      // Считаем общую сумму
      const totalAmount = items.reduce(
        (sum, item) => sum + (parseFloat(item.price) * item.quantity), 
        0
      );

      // Создаем заказ
      const order = await tx.order.create({
        data: {
          userId: req.user.id,
          batchId: activeBatch?.id || null,
          addressId: validAddressId,
          status: 'pending',
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
          orderItems: {
            include: {
              product: true
            }
          }
        }
      });

console.log(`✅ Заказ #${order.id} создан, привязан к партии #${order.batchId}`);

// НЕ вызываем updateBatchOnOrderChange здесь!
      // Она будет вызвана после транзакции

      return order;

    } catch (error) {
      console.error('❌ Ошибка в транзакции:', error);
      throw error;
    }
  }, {
    maxWait: 10000,
    timeout: 20000
  });

  // ВАЖНО: Обновляем статистику ПОСЛЕ успешного завершения транзакции
  if (transaction.batchId) {
    console.log(`📊 Обновляем статистику партии #${transaction.batchId} после создания заказа #${transaction.id}...`);
    
    try {
      await updateBatchOnOrderChange(transaction.id, 'create');
      console.log(`✅ Статистика партии #${transaction.batchId} обновлена`);
    } catch (error) {
      console.error(`⚠️ Ошибка обновления статистики: ${error.message}`);
      // Не прерываем процесс - заказ уже создан
    }
  } else {
    console.log('⚠️ Заказ не привязан к партии, статистика не обновляется');
  }

  res.json({
    success: true,
    order: transaction
  });
});

// GET /api/orders - Получить заказы пользователя
router.get('/', async (req, res) => {
  try {
    const { status, limit = 50 } = req.query;

    // ИСПРАВЛЕНО: Проверяем наличие user и id
    if (!req.user || !req.user.id) {
      console.log('❌ User data missing:', req.user);
      return res.status(401).json({
        error: 'Пользователь не авторизован'
      });
    }

    const whereClause = {
      userId: req.user.id,
      ...(status && { status })
    };

    console.log('🔍 WHERE условие для поиска заказов:', whereClause);

    const orders = await prisma.order.findMany({
      where: whereClause,
      include: {
        address: {
          select: {
            title: true,
            address: true
          }
        },
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
                unit: true,
                imageUrl: true
              }
            }
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      },
      take: parseInt(limit)
    });

       console.log(`✅ Найдено заказов: ${orders.length}`);

    // Преобразуем Decimal в числа
    const ordersData = orders.map(order => ({
      ...order,
      totalAmount: parseFloat(order.totalAmount),
      orderItems: order.orderItems.map(item => ({
        ...item,
        price: parseFloat(item.price)
      }))
    }));

    res.json({
      success: true,
      orders: ordersData
    });

  } catch (error) {
    console.error('❌ Ошибка получения заказов:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/orders/:id - Получить заказ по ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const order = await prisma.order.findFirst({
      where: {
        id: parseInt(id),
        userId: req.user.id // Только заказы текущего пользователя
      },
      include: {
        address: true,
        batch: {
          select: {
            id: true,
            title: true,
            status: true,
            deliveryDate: true
          }
        },
        orderItems: {
          include: {
            product: {
              include: {
                category: {
                  select: {
                    name: true
                  }
                }
              }
            }
          }
        }
      }
    });

    if (!order) {
      return res.status(404).json({
        error: 'Заказ не найден'
      });
    }

    // Преобразуем Decimal в числа
    const orderData = {
      ...order,
      totalAmount: parseFloat(order.totalAmount),
      orderItems: order.orderItems.map(item => ({
        ...item,
        price: parseFloat(item.price)
      }))
    };

    res.json({
      success: true,
      order: orderData
    });

  } catch (error) {
    console.error('❌ Ошибка получения заказа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/orders/:id - Обновить заказ (только статус и заметки)
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { status, notes } = req.body;

    // Проверяем, что заказ принадлежит пользователю
    const existingOrder = await prisma.order.findFirst({
      where: {
        id: parseInt(id),
        userId: req.user.id
      }
    });

    if (!existingOrder) {
      return res.status(404).json({
        error: 'Заказ не найден'
      });
    }

    // Проверяем допустимые статусы для изменения пользователем
    const allowedStatuses = ['pending', 'cancelled'];
    if (status && !allowedStatuses.includes(status)) {
      return res.status(400).json({
        error: 'Недопустимый статус заказа'
      });
    }

    // Обновляем заказ
    const updatedOrder = await prisma.order.update({
      where: { id: parseInt(id) },
      data: {
        ...(status && { status }),
        ...(notes !== undefined && { notes }),
        updatedAt: new Date()
      }
    });

    // Если заказ отменен или изменен статус - обновляем статистику закупки
    if (status && existingOrder.batchId) {
      await updateBatchOnOrderChange(parseInt(id), 'update');
    }

    console.log(`✅ Заказ ${id} обновлен пользователем ${req.user.id}`);

    res.json({
      success: true,
      message: 'Заказ успешно обновлен',
      order: {
        ...updatedOrder,
        totalAmount: parseFloat(updatedOrder.totalAmount)
      }
    });

  } catch (error) {
    console.error('❌ Ошибка обновления заказа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// DELETE /api/orders/:id - Удалить заказ (только если статус pending)
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Проверяем заказ
    const existingOrder = await prisma.order.findFirst({
      where: {
        id: parseInt(id),
        userId: req.user.id,
        status: 'pending' // Можно удалять только неподтвержденные заказы
      }
    });

    if (!existingOrder) {
      return res.status(404).json({
        error: 'Заказ не найден или не может быть удален'
      });
    }

    // Удаляем заказ в транзакции
    await prisma.$transaction(async (tx) => {
      // Удаляем позиции заказа
      await tx.orderItem.deleteMany({
        where: { orderId: parseInt(id) }
      });

      // Удаляем сам заказ
      await tx.order.delete({
        where: { id: parseInt(id) }
      });
    });

    // Обновляем статистику закупки
    if (existingOrder.batchId) {
      await updateBatchOnOrderChange(parseInt(id), 'delete');
    }

    console.log(`✅ Заказ ${id} удален пользователем ${req.user.id}`);

    res.json({
      success: true,
      message: 'Заказ успешно удален'
    });

  } catch (error) {
    console.error('❌ Ошибка удаления заказа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === НОВЫЙ ENDPOINT: PUT /api/orders/:id/cancel - Отмена заказа с возвратом остатков ===
// Добавить после других роутов:

router.put('/:id/cancel', async (req, res) => {
  const transaction = await prisma.$transaction(async (tx) => {
    try {
      const orderId = parseInt(req.params.id);
      
      // Получаем заказ
      const order = await tx.order.findFirst({
        where: { 
          id: orderId,
          userId: req.user.id
        }
      });

      if (!order) {
        throw new Error('Заказ не найден');
      }

      // Проверяем, можно ли отменить
      if (!['pending', 'processing', 'paid'].includes(order.status)) {
        throw new Error(`Заказ в статусе "${order.status}" нельзя отменить`);
      }

      // Возвращаем остатки
      await returnOrderStock(orderId, tx);

      // Обновляем статус
      const updatedOrder = await tx.order.update({
        where: { id: orderId },
        data: { status: 'cancelled' }
      });

      // Обновляем статистику закупки
      if (order.batchId) {
        await updateBatchOnOrderChange(orderId, 'cancel');
      }

      console.log(`✅ Заказ #${orderId} отменен, остатки возвращены`);
      return updatedOrder;

    } catch (error) {
      console.error('❌ Ошибка отмены заказа:', error);
      throw error;
    }
  });

  res.json({
    success: true,
    message: 'Заказ отменен, остатки товаров восстановлены',
    order: transaction
  });
});

// === НОВЫЙ ENDPOINT: POST /api/orders/check-availability ===
// Добавить перед module.exports:

router.post('/check-availability', async (req, res) => {
  try {
    const { items } = req.body;
    const availability = [];
    let allAvailable = true;

    for (const item of items) {
      const product = await prisma.product.findUnique({
        where: { id: item.productId }
      });

      if (!product) {
        availability.push({
          productId: item.productId,
          available: false,
          message: 'Товар не найден'
        });
        allAvailable = false;
        continue;
      }

      const isAvailable = product.maxQuantity === null || 
                         product.maxQuantity >= item.quantity;
      
      availability.push({
        productId: item.productId,
        name: product.name,
        requested: item.quantity,
        available: isAvailable,
        inStock: product.maxQuantity,
        message: !isAvailable 
          ? `Осталось только ${product.maxQuantity} ${product.unit}` 
          : 'Доступно'
      });

      if (!isAvailable) allAvailable = false;
    }

    res.json({
      success: true,
      allAvailable,
      items: availability
    });
  } catch (error) {
    console.error('❌ Ошибка проверки доступности:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка проверки доступности'
    });
  }
});

module.exports = router;
