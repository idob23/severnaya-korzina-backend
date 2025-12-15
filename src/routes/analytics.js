// src/routes/analytics.js
// API для аналитики и статистики платформы

const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// Middleware для проверки админа
const adminAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ') 
      ? authHeader.slice(7) 
      : null;

    if (!token) {
      return res.status(401).json({ success: false, error: 'Токен не предоставлен' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role !== 'admin') {
      return res.status(403).json({ success: false, error: 'Недостаточно прав' });
    }

    req.admin = decoded;
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
      return res.status(401).json({ success: false, error: 'Недействительный токен' });
    }
    res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
};

// ==========================================
// ГЛАВНЫЙ ДАШБОРД - ВСЕ КЛЮЧЕВЫЕ МЕТРИКИ
// ==========================================

/**
 * GET /api/analytics/dashboard
 * Возвращает все ключевые метрики для главного дашборда
 */
router.get('/dashboard', adminAuth, async (req, res) => {
  try {
    const now = new Date();
    const startOfToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const startOfLastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
    const endOfLastMonth = new Date(now.getFullYear(), now.getMonth(), 0);

    // Параллельные запросы для всех метрик
    const [
      // Пользователи
      totalUsers,
      activeUsers,
      newUsersThisMonth,
      newUsersLastMonth,
      
      // Заказы
      totalOrders,
      completedOrders,
      ordersThisMonth,
      ordersLastMonth,
      ordersToday,
      
      // Финансы
      totalRevenue,
      revenueThisMonth,
      revenueLastMonth,
      revenueToday,
      
      // Товары
      totalProducts,
      activeProducts,
      
      // Партии
      totalBatches,
      activeBatches,
      
      // Средний чек
      avgOrderAmount
    ] = await Promise.all([
      // Пользователи
      prisma.user.count(),
      prisma.user.count({ where: { isActive: true } }),
      prisma.user.count({ where: { createdAt: { gte: startOfMonth } } }),
      prisma.user.count({ 
        where: { 
          createdAt: { gte: startOfLastMonth, lte: endOfLastMonth } 
        } 
      }),
      
      // Заказы
      prisma.order.count(),
      prisma.order.count({ where: { status: 'delivered' } }),
      prisma.order.count({ where: { createdAt: { gte: startOfMonth } } }),
      prisma.order.count({ 
        where: { 
          createdAt: { gte: startOfLastMonth, lte: endOfLastMonth } 
        } 
      }),
      prisma.order.count({ where: { createdAt: { gte: startOfToday } } }),
      
      // Финансы (только оплаченные/доставленные заказы)
      prisma.order.aggregate({
        _sum: { totalAmount: true },
        where: { status: { in: ['paid', 'shipped', 'delivered'] } }
      }),
      prisma.order.aggregate({
        _sum: { totalAmount: true },
        where: { 
          status: { in: ['paid', 'shipped', 'delivered'] },
          createdAt: { gte: startOfMonth } 
        }
      }),
      prisma.order.aggregate({
        _sum: { totalAmount: true },
        where: { 
          status: { in: ['paid', 'shipped', 'delivered'] },
          createdAt: { gte: startOfLastMonth, lte: endOfLastMonth } 
        }
      }),
      prisma.order.aggregate({
        _sum: { totalAmount: true },
        where: { 
          status: { in: ['paid', 'shipped', 'delivered'] },
          createdAt: { gte: startOfToday } 
        }
      }),
      
      // Товары
      prisma.product.count(),
      prisma.product.count({ where: { isActive: true } }),
      
      // Партии
      prisma.batch.count(),
      prisma.batch.count({ where: { status: { in: ['open', 'collecting'] } } }),
      
      // Средний чек
      prisma.order.aggregate({
        _avg: { totalAmount: true },
        where: { status: { in: ['paid', 'shipped', 'delivered'] } }
      })
    ]);

    // Рассчитываем комиссию (10%)
    const commissionRate = 0.10;
    const totalCommission = (totalRevenue._sum.totalAmount || 0) * commissionRate;
    const commissionThisMonth = (revenueThisMonth._sum.totalAmount || 0) * commissionRate;

    // Рассчитываем ARPU (Average Revenue Per User)
    const arpu = activeUsers > 0 
      ? (totalRevenue._sum.totalAmount || 0) / activeUsers 
      : 0;

    // Рассчитываем рост
    const userGrowth = newUsersLastMonth > 0 
      ? ((newUsersThisMonth - newUsersLastMonth) / newUsersLastMonth * 100).toFixed(1)
      : 100;
    
    const orderGrowth = ordersLastMonth > 0 
      ? ((ordersThisMonth - ordersLastMonth) / ordersLastMonth * 100).toFixed(1)
      : 100;
    
    const revenueGrowthValue = (revenueLastMonth._sum.totalAmount || 0) > 0 
      ? (((revenueThisMonth._sum.totalAmount || 0) - (revenueLastMonth._sum.totalAmount || 0)) / (revenueLastMonth._sum.totalAmount || 1) * 100).toFixed(1)
      : 100;

    res.json({
      success: true,
      dashboard: {
        // Ключевые показатели
        summary: {
          gmv: totalRevenue._sum.totalAmount || 0,
          commission: totalCommission,
          totalOrders: totalOrders,
          totalUsers: totalUsers,
          avgOrderAmount: avgOrderAmount._avg.totalAmount || 0,
          arpu: arpu
        },
        
        // Пользователи
        users: {
          total: totalUsers,
          active: activeUsers,
          newThisMonth: newUsersThisMonth,
          newLastMonth: newUsersLastMonth,
          growth: parseFloat(userGrowth)
        },
        
        // Заказы
        orders: {
          total: totalOrders,
          completed: completedOrders,
          thisMonth: ordersThisMonth,
          lastMonth: ordersLastMonth,
          today: ordersToday,
          growth: parseFloat(orderGrowth)
        },
        
        // Финансы
        finance: {
          totalGMV: totalRevenue._sum.totalAmount || 0,
          gmvThisMonth: revenueThisMonth._sum.totalAmount || 0,
          gmvLastMonth: revenueLastMonth._sum.totalAmount || 0,
          gmvToday: revenueToday._sum.totalAmount || 0,
          totalCommission: totalCommission,
          commissionThisMonth: commissionThisMonth,
          avgOrderAmount: avgOrderAmount._avg.totalAmount || 0,
          growth: parseFloat(revenueGrowthValue)
        },
        
        // Товары
        products: {
          total: totalProducts,
          active: activeProducts
        },
        
        // Партии
        batches: {
          total: totalBatches,
          active: activeBatches
        }
      },
      generatedAt: new Date().toISOString()
    });

  } catch (error) {
    console.error('❌ Ошибка получения dashboard:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения статистики'
    });
  }
});

// ==========================================
// ДИНАМИКА ПО ПЕРИОДАМ (для графиков)
// ==========================================

/**
 * GET /api/analytics/trends
 * Возвращает данные для графиков по дням/неделям/месяцам
 */
router.get('/trends', adminAuth, async (req, res) => {
  try {
    const { period = 'daily', days = 30 } = req.query;
    const daysCount = parseInt(days);
    
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - daysCount);
    startDate.setHours(0, 0, 0, 0);

    // Получаем заказы за период
    const orders = await prisma.order.findMany({
      where: {
        createdAt: { gte: startDate },
        status: { in: ['paid', 'shipped', 'delivered'] }
      },
      select: {
        createdAt: true,
        totalAmount: true
      },
      orderBy: { createdAt: 'asc' }
    });

    // Получаем регистрации за период
    const users = await prisma.user.findMany({
      where: {
        createdAt: { gte: startDate }
      },
      select: {
        createdAt: true
      },
      orderBy: { createdAt: 'asc' }
    });

    // Группируем по дням
    const dailyData = {};
    
    // Инициализируем все дни нулями
    for (let i = 0; i < daysCount; i++) {
      const date = new Date(startDate);
      date.setDate(date.getDate() + i);
      const dateKey = date.toISOString().split('T')[0];
      dailyData[dateKey] = {
        date: dateKey,
        orders: 0,
        revenue: 0,
        users: 0
      };
    }

    // Заполняем данными
    orders.forEach(order => {
      const dateKey = order.createdAt.toISOString().split('T')[0];
      if (dailyData[dateKey]) {
        dailyData[dateKey].orders += 1;
        dailyData[dateKey].revenue += parseFloat(order.totalAmount) || 0;
      }
    });

    users.forEach(user => {
      const dateKey = user.createdAt.toISOString().split('T')[0];
      if (dailyData[dateKey]) {
        dailyData[dateKey].users += 1;
      }
    });

    // Преобразуем в массив
    const trendsArray = Object.values(dailyData).map(day => ({
      ...day,
      revenue: Math.round(day.revenue * 100) / 100,
      commission: Math.round(day.revenue * 0.10 * 100) / 100
    }));

    res.json({
      success: true,
      period: period,
      days: daysCount,
      trends: trendsArray
    });

  } catch (error) {
    console.error('❌ Ошибка получения трендов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения трендов'
    });
  }
});

// ==========================================
// ТОП ТОВАРОВ
// ==========================================

/**
 * GET /api/analytics/top-products
 * Возвращает топ товаров по продажам
 */
router.get('/top-products', adminAuth, async (req, res) => {
  try {
    const { limit = 20 } = req.query;

    const topProducts = await prisma.orderItem.groupBy({
      by: ['productId'],
      _sum: {
        quantity: true,
        price: true
      },
      _count: {
        id: true
      },
      orderBy: {
        _sum: {
          price: 'desc'
        }
      },
      take: parseInt(limit)
    });

    // Обогащаем данными о товарах
    const enrichedProducts = await Promise.all(
      topProducts.map(async (item) => {
        const product = await prisma.product.findUnique({
          where: { id: item.productId },
          select: { 
            id: true, 
            name: true, 
            price: true, 
            unit: true,
            category: { select: { name: true } }
          }
        });
        
        return {
          productId: item.productId,
          name: product?.name || 'Удалённый товар',
          category: product?.category?.name || 'Без категории',
          currentPrice: product?.price || 0,
          unit: product?.unit || 'шт',
          totalSold: item._sum.quantity || 0,
          totalRevenue: item._sum.price || 0,
          ordersCount: item._count.id
        };
      })
    );

    res.json({
      success: true,
      topProducts: enrichedProducts
    });

  } catch (error) {
    console.error('❌ Ошибка получения топ товаров:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения топ товаров'
    });
  }
});

// ==========================================
// ТОП КАТЕГОРИЙ
// ==========================================

/**
 * GET /api/analytics/top-categories
 * Возвращает топ категорий по продажам
 */
router.get('/top-categories', adminAuth, async (req, res) => {
  try {
    // Получаем все order items с продуктами и категориями
    const orderItems = await prisma.orderItem.findMany({
      include: {
        product: {
          include: {
            category: true
          }
        }
      }
    });

    // Группируем по категориям
    const categoryStats = {};
    
    orderItems.forEach(item => {
      const categoryName = item.product?.category?.name || 'Без категории';
      const categoryId = item.product?.category?.id || 0;
      
      if (!categoryStats[categoryId]) {
        categoryStats[categoryId] = {
          categoryId: categoryId,
          name: categoryName,
          totalRevenue: 0,
          totalQuantity: 0,
          ordersCount: 0
        };
      }
      
      categoryStats[categoryId].totalRevenue += parseFloat(item.price) * item.quantity;
      categoryStats[categoryId].totalQuantity += item.quantity;
      categoryStats[categoryId].ordersCount += 1;
    });

    // Сортируем по выручке
    const sortedCategories = Object.values(categoryStats)
      .sort((a, b) => b.totalRevenue - a.totalRevenue);

    res.json({
      success: true,
      topCategories: sortedCategories
    });

  } catch (error) {
    console.error('❌ Ошибка получения топ категорий:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения топ категорий'
    });
  }
});

// ==========================================
// ТОП КЛИЕНТОВ
// ==========================================

/**
 * GET /api/analytics/top-customers
 * Возвращает топ клиентов по сумме заказов
 */
router.get('/top-customers', adminAuth, async (req, res) => {
  try {
    const { limit = 20 } = req.query;

    const topCustomers = await prisma.order.groupBy({
      by: ['userId'],
      _sum: {
        totalAmount: true
      },
      _count: {
        id: true
      },
      where: {
        status: { in: ['paid', 'shipped', 'delivered'] }
      },
      orderBy: {
        _sum: {
          totalAmount: 'desc'
        }
      },
      take: parseInt(limit)
    });

    // Обогащаем данными о пользователях
    const enrichedCustomers = await Promise.all(
      topCustomers.map(async (item) => {
        const user = await prisma.user.findUnique({
          where: { id: item.userId },
          select: { 
            id: true,
            firstName: true, 
            lastName: true, 
            phone: true,
            createdAt: true
          }
        });
        
        return {
          userId: item.userId,
          name: user ? `${user.firstName} ${user.lastName || ''}`.trim() : 'Удалённый пользователь',
          phone: user?.phone || '',
          registeredAt: user?.createdAt,
          totalSpent: item._sum.totalAmount || 0,
          ordersCount: item._count.id,
          avgOrderAmount: item._count.id > 0 
            ? (item._sum.totalAmount || 0) / item._count.id 
            : 0
        };
      })
    );

    res.json({
      success: true,
      topCustomers: enrichedCustomers
    });

  } catch (error) {
    console.error('❌ Ошибка получения топ клиентов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения топ клиентов'
    });
  }
});

// ==========================================
// СТАТИСТИКА ПО СТАТУСАМ ЗАКАЗОВ
// ==========================================

/**
 * GET /api/analytics/order-statuses
 * Возвращает распределение заказов по статусам
 */
router.get('/order-statuses', adminAuth, async (req, res) => {
  try {
    const statusCounts = await prisma.order.groupBy({
      by: ['status'],
      _count: {
        id: true
      },
      _sum: {
        totalAmount: true
      }
    });

    const statusLabels = {
      'pending': 'Ожидает оплаты',
      'paid': 'Оплачен',
      'shipped': 'В доставке',
      'delivered': 'Доставлен',
      'cancelled': 'Отменён'
    };

    const formattedStatuses = statusCounts.map(status => ({
      status: status.status,
      label: statusLabels[status.status] || status.status,
      count: status._count.id,
      totalAmount: status._sum.totalAmount || 0
    }));

    res.json({
      success: true,
      orderStatuses: formattedStatuses
    });

  } catch (error) {
    console.error('❌ Ошибка получения статусов заказов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения статусов заказов'
    });
  }
});

// ==========================================
// RETENTION (Возвращаемость клиентов)
// ==========================================

/**
 * GET /api/analytics/retention
 * Возвращает данные о retention клиентов
 */
router.get('/retention', adminAuth, async (req, res) => {
  try {
    // Получаем всех пользователей с заказами
    const usersWithOrders = await prisma.user.findMany({
      where: {
        orders: {
          some: {
            status: { in: ['paid', 'shipped', 'delivered'] }
          }
        }
      },
      include: {
        orders: {
          where: {
            status: { in: ['paid', 'shipped', 'delivered'] }
          },
          select: {
            createdAt: true
          },
          orderBy: {
            createdAt: 'asc'
          }
        }
      }
    });

    // Считаем статистику
    let oneOrder = 0;
    let twoOrders = 0;
    let threeOrders = 0;
    let fourPlusOrders = 0;

    usersWithOrders.forEach(user => {
      const ordersCount = user.orders.length;
      if (ordersCount === 1) oneOrder++;
      else if (ordersCount === 2) twoOrders++;
      else if (ordersCount === 3) threeOrders++;
      else if (ordersCount >= 4) fourPlusOrders++;
    });

    const totalWithOrders = usersWithOrders.length;
    const repeatCustomers = twoOrders + threeOrders + fourPlusOrders;
    const retentionRate = totalWithOrders > 0 
      ? (repeatCustomers / totalWithOrders * 100).toFixed(1) 
      : 0;

    res.json({
      success: true,
      retention: {
        totalCustomers: totalWithOrders,
        repeatCustomers: repeatCustomers,
        retentionRate: parseFloat(retentionRate),
        distribution: {
          oneOrder: { count: oneOrder, percent: totalWithOrders > 0 ? (oneOrder / totalWithOrders * 100).toFixed(1) : 0 },
          twoOrders: { count: twoOrders, percent: totalWithOrders > 0 ? (twoOrders / totalWithOrders * 100).toFixed(1) : 0 },
          threeOrders: { count: threeOrders, percent: totalWithOrders > 0 ? (threeOrders / totalWithOrders * 100).toFixed(1) : 0 },
          fourPlusOrders: { count: fourPlusOrders, percent: totalWithOrders > 0 ? (fourPlusOrders / totalWithOrders * 100).toFixed(1) : 0 }
        }
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения retention:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения retention'
    });
  }
});

// ==========================================
// СРАВНЕНИЕ С МЕСТНЫМИ МАГАЗИНАМИ (экономия)
// ==========================================

/**
 * GET /api/analytics/savings
 * Возвращает данные об экономии клиентов
 */
router.get('/savings', adminAuth, async (req, res) => {
  try {
    // Получаем общую сумму заказов
    const totalOrdered = await prisma.order.aggregate({
      _sum: { totalAmount: true },
      where: { status: { in: ['paid', 'shipped', 'delivered'] } }
    });

    const gmv = totalOrdered._sum.totalAmount || 0;
    
    // Предполагаемая наценка местных магазинов 60-80%
    // Мы берём среднюю 70%
    const localStoreMarkup = 1.7;
    const estimatedLocalPrice = gmv * localStoreMarkup;
    const totalSavings = estimatedLocalPrice - gmv;
    const savingsPercent = gmv > 0 ? ((totalSavings / estimatedLocalPrice) * 100).toFixed(1) : 0;

    // Средняя экономия на заказ
    const ordersCount = await prisma.order.count({
      where: { status: { in: ['paid', 'shipped', 'delivered'] } }
    });
    const avgSavingsPerOrder = ordersCount > 0 ? totalSavings / ordersCount : 0;

    res.json({
      success: true,
      savings: {
        totalGMV: gmv,
        estimatedLocalPrice: estimatedLocalPrice,
        totalSavings: totalSavings,
        savingsPercent: parseFloat(savingsPercent),
        avgSavingsPerOrder: avgSavingsPerOrder,
        ordersCount: ordersCount,
        assumptions: {
          localStoreMarkup: '70%',
          description: 'Оценка экономии по сравнению с ценами местных магазинов'
        }
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения экономии:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения экономии'
    });
  }
});

// ==========================================
// ЭКСПОРТ ДАННЫХ
// ==========================================

/**
 * GET /api/analytics/export
 * Экспорт данных в JSON (для дальнейшей конвертации в Excel/PDF)
 */
router.get('/export', adminAuth, async (req, res) => {
  try {
    const { format = 'json' } = req.query;

    // Собираем все данные
    const [
      dashboardRes,
      orders,
      users,
      products
    ] = await Promise.all([
      // Dashboard metrics
      prisma.order.aggregate({
        _sum: { totalAmount: true },
        _count: { id: true },
        _avg: { totalAmount: true },
        where: { status: { in: ['paid', 'shipped', 'delivered'] } }
      }),
      
      // Все заказы
      prisma.order.findMany({
        where: { status: { in: ['paid', 'shipped', 'delivered'] } },
        include: {
          user: { select: { firstName: true, lastName: true, phone: true } },
          orderItems: {
            include: {
              product: { select: { name: true, category: { select: { name: true } } } }
            }
          }
        },
        orderBy: { createdAt: 'desc' }
      }),
      
      // Все пользователи
      prisma.user.findMany({
        include: {
          _count: { select: { orders: true } }
        }
      }),
      
      // Товары со статистикой
      prisma.product.findMany({
        include: {
          category: true,
          _count: { select: { orderItems: true } }
        }
      })
    ]);

    const exportData = {
      generatedAt: new Date().toISOString(),
      platform: 'Северная Корзина',
      location: 'Усть-Нера, Якутия',
      
      summary: {
        totalGMV: dashboardRes._sum.totalAmount || 0,
        totalOrders: dashboardRes._count.id,
        avgOrderAmount: dashboardRes._avg.totalAmount || 0,
        totalUsers: users.length,
        activeProducts: products.filter(p => p.isActive).length,
        commission: (dashboardRes._sum.totalAmount || 0) * 0.10
      },
      
      orders: orders.map(o => ({
        id: o.id,
        date: o.createdAt,
        status: o.status,
        amount: o.totalAmount,
        customer: `${o.user?.firstName || ''} ${o.user?.lastName || ''}`.trim(),
        phone: o.user?.phone,
        itemsCount: o.orderItems.length
      })),
      
      users: users.map(u => ({
        id: u.id,
        name: `${u.firstName} ${u.lastName || ''}`.trim(),
        phone: u.phone,
        registeredAt: u.createdAt,
        ordersCount: u._count.orders,
        isActive: u.isActive
      })),
      
      products: products.map(p => ({
        id: p.id,
        name: p.name,
        category: p.category?.name,
        price: p.price,
        isActive: p.isActive,
        soldCount: p._count.orderItems
      }))
    };

    res.json({
      success: true,
      export: exportData
    });

  } catch (error) {
    console.error('❌ Ошибка экспорта:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка экспорта данных'
    });
  }
});

module.exports = router;
