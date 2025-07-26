// src/server.js - ОБНОВЛЕННАЯ ВЕРСИЯ
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

// CORS настройки
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000', 'http://localhost:8080'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: (process.env.RATE_LIMIT_WINDOW || 15) * 60 * 1000, // 15 минут
  max: process.env.RATE_LIMIT_MAX_REQUESTS || 100,
  message: {
    error: 'Слишком много запросов, попробуйте позже',
    retryAfter: Math.ceil((process.env.RATE_LIMIT_WINDOW || 15) * 60)
  },
  standardHeaders: true,
  legacyHeaders: false
});

// Применяем rate limiting только к API маршрутам
app.use('/api/', limiter);

// Специальный rate limiting для авторизации
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 минут
  max: 5, // 5 попыток на номер
  message: {
    error: 'Слишком много попыток входа, попробуйте через 15 минут'
  },
  keyGenerator: (req) => {
    return req.body.phone || req.ip;
  }
});

// Парсинг JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Логирование
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined'));
}

// Базовый маршрут
app.get('/', (req, res) => {
  res.json({
    message: '🛒 Северная корзина API',
    version: '1.0.0',
    status: 'running',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
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
      }
    });
  } catch (error) {
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
    endpoints: {
      auth: '/api/auth',
      users: '/api/users',
      addresses: '/api/addresses',
      products: '/api/products',
      orders: '/api/orders',
      batches: '/api/batches'
    },
    documentation: process.env.API_DOCS_URL || 'В разработке'
  });
});

// API маршруты
app.use('/api/auth', authLimiter, require('./routes/auth'));
app.use('/api/users', require('./routes/users'));
app.use('/api/addresses', require('./routes/addresses'));
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/batches', require('./routes/batches'));

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
    availableEndpoints: [
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

// Запуск сервера
const server = app.listen(PORT, () => {
  console.log(`🚀 Сервер запущен на порту ${PORT}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📚 API доступен по адресу: http://localhost:${PORT}/api`);
  console.log(`❤️  Health check: http://localhost:${PORT}/health`);
  
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