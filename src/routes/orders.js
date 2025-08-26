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

// POST /api/orders - Создать заказ с автообновлением статистики закупки
router.post('/', checkProductAvailability, async (req, res) => {
  try {
    console.log('🔄 Начинаем создание заказа...');
    console.log('📝 Входные данные:', req.body);
    const { addressId, items, notes } = req.body;

    if (!addressId || !items || items.length === 0) {
      return res.status(400).json({
        error: 'Товары обязательны'
      });
    }

    // ✅ ИСПРАВЛЕНИЕ: Проверяем/создаем адрес автоматически
    let validAddressId = parseInt(addressId) || 1;

    console.log(`🏠 Проверяем адрес с ID: ${validAddressId} для пользователя: ${req.user.id}`);

    // Проверяем существует ли адрес у данного пользователя
    const addressExists = await prisma.address.findFirst({
      where: { 
        id: validAddressId,
        userId: req.user.id 
      }
    });

    if (!addressExists) {
      console.log('⚠️ Адрес не найден, создаем дефолтный адрес...');
      
      // Создаем дефолтный адрес для пользователя
      const defaultAddress = await prisma.address.create({
        data: {
          userId: req.user.id,
          title: 'Основной адрес',
          address: 'пос. Усть-Нера',
          isDefault: true
        }
      });
      
      validAddressId = defaultAddress.id;
      console.log(`✅ Создан дефолтный адрес с ID: ${validAddressId}`);
    } else {
      console.log(`✅ Адрес найден: ${addressExists.title}`);
    }

     // ✅ НОВОЕ: Автоматически ищем активную закупку
    const activeBatch = await prisma.batch.findFirst({
      where: {
        status: { in: ['active', 'collecting'] }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    console.log('📦 Результат поиска активной закупки:', activeBatch);

    // Если нет активной закупки - логируем это
    if (!activeBatch) {
      console.log('⚠️ НЕТ АКТИВНОЙ ЗАКУПКИ - создается заказ без привязки');
    } else {
      console.log(`✅ НАЙДЕНА АКТИВНАЯ ЗАКУПКА: ${activeBatch.id} - ${activeBatch.title}`);
      console.log(`📊 Статус закупки: ${activeBatch.status}`);
    }

    // Рассчитываем общую сумму с актуальными ценами
    const totalAmount = items.reduce((sum, item) => {
      return sum + (parseFloat(item.price) * parseInt(item.quantity));
    }, 0);

    console.log(`💰 Общая сумма заказа: ${totalAmount}`);
    console.log(`👤 Пользователь: ${req.user.id}`);
    console.log(`📍 Адрес: ${addressId}`);
    console.log(`🛒 batchId для сохранения: ${activeBatch ? activeBatch.id : 'null'}`);

    // Создаем заказ в транзакции
    const result = await prisma.$transaction(async (tx) => {
      console.log('🔄 Создаем заказ в транзакции...');
      // 1. Создаем заказ
      const newOrder = await tx.order.create({
        data: {
          userId: req.user.id,
          addressId: validAddressId,   //Используем валидный адрес
          batchId: activeBatch ? activeBatch.id : null,    //Автопривязка
          totalAmount: parseFloat(totalAmount.toFixed(2)),
          notes: notes || null,
          status: 'pending'
        }
      });

      console.log(`✅ Заказ создан в БД: ID=${newOrder.id}, batchId=${newOrder.batchId}`);

      // 2. Создаем позиции заказа
      await tx.orderItem.createMany({
        data: items.map(item => ({
          orderId: newOrder.id,
          productId: parseInt(item.productId),
          quantity: parseInt(item.quantity),
          price: parseFloat(item.price)
        }))
      });

      console.log(`✅ Создано ${items.length} позиций заказа`);

      return newOrder;
    });

    console.log(`🎯 Транзакция завершена. Заказ ID: ${result.id}`);

    // 3. Обновляем статистику закупки (если заказ привязан к закупке)
    if (activeBatch) {
      console.log(`🔄 Обновляем статистику закупки ${activeBatch.id}...`);
      await updateBatchOnOrderChange(result.id, 'create');
      console.log(`🔄 Статистика закупки ${activeBatch.id} обновлена после создания заказа ${result.id}`);
    } else {
      console.log('⚠️ Статистика НЕ обновляется - нет активной закупки');
    }

    console.log(`✅ Заказ создан: ${result.id} на сумму ${totalAmount}`);

    res.status(201).json({
      success: true,
      message: 'Заказ создан успешно',
      order: {
        id: result.id,
        totalAmount: result.totalAmount,
        status: result.status,
        createdAt: result.createdAt,
         batchId: activeBatch ? activeBatch.id : null, // ✅ Возвращаем информацию о закупке
        batchTitle: activeBatch ? activeBatch.title : null
      }
    });

  } catch (error) {
    console.error('❌ Ошибка создания заказа:', error);
    console.error('❌ Stack trace:', error.stack);

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

module.exports = router;
