// src/routes/auth.js - ИСПРАВЛЕННАЯ ВЕРСИЯ
const express = require('express');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// POST /api/auth/register - Регистрация пользователя
router.post('/register', async (req, res) => {
  try {
    const { phone, firstName, lastName, email, acceptedTerms} = req.body;

    console.log('🔐 Попытка регистрации:', { phone, firstName, lastName, email });

    if (!phone || !firstName) {
      return res.status(400).json({
        success: false,
        error: 'Телефон и имя обязательны'
      });
    }

    // Проверка согласия с условиями
    if (!acceptedTerms) {
      return res.status(400).json({
        success: false,
        error: 'Необходимо принять условия использования'
      });
    }

    // Проверяем, существует ли пользователь
    const existingUser = await prisma.user.findUnique({
      where: { phone }
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        error: 'Пользователь с таким номером уже существует'
      });
    }

    // Создаем пользователя
    const user = await prisma.user.create({
  data: {
    phone,
    firstName,
    lastName: lastName || null,
    email: email || null,
    acceptedTerms: true,
    acceptedTermsAt: new Date()
  }
});

console.log('✅ Пользователь создан с согласием:', {
  userId: user.id,
  phone: user.phone,
  acceptedAt: user.acceptedTermsAt
});

    // Генерируем JWT токен
    const token = jwt.sign(
      { userId: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.status(201).json({
      success: true,
      message: 'Пользователь зарегистрирован успешно',
      user: {
        id: user.id,
        phone: user.phone,
        name: user.firstName, // ИСПРАВЛЕНО: возвращаем как 'name'
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        createdAt: user.createdAt,
        isActive: user.isActive
      },
      token
    });

  } catch (error) {
    console.error('❌ Ошибка регистрации:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/auth/login - Вход пользователя
router.post('/login', async (req, res) => {
  try {
    const { phone, smsCode } = req.body;

    console.log('🔐 Попытка входа:', { phone, smsCode });

    if (!phone) {
      return res.status(400).json({
        success: false,
        error: 'Номер телефона обязателен'
      });
    }

    // Ищем пользователя
    const user = await prisma.user.findUnique({
      where: { phone },
      include: {
        addresses: true
      }
    });

    if (!user) {
      console.log('❌ Пользователь не найден:', phone);

    // УБРАНО: Автоматическое создание пользователей отключено
      // Теперь пользователь должен сначала зарегистрироваться
      return res.status(404).json({
        success: false,
        error: 'Пользователь с таким номером телефона не найден. Пожалуйста, зарегистрируйтесь.'
      });


    }

    if (!user.isActive) {
      console.log('❌ Аккаунт заблокирован:', phone);
      return res.status(403).json({
        success: false,
        error: 'Аккаунт заблокирован'
      });
    }

    console.log('✅ Пользователь найден:', user.id);

    // Генерируем JWT токен
    const token = jwt.sign(
      { userId: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.json({
      success: true,
      message: 'Вход выполнен успешно',
      user: {
        id: user.id,
        phone: user.phone,
        name: user.firstName,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        createdAt: user.createdAt,
        isActive: user.isActive,
        addresses: user.addresses || []
      },
      token
    });

  } catch (error) {
    console.error('❌ Ошибка входа:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/auth/profile - Получить профиль пользователя
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    console.log('👤 Запрос профиля пользователя:', req.user.id);

    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        addresses: true
      }
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'Пользователь не найден'
      });
    }

    res.json({
      success: true,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.firstName, // ИСПРАВЛЕНО: возвращаем как 'name'
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        createdAt: user.createdAt,
        isActive: user.isActive,
        addresses: user.addresses || []
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения профиля:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/auth/check - Проверка токена
router.get('/check', authenticateToken, async (req, res) => {
  try {
    res.json({
      success: true,
      message: 'Токен действителен',
      user: req.user
    });
  } catch (error) {
    console.error('❌ Ошибка проверки токена:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});
// === АДМИНСКИЕ МЕТОДЫ ===

// POST /api/auth/admin-login - Простой вход для админа
router.post('/admin-login', async (req, res) => {
  try {
    const { login, password } = req.body;

    console.log('🔐 Попытка входа админа:', { login });

    // Простая проверка логина и пароля
    if (login !== 'admin' || password !== 'admin') {
      console.log('❌ Неверный логин или пароль админа');
      return res.status(401).json({
        success: false,
        error: 'Неверный логин или пароль'
      });
    }

    console.log('✅ Админ вошел в систему');

    // Создаем JWT токен для админа
    const token = jwt.sign(
      { 
        userId: 'admin-id', 
        login: 'admin',
        role: 'admin'
      },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      success: true,
      message: 'Вход выполнен успешно',
      user: {
        id: 'admin-id',
        login: 'admin',
        firstName: 'Администратор',
        lastName: 'Системы',
        email: 'admin@severnaya-korzina.ru',
        role: 'admin',
        isActive: true
      },
      token
    });

  } catch (error) {
    console.error('❌ Ошибка входа админа:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/auth/admin-profile - Получить профиль админа
router.get('/admin-profile', async (req, res) => {
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

    res.json({
      success: true,
      user: {
        id: 'admin-id',
        login: 'admin',
        firstName: 'Администратор',
        lastName: 'Системы',
        email: 'admin@severnaya-korzina.ru',
        role: 'admin',
        isActive: true
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения профиля админа:', error);
    
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
});

// GET /api/auth/admin-check - Проверка токена админа
router.get('/admin-check', async (req, res) => {
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

    res.json({
      success: true,
      message: 'Токен действителен',
      user: {
        id: decoded.userId,
        login: decoded.login,
        role: decoded.role
      }
    });

  } catch (error) {
    console.error('❌ Ошибка проверки токена админа:', error);
    
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
});
// GET /api/auth/admin-users - Получить всех пользователей (только для админа)
router.get('/admin-users', async (req, res) => {
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

    // Получаем всех пользователей из БД
    const users = await prisma.user.findMany({
      include: {
        addresses: true,
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
          addressesCount: user.addresses?.length || 0,
        ordersCount: user.orders?.length || 0,
        totalSpent: user.orders?.reduce((sum, order) => sum + (order.totalAmount || 0), 0) || 0
    
      }))
    });

  } catch (error) {
    console.error('❌ Ошибка получения пользователей:', error);
    
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
});
// GET /api/auth/admin-stats - Получить статистику для dashboard (только для админа)
router.get('/admin-stats', async (req, res) => {
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

    // Получаем статистику из БД
    const [
      usersCount,
      ordersCount,
      productsCount,
      batchesCount
    ] = await Promise.all([
      prisma.user.count(),
      prisma.order.count(),
      prisma.product.count(),
      prisma.batch.count()
    ]);

    res.json({
      success: true,
      stats: {
        users: usersCount,
        orders: ordersCount,
        products: productsCount,
        batches: batchesCount
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения статистики:', error);
    
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
});
// GET /api/auth/admin-orders - Получить все заказы (только для админа)
router.get('/admin-orders', async (req, res) => {
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

    // Получаем все заказы из БД
    // НОВЫЙ КОД (с информацией о закупке):
const orders = await prisma.order.findMany({
  include: {
    user: {
      select: {
        id: true,
        firstName: true,
        lastName: true,
        phone: true
      }
    },
    address: true,
    batch: {              // ✅ ДОБАВЛЕНО: информация о закупке
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
            price: true
          }
        }
      }
    }
  },
  orderBy: {
    createdAt: 'desc'
  }
});

    res.json({
      success: true,
      orders: orders.map(order => ({
        id: order.id,
        status: order.status,
        totalAmount: order.totalAmount,
        createdAt: order.createdAt,
        user: order.user,
        address: order.address,
        batchId: order.batchId,        // ✅ ДОБАВЛЕНО
        batch: order.batch,            // ✅ ДОБАВЛЕНО
        itemsCount: order.orderItems.length,
        items: order.orderItems.map(item => ({
          id: item.id,
          productName: item.product.name,
          quantity: item.quantity,
          price: item.price
        }))
      }))
    });

  } catch (error) {
    console.error('❌ Ошибка получения заказов:', error);
    
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
});
// GET /api/auth/admin-products - Получить все товары (только для админа)
router.get('/admin-products', async (req, res) => {
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

    // Получаем все товары из БД
    const products = await prisma.product.findMany({
      include: {
        category: {
          select: {
            id: true,
            name: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.json({
      success: true,
      products: products.map(product => ({
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        unit: product.unit,
        minQuantity: product.minQuantity,
        maxQuantity: product.maxQuantity,
        isActive: product.isActive,
        createdAt: product.createdAt,
        category: product.category
      }))
    });

  } catch (error) {
    console.error('❌ Ошибка получения товаров:', error);
    
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
});

// ИСПРАВЛЕННАЯ функция admin-batches для src/routes/auth.js
// Заменить существующую функцию router.get('/admin-batches', ...)

router.get('/admin-batches', async (req, res) => {
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

    const batches = await prisma.batch.findMany({
      include: {
        orders: {
          select: {
            id: true,
            userId: true,
            status: true,
            totalAmount: true
          }
        },
        batchItems: {
          include: {
            product: {
              select: {
                id: true,
                name: true,
                price: true
              }
            }
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    res.json({
      success: true,
      batches: batches.map(batch => {
        // Подсчет уникальных участников
        const uniqueUserIds = new Set(batch.orders.map(order => order.userId));
        const participantsCount = uniqueUserIds.size;

        // ✅ ИСПРАВЛЕНО: Используем currentAmount из базы данных
        // Это поле правильно обновляется через batchCalculations.js
        const currentAmount = parseFloat(batch.currentAmount || 0);
        const targetAmount = parseFloat(batch.targetAmount || 0);
        
        // Вычисляем процент выполнения
        const progressPercent = targetAmount > 0 
          ? Math.min((currentAmount / targetAmount) * 100, 100) 
          : 0;

        console.log(`📊 Партия ${batch.id}: currentAmount=${currentAmount}, targetAmount=${targetAmount}, progress=${progressPercent}%`);

        return {
          id: batch.id,
          title: batch.title,
          description: batch.description,
          status: batch.status,
          startDate: batch.startDate,
          endDate: batch.endDate,
          deliveryDate: batch.deliveryDate,
          minParticipants: batch.minParticipants,
          maxParticipants: batch.maxParticipants,
          pickupAddress: batch.pickupAddress,
          createdAt: batch.createdAt,
          targetAmount: targetAmount,
          currentAmount: currentAmount, // ✅ Правильные данные из базы
          progressPercent: Math.round(progressPercent),
          participantsCount: participantsCount,
          ordersCount: batch.orders.length,
          productsCount: batch.batchItems.length
        };
      })
    });

  } catch (error) {
    console.error('❌ Ошибка получения партий:', error);
    
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
});

// GET /api/auth/admin-categories - Получить все категории
router.get('/admin-categories', async (req, res) => {
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

    const categories = await prisma.category.findMany({
      orderBy: { name: 'asc' }
    });

    res.json({
      success: true,
      categories: categories
    });

  } catch (error) {
    console.error('❌ Ошибка получения категорий:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/auth/admin-categories - Создать новую категорию
router.post('/admin-categories', async (req, res) => {
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

    const { name, description } = req.body;

    if (!name) {
      return res.status(400).json({
        success: false,
        error: 'Название категории обязательно'
      });
    }

// Проверяем, существует ли категория с таким названием
    const existingCategory = await prisma.category.findFirst({
      where: {
        name: {
          equals: name,
          mode: 'insensitive' // Игнорируем регистр
        }
      }
    });

    if (existingCategory) {
      return res.status(400).json({
        success: false,
        error: 'Категория с таким названием уже существует',
        category: existingCategory // Возвращаем существующую категорию
      });
    }

    const category = await prisma.category.create({
      data: {
        name: name.trim(), // Убираем лишние пробелы
        description: description || null
      }
    });

    res.json({
      success: true,
      category: category
    });

  } catch (error) {
    console.error('❌ Ошибка создания категории:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка создания категории'
    });
  }
});

module.exports = router;
