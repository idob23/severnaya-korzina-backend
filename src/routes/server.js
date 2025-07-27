// src/server.js - БЕЗ RATE LIMITING
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
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

// CORS настройки
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
        'authorization': req.headers.authorization ? 
          `Bearer ${req.headers.authorization.slice(7, 20)}...` : 'none'
      }
    });
    next();
  });
}

// === СТАТИЧЕСКИЕ ФАЙЛЫ ===
app.use(express.static('public'));

// === ГЛАВНАЯ СТРАНИЦА API ===
app.get('/', (req, res) => {
  res.json({
    name: 'Severnaya Korzina API',
    version: '1.0.0',
    description: 'API для платформы коллективных закупок',
    author: 'Severnaya Korzina Team',
    endpoints: {
      // Авторизация
      auth: {
        login: 'POST /api/auth/login',
        register: 'POST /api/auth/register',
        profile: 'GET /api/auth/profile',
        check: 'GET /api/auth/check',
        adminLogin: 'POST /api/auth/admin-login',
        adminProfile: 'GET /api/auth/admin-profile',
        adminCheck: 'GET /api/auth/admin-check'
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

// Health check
app.get('/health', async (req, res) => {
  try {
    // Проверяем подключение к БД
    await prisma.$queryRaw`SELECT 1`;
    
    res.json({
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
    });
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

// === API МАРШРУТЫ БЕЗ ОГРАНИЧЕНИЙ ===

// Авторизация БЕЗ rate limiting
app.use('/api/auth', require('./routes/auth'));

// Основные маршруты
app.use('/api/users', require('./routes/users'));
app.use('/api/addresses', require('./routes/addresses'));
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/batches', require('./routes/batches'));

// Админские маршруты (если есть отдельный файл)
if (require('fs').existsSync('./routes/admin.js')) {
  app.use('/api/admin', require('./routes/admin'));
}

// === ОБРАБОТКА ОШИБОК ===

// 404 для API
app.use('/api/*', (req, res) => {
  res.status(404).json({
    error: 'API эндпоинт не найден',
    path: req.originalUrl,
    method: req.method,
    availableEndpoints: '/api/ для списка доступных эндпоинтов'
  });
});

// Глобальный обработчик ошибок
app.use((err, req, res, next) => {
  console.error('❌ Глобальная ошибка:', err);
  
  // Для разработки показываем стек ошибок
  if (process.env.NODE_ENV !== 'production') {
    res.status(err.status || 500).json({
      error: err.message,
      stack: err.stack,
      path: req.originalUrl
    });
  } else {
    res.status(err.status || 500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// === ЗАПУСК СЕРВЕРА ===

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('🛑 Получен SIGTERM, завершаем работу...');
  await prisma.$disconnect();
  process.exit(0);
});

process.on('SIGINT', async () => {
  console.log('🛑 Получен SIGINT, завершаем работу...');
  await prisma.$disconnect();
  process.exit(0);
});

// Запуск сервера
app.listen(PORT, () => {
  console.log(`🚀 Сервер запущен на порту ${PORT}`);
  console.log(`📊 Режим: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔗 API: http://localhost:${PORT}/api/`);
  console.log(`📋 Документация: ${process.env.API_DOCS_URL || 'В разработке'}`);
  
  if (process.env.NODE_ENV !== 'production') {
    console.log('🔧 Debug режим включен');
    console.log('👤 Админ: login=admin, password=admin');
    console.log('🚫 Rate limiting ОТКЛЮЧЕН');
  }
});

module.exports = app;