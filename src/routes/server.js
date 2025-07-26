// src/server.js - УПРОЩЕННАЯ ВЕРСИЯ ДЛЯ ЗАПУСКА
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
app.use(helmet());
app.use(compression());

// CORS настройки
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000', 'http://localhost:8080'],
  credentials: true
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 минут
  max: 100,
  message: {
    error: 'Слишком много запросов, попробуйте позже'
  }
});
app.use('/api/', limiter);

// Парсинг JSON
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Логирование
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));
}

// Базовый маршрут
app.get('/', (req, res) => {
  res.json({
    message: '🛒 Северная корзина API',
    version: '1.0.0',
    status: 'running',
    timestamp: new Date().toISOString()
  });
});

// Health check
app.get('/health', async (req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    
    res.json({
      status: 'healthy',
      database: 'connected',
      uptime: process.uptime(),
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({
      status: 'unhealthy',
      database: 'disconnected',
      error: error.message
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
    }
  });
});

// API маршруты
app.use('/api/auth', require('./routes/auth'));
app.use('/api/addresses', require('./routes/addresses'));
app.use('/api/users', require('./routes/users'));
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/batches', require('./routes/batches'));

// Обработка 404
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Маршрут не найден',
    path: req.originalUrl,
    method: req.method
  });
});

// Глобальная обработка ошибок
app.use((error, req, res, next) => {
  console.error('Ошибка сервера:', error);
  
  res.status(error.status || 500).json({
    error: process.env.NODE_ENV === 'production' 
      ? 'Внутренняя ошибка сервера' 
      : error.message
  });
});

// Запуск сервера
app.listen(PORT, () => {
  console.log(`🚀 Сервер запущен на порту ${PORT}`);
  console.log(`📚 API доступен по адресу: http://localhost:${PORT}/api`);
  console.log(`❤️  Health check: http://localhost:${PORT}/health`);
});

module.exports = app;