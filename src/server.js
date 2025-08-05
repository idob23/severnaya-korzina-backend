// src/server.js - ОБНОВЛЕННАЯ ВЕРСИЯ ДЛЯ ВНЕШНЕГО ДОСТУПА
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
const HOST = process.env.HOST || '0.0.0.0'; // Слушаем все интерфейсы

// Middleware безопасности
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" }
}));
app.use(compression());

// CORS настройки для внешнего доступа
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [
    'http://localhost:3000', 
    'http://localhost:8080',
    'http://10.0.2.2:3000', // Android эмулятор
    'http://127.0.0.1:3000',
    'http://84.201.149.245:3000', // Ваш внешний IP
    'https://84.201.149.245:3000',
    '*' // Временно разрешаем все для тестирования
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
      ip: req.ip,
      userAgent: req.get('User-Agent'),
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
    serverInfo: {
      host: req.get('host'),
      ip: req.ip,
      timestamp: new Date().toISOString(),
      environment: process.env.NODE_ENV || 'development'
    },
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
      server: {
        host: req.get('host'),
        ip: req.ip,
        port: PORT,
        environment: process.env.NODE_ENV || 'development'
      },
      memory: {
        used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024 * 100) / 100,
        total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024 * 100) / 100
      },
      version: '1.0.0'
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

// === API МАРШРУТЫ ===

// Авторизация
app.use('/api/auth', require('./routes/auth'));

// Основные маршруты
app.use('/api/users', require('./routes/users'));
app.use('/api/addresses', require('./routes/addresses'));
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/batches', require('./routes/batches'));

// Админские маршруты (если есть отдельный файл)
const fs = require('fs');
if (fs.existsSync('./src/routes/admin.js')) {
  app.use('/api/admin', require('./routes/admin'));
}

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
    serverInfo: {
      host: req.get('host'),
      ip: req.ip
    },
    availableEndpoints: [
      '/',
      '/health',
      '/api/auth',
      '/api/users', 
      '/api/addresses',
      '/api/products',
      '/api/orders',
      '/api/batches'
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
    headers: req.headers,
    ip: req.ip
  });

  // Различаем типы ошибок
  if (error.name === 'ValidationError') {
    return res.status(400).json({
      error: 'Ошибка валидации данных',
      details: error.message
    });
  }

  if (error.code === 'P2002') { // Prisma unique constraint error
    return res.status(409).json({
      error: 'Конфликт данных',
      message: 'Запись с такими данными уже существует'
    });
  }

  if (error.code === 'P2025') { // Prisma record not found
    return res.status(404).json({
      error: 'Запись не найдена'
    });
  }

  // Стандартная ошибка
  res.status(error.status || 500).json({
    error: process.env.NODE_ENV === 'production' 
      ? 'Внутренняя ошибка сервера' 
      : error.message,
    timestamp: new Date().toISOString(),
    ...(process.env.NODE_ENV !== 'production' && { stack: error.stack })
  });
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('📟 Получен сигнал SIGTERM, завершаем работу...');
  
  try {
    await prisma.$disconnect();
    console.log('✅ База данных отключена');
    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка при отключении БД:', error);
    process.exit(1);
  }
});

process.on('SIGINT', async () => {
  console.log('📟 Получен сигнал SIGINT, завершаем работу...');
  
  try {
    await prisma.$disconnect();
    console.log('✅ База данных отключена');
    process.exit(0);
  } catch (error) {
    console.error('❌ Ошибка при отключении БД:', error);
    process.exit(1);
  }
});

// Запуск сервера на всех интерфейсах
const server = app.listen(PORT, HOST, () => {
  console.log(`🚀 Сервер запущен на порту ${PORT}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📚 API доступен по адресу: http://localhost:${PORT}/api`);
  console.log(`🌐 Внешний доступ: http://84.201.149.245:${PORT}/api`);
  console.log(`❤️  Health check: http://84.201.149.245:${PORT}/health`);
  
  if (process.env.NODE_ENV !== 'production') {
    console.log(`🔧 Prisma Studio: npx prisma studio`);
  }
});

// Обработка ошибок сервера
server.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`❌ Порт ${PORT} уже используется`);
  } else {
    console.error('❌ Ошибка сервера:', error);
  }
  process.exit(1);
});

module.exports = app;
