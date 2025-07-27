// src/server.js - ФИНАЛЬНАЯ ИНТЕГРИРОВАННАЯ ВЕРСИЯ
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const { PrismaClient } = require('@prisma/client');

// Инициализация
const app = express();
const prisma = new PrismaClient();
const PORT = process.env.PORT || 3000;

// Middleware безопасности
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" }
}));
app.use(compression());

// CORS настройки для Flutter приложения
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000', 
    'http://localhost:8080',
    'http://10.0.2.2:3000', // Android эмулятор
    'http://127.0.0.1:3000'
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Rate limiting
const generalLimiter = rateLimit({
  windowMs: (process.env.RATE_LIMIT_WINDOW || 15) * 60 * 1000,
  max: process.env.RATE_LIMIT_MAX_REQUESTS || 100,
  message: {
    error: 'Слишком много запросов, попробуйте позже',
    retryAfter: Math.ceil((process.env.RATE_LIMIT_WINDOW || 15) * 60)
  },
  standardHeaders: true,
  legacyHeaders: false
});

// Специальный rate limiting для авторизации
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 минут
  max: 5, // 5 попыток на IP
  message: {
    error: 'Слишком много попыток входа, попробуйте через 15 минут'
  },
  keyGenerator: (req) => {
    return req.body.phone || req.ip;
  }
});

// Применяем rate limiting
app.use('/api/', generalLimiter);

// Парсинг JSON и URL-encoded данных
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Логирование
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined'));
}

// Middleware для логирования всех запросов в debug режиме
if (process.env.DEBUG_REQUESTS === 'true') {
  app.use((req, res, next) => {
    console.log(`📥 ${req.method} ${req.originalUrl}`, {
      body: req.body,
      query: req.query,
      headers: {
        'content-type': req.headers['content-type'],
        'authorization': req.headers.authorization ? 'Bearer ***' : undefined
      }
    });
    next();
  });
}

// === БАЗОВЫЕ МАРШРУТЫ ===

// Корневой маршрут
app.get('/', (req, res) => {
  res.json({
    message: '🛒 Северная корзина API',
    version: '1.0.0',
    status: 'running',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    endpoints: {
      health: '/health',
      api: '/api',
      auth: '/api/auth',
      users: '/api/users',
      admin: '/api/admin',
      products: '/api/products',
      orders: '/api/orders',
      batches: '/api/batches'
    }
  });
});

// Health check с проверкой БД
app.get('/health', async (req, res) => {
  try {
    // Проверяем подключение к БД
    await prisma.$queryRaw`SELECT 1`;
    
    const healthData = {
      status: 'healthy',
      database: 'connected',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
      memory: {
        used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024 * 100) / 100,
        total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024 * 100) / 100
      },
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development'
    };

    res.json(healthData);
  } catch (error) {
    console.error('❌ Health check failed:', error);
    res.status(500).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// API Info
app.get('/api', (req, res) => {
  res.json({
    name: 'Северная корзина API',
    version: '1.0.0',
    description: 'API для платформы коллективных закупок',
    author: 'Severnaya Korzina Team',
    endpoints: {
      // Авторизация
      auth: {
        login: 'POST /api/auth/login',
        register: 'POST /api/auth/register',
        profile: 'GET /api/auth/profile',
        check: 'GET /api/auth/check'
      },
      // Пользователи
      users: {
        list: 'GET /api/users',
        get: 'GET /api/users/:id',
        update: 'PUT /api/users/:id',
        addresses: 'GET|POST /api/addresses'
      },
      // Админ панель
      admin: {
        dashboard: 'GET /api/admin/dashboard/stats',
        users: 'GET /api/admin/users',
        products: 'GET|POST|PUT|DELETE /api/admin/products',
        orders: 'GET /api/admin/orders',
        batches: 'GET|POST|PUT /api/admin/batches'
      },
      // Товары и категории
      products: {
        list: 'GET /api/products',
        get: 'GET /api/products/:id',
        categories: 'GET /api/categories'
      },
      // Заказы
      orders: {
        list: 'GET /api/orders',
        create: 'POST /api/orders',
        get: 'GET /api/orders/:id'
      },
      // Закупки
      batches: {
        list: 'GET /api/batches',
        get: 'GET /api/batches/:id'
      }
    },
    documentation: process.env.API_DOCS_URL || 'В разработке'
  });
});

// === API МАРШРУТЫ ===

// Авторизация (с rate limiting)
app.use('/api/auth', authLimiter, require('./routes/auth'));

// Основные маршруты
app.use('/api/users', require('./routes/users'));
app.use('/api/addresses', require('./routes/addresses'));
app.use('/api/admin-auth', require('./routes/admin-auth')); // НОВЫЙ РОУТ ДЛЯ АДМИНА
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/batches', require('./routes/batches'));
app.use('/api/auth', require('./routes/auth'));


// Админ панель (новые маршруты)
app.use('/api/admin', require('./routes/admin'));

// Middleware для логирования всех неизвестных маршрутов
app.use('*', (req, res, next) => {
  console.log(`❌ 404: ${req.method} ${req.originalUrl} from ${req.ip}`);
  next();
});

// Обработка 404
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Маршрут не найден',
    path: req.originalUrl,
    method: req.method,
    timestamp: new Date().toISOString(),
    suggestion: 'Проверьте правильность URL и метода запроса',
    availableEndpoints: [
      '/api/auth',
      '/api/users', 
      '/api/admin-auth', // ДОБАВЬТЕ ЭТУ СТРОКУ
      '/api/addresses',
      '/api/products',
      '/api/orders',
      '/api/batches',
      '/api/admin'
    ]
  });
});

// Глобальная обработка ошибок
app.use((error, req, res, next) => {
  console.error('🚨 Ошибка сервера:', error);
  
  // Логируем детали запроса при ошибке
  console.error('Детали запроса:', {
    method: req.method,
    url: req.originalUrl,
    body: req.body,
    query: req.query,
    headers: {
      'content-type': req.headers['content-type'],
      'user-agent': req.headers['user-agent'],
      'authorization': req.headers.authorization ? 'Bearer ***' : undefined
    },
    ip: req.ip
  });

  // Различаем типы ошибок Prisma
  if (error.code === 'P2002') { // Unique constraint violation
    return res.status(409).json({
      error: 'Конфликт данных',
      message: 'Запись с такими данными уже существует',
      code: 'UNIQUE_CONSTRAINT_VIOLATION'
    });
  }

  if (error.code === 'P2025') { // Record not found
    return res.status(404).json({
      error: 'Запись не найдена',
      code: 'RECORD_NOT_FOUND'
    });
  }

  if (error.code === 'P2003') { // Foreign key constraint
    return res.status(400).json({
      error: 'Нарушение связности данных',
      message: 'Ссылка на несуществующую запись',
      code: 'FOREIGN_KEY_CONSTRAINT'
    });
  }

  // Ошибки валидации
  if (error.name === 'ValidationError') {
    return res.status(400).json({
      error: 'Ошибка валидации данных',
      details: error.message,
      code: 'VALIDATION_ERROR'
    });
  }

  // JWT ошибки
  if (error.name === 'JsonWebTokenError') {
    return res.status(401).json({
      error: 'Недействительный токен',
      code: 'INVALID_TOKEN'
    });
  }

  if (error.name === 'TokenExpiredError') {
    return res.status(401).json({
      error: 'Токен истек',
      code: 'TOKEN_EXPIRED'
    });
  }

  // Стандартная ошибка сервера
  res.status(error.status || 500).json({
    error: process.env.NODE_ENV === 'production' 
      ? 'Внутренняя ошибка сервера' 
      : error.message,
    timestamp: new Date().toISOString(),
    ...(process.env.NODE_ENV !== 'production' && { 
      stack: error.stack,
      name: error.name
    })
  });
});

// Graceful shutdown
const gracefulShutdown = async (signal) => {
  console.log(`📟 Получен сигнал ${signal}, завершаем работу...`);
  
  try {
    await prisma.$disconnect();
    console.log('✅ База данных отключена');
    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка при отключении БД:', error);
    process.exit(1);
  }
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

// Обработка необработанных исключений
process.on('unhandledRejection', (reason, promise) => {
  console.error('🚨 Unhandled Promise Rejection:', reason);
  console.error('Promise:', promise);
});

process.on('uncaughtException', (error) => {
  console.error('🚨 Uncaught Exception:', error);
  process.exit(1);
});

// Запуск сервера
const server = app.listen(PORT, () => {
  console.log('='.repeat(50));
  console.log('🚀 Сервер "Северная корзина" запущен!');
  console.log('='.repeat(50));
  console.log(`🌍 Порт: ${PORT}`);
  console.log(`🔧 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📚 API доступен: http://localhost:${PORT}/api`);
  console.log(`❤️  Health check: http://localhost:${PORT}/health`);
  console.log(`🎯 Flutter Admin: Подключение к http://localhost:${PORT}`);
  
  if (process.env.NODE_ENV !== 'production') {
    console.log('='.repeat(50));
    console.log('🔧 Команды для разработки:');
    console.log('   npx prisma studio    - Prisma Studio');
    console.log('   npx prisma migrate   - Миграции БД');
    console.log('   npm run dev          - Перезапуск сервера');
    console.log('='.repeat(50));
  }
});

// Обработка ошибок сервера
server.on('error', (error) => {
  console.error('='.repeat(50));
  if (error.code === 'EADDRINUSE') {
    console.error(`❌ Порт ${PORT} уже используется`);
    console.error('💡 Попробуйте:');
    console.error('   - Изменить PORT в .env файле');
    console.error('   - Остановить другие приложения на этом порту');
    console.error(`   - Использовать: lsof -ti:${PORT} | xargs kill -9`);
  } else {
    console.error('❌ Ошибка сервера:', error);
  }
  console.error('='.repeat(50));
  process.exit(1);
});

// Экспорт для тестов
module.exports = app;