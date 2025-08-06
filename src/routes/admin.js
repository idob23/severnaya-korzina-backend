// src/routes/admin.js - НОВЫЙ ФАЙЛ ДЛЯ АДМИНСКИХ МАРШРУТОВ
const express = require('express');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const router = express.Router();
const prisma = new PrismaClient();

// Middleware для проверки админских прав
const adminAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ') 
      ? authHeader.slice(7) 
      : null;

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'Токен не предоставлен'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Недостаточно прав'
      });
    }

    req.admin = decoded;
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: 'Недействительный токен'
      });
    }
    
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
};

// GET /api/admin/orders - Получить все заказы
router.get('/orders', adminAuth, async (req, res) => {
  try {
    const { page = 1, limit = 20, status } = req.query;
    const skip = (page - 1) * limit;

    const where = status ? { status } : {};

    const orders = await prisma.order.findMany({
      where,
      skip,
      take: parseInt(limit),
      include: {
        user: {
          select: {
            id: true,
            phone: true,
            firstName: true,
            lastName: true
          }
        },
        items: {
          include: {
            product: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    const total = await prisma.order.count({ where });

    res.json({
      success: true,
      orders: orders.map(order => ({
        id: order.id,
        orderNumber: order.orderNumber,
        status: order.status,
        totalAmount: order.totalAmount,
        prepaymentAmount: order.prepaymentAmount,
        deliveryDate: order.deliveryDate,
        createdAt: order.createdAt,
        user: {
          id: order.user.id,
          phone: order.user.phone,
          name: `${order.user.firstName} ${order.user.lastName || ''}`.trim()
        },
        itemsCount: order.items.length,
        items: order.items.map(item => ({
          id: item.id,
          productName: item.product.name,
          quantity: item.quantity,
          price: item.price
        }))
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения заказов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения заказов'
    });
  }
});

// GET /api/admin/batches - Получить все партии
router.get('/batches', adminAuth, async (req, res) => {
  try {
    const { page = 1, limit = 20, status } = req.query;
    const skip = (page - 1) * limit;

    const where = status ? { status } : {};

    const batches = await prisma.batch.findMany({
      where,
      skip,
      take: parseInt(limit),
      include: {
        _count: {
          select: {
            orders: true,
            products: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    const total = await prisma.batch.count({ where });

    res.json({
      success: true,
      batches: batches.map(batch => ({
        id: batch.id,
        name: batch.name,
        status: batch.status,
        startDate: batch.startDate,
        endDate: batch.endDate,
        deliveryDate: batch.deliveryDate,
        minAmount: batch.minAmount,
        currentAmount: batch.currentAmount,
        createdAt: batch.createdAt,
        ordersCount: batch._count.orders,
        productsCount: batch._count.products
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения партий:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения партий'
    });
  }
});

// POST /api/admin/batches - Создать новую партию
router.post('/batches', adminAuth, async (req, res) => {
  try {
    const { name, startDate, endDate, deliveryDate, minAmount } = req.body;

    const batch = await prisma.batch.create({
      data: {
        name,
        status: 'ACTIVE',
        startDate: new Date(startDate),
        endDate: new Date(endDate),
        deliveryDate: new Date(deliveryDate),
        minAmount: parseFloat(minAmount),
        currentAmount: 0
      }
    });

    res.json({
      success: true,
      message: 'Партия создана успешно',
      batch
    });
  } catch (error) {
    console.error('❌ Ошибка создания партии:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка создания партии'
    });
  }
});

// PUT /api/admin/batches/:id/status - Обновить статус партии
router.put('/batches/:id/status', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const batch = await prisma.batch.update({
      where: { id: parseInt(id) },
      data: { status }
    });

    res.json({
      success: true,
      message: 'Статус партии обновлен',
      batch
    });
  } catch (error) {
    console.error('❌ Ошибка обновления статуса партии:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления статуса партии'
    });
  }
});

// GET /api/admin/products - Получить все товары для админа
router.get('/products', adminAuth, async (req, res) => {
  try {
    const { page = 1, limit = 20, search } = req.query;
    const skip = (page - 1) * limit;

    const where = search ? {
      OR: [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } }
      ]
    } : {};

    const products = await prisma.product.findMany({
      where,
      skip,
      take: parseInt(limit),
      include: {
        category: true,
        _count: {
          select: {
            orderItems: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    const total = await prisma.product.count({ where });

    res.json({
      success: true,
      products: products.map(product => ({
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        unit: product.unit,
        minQuantity: product.minQuantity,
        available: product.available,
        imageUrl: product.imageUrl,
        category: product.category ? {
          id: product.category.id,
          name: product.category.name
        } : null,
        ordersCount: product._count.orderItems,
        createdAt: product.createdAt
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения товаров:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения товаров'
    });
  }
});

// POST /api/admin/products - Создать новый товар
router.post('/products', adminAuth, async (req, res) => {
  try {
    const { 
      name, 
      description, 
      price, 
      unit, 
      minQuantity, 
      categoryId,
      imageUrl 
    } = req.body;

    const product = await prisma.product.create({
      data: {
        name,
        description,
        price: parseFloat(price),
        unit,
        minQuantity: parseFloat(minQuantity),
        categoryId: categoryId ? parseInt(categoryId) : null,
        imageUrl,
        available: true
      },
      include: {
        category: true
      }
    });

    res.json({
      success: true,
      message: 'Товар создан успешно',
      product
    });
  } catch (error) {
    console.error('❌ Ошибка создания товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка создания товара'
    });
  }
});

// PUT /api/admin/products/:id - Обновить товар
router.put('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Преобразуем числовые поля
    if (updateData.price) updateData.price = parseFloat(updateData.price);
    if (updateData.minQuantity) updateData.minQuantity = parseFloat(updateData.minQuantity);
    if (updateData.categoryId) updateData.categoryId = parseInt(updateData.categoryId);

    const product = await prisma.product.update({
      where: { id: parseInt(id) },
      data: updateData,
      include: {
        category: true
      }
    });

    res.json({
      success: true,
      message: 'Товар обновлен успешно',
      product
    });
  } catch (error) {
    console.error('❌ Ошибка обновления товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления товара'
    });
  }
});

// DELETE /api/admin/products/:id - Удалить товар
router.delete('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.product.delete({
      where: { id: parseInt(id) }
    });

    res.json({
      success: true,
      message: 'Товар удален успешно'
    });
  } catch (error) {
    console.error('❌ Ошибка удаления товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления товара'
    });
  }
});

// GET /api/admin/dashboard/stats - Статистика для dashboard
router.get('/dashboard/stats', adminAuth, async (req, res) => {
  try {
    const [
      totalUsers,
      totalOrders,
      totalProducts,
      activeBatches,
      todayOrders,
      totalRevenue
    ] = await Promise.all([
      prisma.user.count(),
      prisma.order.count(),
      prisma.product.count({ where: { available: true } }),
      prisma.batch.count({ where: { status: 'ACTIVE' } }),
      prisma.order.count({
        where: {
          createdAt: {
            gte: new Date(new Date().setHours(0, 0, 0, 0))
          }
        }
      }),
      prisma.order.aggregate({
        _sum: {
          totalAmount: true
        }
      })
    ]);

    res.json({
      success: true,
      stats: {
        totalUsers,
        totalOrders,
        totalProducts,
        activeBatches,
        todayOrders,
        totalRevenue: totalRevenue._sum.totalAmount || 0
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения статистики:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения статистики'
    });
  }
});

module.exports = router;
