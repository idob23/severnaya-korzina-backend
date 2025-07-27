// src/routes/admin.js - НОВЫЕ МАРШРУТЫ ДЛЯ АДМИН ПАНЕЛИ
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken, requireAdmin } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Все маршруты требуют админских прав
router.use(authenticateToken);
router.use(requireAdmin);

// === СТАТИСТИКА ДАШБОРДА ===

// GET /api/admin/dashboard/stats - Получить статистику для дашборда
router.get('/dashboard/stats', async (req, res) => {
  try {
    console.log('📊 Запрос статистики дашборда');

    // Параллельно получаем всю статистику
    const [
      usersCount,
      activeUsersCount,
      productsCount,
      activeProductsCount,
      ordersCount,
      pendingOrdersCount,
      batchesCount,
      activeBatchesCount,
      totalRevenue,
      todayOrdersCount,
      thisWeekOrdersCount,
      thisMonthOrdersCount,
    ] = await Promise.all([
      // Пользователи
      prisma.user.count(),
      prisma.user.count({ where: { isActive: true } }),
      
      // Товары
      prisma.product.count(),
      prisma.product.count({ where: { isActive: true } }),
      
      // Заказы
      prisma.order.count(),
      prisma.order.count({ where: { status: 'pending' } }),
      
      // Закупки
      prisma.batch.count(),
      prisma.batch.count({ where: { status: 'active' } }),
      
      // Доходы
      prisma.order.aggregate({
        _sum: { totalAmount: true },
        where: { status: { in: ['paid', 'delivered'] } }
      }),
      
      // Заказы за периоды
      prisma.order.count({
        where: {
          createdAt: {
            gte: new Date(new Date().setHours(0, 0, 0, 0))
          }
        }
      }),
      prisma.order.count({
        where: {
          createdAt: {
            gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
          }
        }
      }),
      prisma.order.count({
        where: {
          createdAt: {
            gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1)
          }
        }
      }),
    ]);

    // Получаем последние заказы
    const recentOrders = await prisma.order.findMany({
      take: 10,
      orderBy: { createdAt: 'desc' },
      include: {
        user: {
          select: {
            firstName: true,
            lastName: true,
            phone: true
          }
        },
        orderItems: {
          include: {
            product: {
              select: {
                name: true
              }
            }
          }
        }
      }
    });

    // Получаем популярные товары
    const popularProducts = await prisma.orderItem.groupBy({
      by: ['productId'],
      _sum: { quantity: true },
      _count: { productId: true },
      orderBy: { _sum: { quantity: 'desc' } },
      take: 5
    });

    const popularProductsWithDetails = await Promise.all(
      popularProducts.map(async (item) => {
        const product = await prisma.product.findUnique({
          where: { id: item.productId },
          select: { name: true, price: true }
        });
        return {
          ...product,
          totalSold: item._sum.quantity,
          ordersCount: item._count.productId
        };
      })
    );

    // Статистика по статусам заказов
    const orderStatusStats = await prisma.order.groupBy({
      by: ['status'],
      _count: { status: true }
    });

    const stats = {
      users: {
        total: usersCount,
        active: activeUsersCount,
        inactive: usersCount - activeUsersCount
      },
      products: {
        total: productsCount,
        active: activeProductsCount,
        inactive: productsCount - activeProductsCount
      },
      orders: {
        total: ordersCount,
        pending: pendingOrdersCount,
        today: todayOrdersCount,
        thisWeek: thisWeekOrdersCount,
        thisMonth: thisMonthOrdersCount,
        statusBreakdown: orderStatusStats.reduce((acc, item) => {
          acc[item.status] = item._count.status;
          return acc;
        }, {})
      },
      batches: {
        total: batchesCount,
        active: activeBatchesCount,
        completed: batchesCount - activeBatchesCount
      },
      revenue: {
        total: totalRevenue._sum.totalAmount || 0,
        currency: 'RUB'
      },
      recentOrders: recentOrders.map(order => ({
        id: order.id,
        customerName: `${order.user.firstName} ${order.user.lastName || ''}`.trim(),
        customerPhone: order.user.phone,
        totalAmount: order.totalAmount,
        status: order.status,
        itemsCount: order.orderItems.length,
        createdAt: order.createdAt
      })),
      popularProducts: popularProductsWithDetails
    };

    console.log('✅ Статистика дашборда получена');
    res.json({
      success: true,
      stats
    });

  } catch (error) {
    console.error('❌ Ошибка получения статистики:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === УПРАВЛЕНИЕ ПОЛЬЗОВАТЕЛЯМИ ===

// GET /api/admin/users - Получить всех пользователей с поиском и пагинацией
router.get('/users', async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 20, 
      search = '', 
      status = 'all',
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const skip = (parseInt(page) - 1) * parseInt(limit);
    const take = parseInt(limit);

    // Формируем условия поиска
    const where = {
      ...(status !== 'all' && { 
        isActive: status === 'active' 
      }),
      ...(search && {
        OR: [
          { firstName: { contains: search, mode: 'insensitive' } },
          { lastName: { contains: search, mode: 'insensitive' } },
          { phone: { contains: search } },
          { email: { contains: search, mode: 'insensitive' } }
        ]
      })
    };

    // Получаем пользователей
    const [users, total] = await Promise.all([
      prisma.user.findMany({
        where,
        include: {
          addresses: true,
          _count: {
            select: {
              orders: true
            }
          }
        },
        orderBy: {
          [sortBy]: sortOrder
        },
        skip,
        take
      }),
      prisma.user.count({ where })
    ]);

    res.json({
      success: true,
      users: users.map(user => ({
        id: user.id,
        phone: user.phone,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        isActive: user.isActive,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        addressesCount: user.addresses.length,
        ordersCount: user._count.orders
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения пользователей:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/admin/users/:id/status - Изменить статус пользователя
router.put('/users/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { isActive } = req.body;

    const user = await prisma.user.update({
      where: { id: parseInt(id) },
      data: { isActive: Boolean(isActive) },
      select: {
        id: true,
        phone: true,
        firstName: true,
        lastName: true,
        isActive: true
      }
    });

    console.log(`✅ Статус пользователя ${user.id} изменен на ${isActive}`);

    res.json({
      success: true,
      message: `Пользователь ${isActive ? 'активирован' : 'деактивирован'}`,
      user
    });

  } catch (error) {
    console.error('❌ Ошибка изменения статуса пользователя:', error);
    
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Пользователь не найден'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === УПРАВЛЕНИЕ ЗАКАЗАМИ ===

// GET /api/admin/orders - Получить все заказы с фильтрацией
router.get('/orders', async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 20, 
      status = 'all',
      userId,
      dateFrom,
      dateTo,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const skip = (parseInt(page) - 1) * parseInt(limit);
    const take = parseInt(limit);

    // Формируем условия фильтрации
    const where = {
      ...(status !== 'all' && { status }),
      ...(userId && { userId: parseInt(userId) }),
      ...(dateFrom || dateTo) && {
        createdAt: {
          ...(dateFrom && { gte: new Date(dateFrom) }),
          ...(dateTo && { lte: new Date(dateTo) })
        }
      }
    };

    // Получаем заказы
    const [orders, total] = await Promise.all([
      prisma.order.findMany({
        where,
        include: {
          user: {
            select: {
              firstName: true,
              lastName: true,
              phone: true
            }
          },
          address: {
            select: {
              title: true,
              address: true
            }
          },
          batch: {
            select: {
              title: true,
              status: true
            }
          },
          orderItems: {
            include: {
              product: {
                select: {
                  name: true,
                  unit: true
                }
              }
            }
          }
        },
        orderBy: {
          [sortBy]: sortOrder
        },
        skip,
        take
      }),
      prisma.order.count({ where })
    ]);

    res.json({
      success: true,
      orders,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения заказов:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/admin/orders/:id/status - Изменить статус заказа
router.put('/orders/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['pending', 'confirmed', 'paid', 'shipped', 'delivered', 'cancelled'];
    
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        error: 'Недопустимый статус заказа'
      });
    }

    const order = await prisma.order.update({
      where: { id: parseInt(id) },
      data: { status },
      include: {
        user: {
          select: {
            firstName: true,
            lastName: true,
            phone: true
          }
        }
      }
    });

    console.log(`✅ Статус заказа ${order.id} изменен на ${status}`);

    res.json({
      success: true,
      message: `Статус заказа изменен на ${status}`,
      order
    });

  } catch (error) {
    console.error('❌ Ошибка изменения статуса заказа:', error);
    
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Заказ не найден'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === УПРАВЛЕНИЕ ТОВАРАМИ ===

// GET /api/admin/products - Получить все товары с фильтрацией
router.get('/products', async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 20, 
      categoryId,
      search = '',
      status = 'all',
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const skip = (parseInt(page) - 1) * parseInt(limit);
    const take = parseInt(limit);

    // Формируем условия поиска
    const where = {
      ...(categoryId && { categoryId: parseInt(categoryId) }),
      ...(status !== 'all' && { 
        isActive: status === 'active' 
      }),
      ...(search && {
        OR: [
          { name: { contains: search, mode: 'insensitive' } },
          { description: { contains: search, mode: 'insensitive' } }
        ]
      })
    };

    // Получаем товары
    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        include: {
          category: {
            select: {
              name: true
            }
          },
          _count: {
            select: {
              orderItems: true
            }
          }
        },
        orderBy: {
          [sortBy]: sortOrder
        },
        skip,
        take
      }),
      prisma.product.count({ where })
    ]);

    res.json({
      success: true,
      products: products.map(product => ({
        ...product,
        categoryName: product.category.name,
        ordersCount: product._count.orderItems
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения товаров:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/admin/products - Создать новый товар
router.post('/products', async (req, res) => {
  try {
    const { 
      categoryId, 
      name, 
      description, 
      price, 
      unit, 
      minQuantity, 
      maxQuantity,
      imageUrl 
    } = req.body;

    if (!categoryId || !name || !price || !unit) {
      return res.status(400).json({
        success: false,
        error: 'Обязательные поля: categoryId, name, price, unit'
      });
    }

    const product = await prisma.product.create({
      data: {
        categoryId: parseInt(categoryId),
        name,
        description,
        price: parseFloat(price),
        unit,
        minQuantity: parseInt(minQuantity) || 1,
        maxQuantity: maxQuantity ? parseInt(maxQuantity) : null,
        imageUrl
      },
      include: {
        category: {
          select: {
            name: true
          }
        }
      }
    });

    console.log(`✅ Товар создан: ${product.name} (ID: ${product.id})`);

    res.status(201).json({
      success: true,
      message: 'Товар создан успешно',
      product: {
        ...product,
        categoryName: product.category.name
      }
    });

  } catch (error) {
    console.error('❌ Ошибка создания товара:', error);
    
    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Категория не найдена'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/admin/products/:id - Обновить товар
router.put('/products/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = { ...req.body };

    // Преобразуем типы данных
    if (updateData.categoryId) updateData.categoryId = parseInt(updateData.categoryId);
    if (updateData.price) updateData.price = parseFloat(updateData.price);
    if (updateData.minQuantity) updateData.minQuantity = parseInt(updateData.minQuantity);
    if (updateData.maxQuantity) updateData.maxQuantity = parseInt(updateData.maxQuantity);

    const product = await prisma.product.update({
      where: { id: parseInt(id) },
      data: updateData,
      include: {
        category: {
          select: {
            name: true
          }
        }
      }
    });

    console.log(`✅ Товар обновлен: ${product.name} (ID: ${product.id})`);

    res.json({
      success: true,
      message: 'Товар обновлен успешно',
      product: {
        ...product,
        categoryName: product.category.name
      }
    });

  } catch (error) {
    console.error('❌ Ошибка обновления товара:', error);
    
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Товар не найден'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// DELETE /api/admin/products/:id - Удалить товар
router.delete('/products/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Проверяем, есть ли заказы с этим товаром
    const ordersCount = await prisma.orderItem.count({
      where: { productId: parseInt(id) }
    });

    if (ordersCount > 0) {
      return res.status(400).json({
        success: false,
        error: 'Нельзя удалить товар, который есть в заказах. Деактивируйте его вместо удаления.'
      });
    }

    await prisma.product.delete({
      where: { id: parseInt(id) }
    });

    console.log(`✅ Товар удален: ID ${id}`);

    res.json({
      success: true,
      message: 'Товар удален успешно'
    });

  } catch (error) {
    console.error('❌ Ошибка удаления товара:', error);
    
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Товар не найден'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === УПРАВЛЕНИЕ КАТЕГОРИЯМИ ===

// GET /api/admin/categories - Получить все категории
router.get('/categories', async (req, res) => {
  try {
    const categories = await prisma.category.findMany({
      include: {
        _count: {
          select: {
            products: true
          }
        }
      },
      orderBy: {
        name: 'asc'
      }
    });

    res.json({
      success: true,
      categories: categories.map(category => ({
        ...category,
        productsCount: category._count.products
      }))
    });

  } catch (error) {
    console.error('❌ Ошибка получения категорий:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/admin/categories - Создать новую категорию
router.post('/categories', async (req, res) => {
  try {
    const { name, description, imageUrl } = req.body;

    if (!name) {
      return res.status(400).json({
        success: false,
        error: 'Название категории обязательно'
      });
    }

    const category = await prisma.category.create({
      data: {
        name,
        description,
        imageUrl
      }
    });

    console.log(`✅ Категория создана: ${category.name} (ID: ${category.id})`);

    res.status(201).json({
      success: true,
      message: 'Категория создана успешно',
      category
    });

  } catch (error) {
    console.error('❌ Ошибка создания категории:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === УПРАВЛЕНИЕ ЗАКУПКАМИ ===

// GET /api/admin/batches - Получить все закупки
router.get('/batches', async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 20, 
      status = 'all',
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const skip = (parseInt(page) - 1) * parseInt(limit);
    const take = parseInt(limit);

    const where = {
      ...(status !== 'all' && { status })
    };

    const [batches, total] = await Promise.all([
      prisma.batch.findMany({
        where,
        include: {
          _count: {
            select: {
              orders: true,
              batchItems: true
            }
          }
        },
        orderBy: {
          [sortBy]: sortOrder
        },
        skip,
        take
      }),
      prisma.batch.count({ where })
    ]);

    res.json({
      success: true,
      batches: batches.map(batch => ({
        ...batch,
        ordersCount: batch._count.orders,
        itemsCount: batch._count.batchItems
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения закупок:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/admin/batches - Создать новую закупку
router.post('/batches', async (req, res) => {
  try {
    const { 
      title, 
      description, 
      startDate, 
      endDate, 
      deliveryDate,
      minParticipants,
      maxParticipants,
      pickupAddress 
    } = req.body;

    if (!title || !startDate || !endDate) {
      return res.status(400).json({
        success: false,
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
        minParticipants: parseInt(minParticipants) || 5,
        maxParticipants: maxParticipants ? parseInt(maxParticipants) : null,
        pickupAddress
      }
    });

    console.log(`✅ Закупка создана: ${batch.title} (ID: ${batch.id})`);

    res.status(201).json({
      success: true,
      message: 'Закупка создана успешно',
      batch
    });

  } catch (error) {
    console.error('❌ Ошибка создания закупки:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// PUT /api/admin/batches/:id/status - Изменить статус закупки
router.put('/batches/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['active', 'closed', 'completed', 'cancelled'];
    
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        error: 'Недопустимый статус закупки'
      });
    }

    const batch = await prisma.batch.update({
      where: { id: parseInt(id) },
      data: { status }
    });

    console.log(`✅ Статус закупки ${batch.id} изменен на ${status}`);

    res.json({
      success: true,
      message: `Статус закупки изменен на ${status}`,
      batch
    });

  } catch (error) {
    console.error('❌ Ошибка изменения статуса закупки:', error);
    
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