// src/server.js - ОБНОВЛЕННАЯ ВЕРСИЯ ДЛЯ ВНЕШНЕГО ДОСТУПА
const express = require('express');

const { initCronJobs, startCronJobs, stopCronJobs, getCronStatus } = require('./cron/scheduler');

const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const morgan = require('morgan');
require('dotenv').config();
const settingsRoutes = require('./routes/settings');

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

// CORS настройки - разрешаем для веб-версии
app.use(cors({
  origin: function (origin, callback) {
    const allowedOrigins = [
      'http://app.sevkorzina.ru',
      'https://app.sevkorzina.ru',
      'https://sevkorzina.ru',
      'http://sevkorzina.ru',
      'http://localhost:3000',
      'http://localhost:8080',
      'http://84.201.149.245',      // Добавить эту строку!
      'http://84.201.149.245:3000', // И эту!
      'http://127.0.0.1:3000',
      'http://10.0.2.2:3000' // Android эмулятор
    ];
    
    // Разрешаем запросы без origin (мобильные приложения)
    if (!origin) return callback(null, true);
    
     // Разрешаем любые localhost порты
    if (origin.startsWith('http://localhost:') || origin.startsWith('http://127.0.0.1:')) {
      return callback(null, true);
    }

    if (allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.log(`❌ CORS blocked origin: ${origin}`);
      callback(new Error('Not allowed by CORS'));
    }
  },
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


// Раздача загруженных файлов
const path = require('path');
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

const analyticsRoutes = require('./routes/analytics');
app.use('/api/analytics', analyticsRoutes);

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
       // SMS сервис
      sms: {
        send: 'POST /api/sms/send',
        verify: 'POST /api/sms/verify',
        status: 'GET /api/sms/status'
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
      // ДОБАВИТЬ ЭТУ СЕКЦИЮ:
      payments: {
        create: 'POST /api/payments/create',
        status: 'GET /api/payments/status/:paymentId',
        webhook: 'POST /api/payments/webhook' // ← ВАЖНО!
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

// Статус cron задач (для мониторинга)
app.get('/api/cron/status', (req, res) => {
  const status = getCronStatus();
  res.json({
    success: true,
    tasks: status,
    serverTime: new Date().toISOString()
  });
});

// === API МАРШРУТЫ ===

app.use('/api/sms', require('./routes/sms'));
// Авторизация
app.use('/api/auth', require('./routes/auth'));

// Основные маршруты
app.use('/api/users', require('./routes/users'));
app.use('/api/addresses', require('./routes/addresses'));
app.use('/api/products', require('./routes/products'));
app.use('/api/orders', require('./routes/orders'));
app.use('/api/batches', require('./routes/batches'));

// Админские маршруты
app.use('/api/admin', require('./routes/admin'));
app.use('/api/admin/category-mappings', require('./routes/category-mapping'));

app.use('/api/categories', require('./routes/category-images'));

// ДОБАВИТЬ ЭТУ СТРОКУ:
app.use('/api/payments', require('./routes/payments'));
app.use('/api/app', require('./routes/app')); // НОВЫЙ РОУТ ДЛЯ ПРОВЕРКИ ВЕРСИЙ

app.use('/api/settings', settingsRoutes);  // <- ДОБАВИТЬ ЭТУ СТРОКУ

// Статика для APK файлов с отключенным кэшем
app.use('/downloads', (req, res, next) => {
  // Отключаем кэширование для APK файлов
  res.set({
    'Cache-Control': 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0',
    'Pragma': 'no-cache',
    'Expires': '0',
    'Surrogate-Control': 'no-store'
  });
  next();
}, express.static('public/downloads'));

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


// ============================================
// ЗАПУСК СЕРВЕРА (ТОЛЬКО ЕСЛИ НЕ ТЕСТ!)
// ============================================

// 🧪 В тестовом режиме сервер НЕ запускается
if (process.env.NODE_ENV !== 'test') {
const server = app.listen(PORT, HOST, () => {
  console.log('🎉 ========================================');
  console.log('🚀 СЕРВЕР ЗАПУЩЕН');
  console.log('🎉 ========================================');
  console.log(`📍 Порт: ${PORT}`);
  console.log(`🌍 Хост: ${HOST}`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📚 API доступен по адресу: http://localhost:${PORT}/api`);
  console.log(`🌐 Внешний доступ: http://84.201.149.245:${PORT}/api`);
  console.log(`❤️  Health check: http://84.201.149.245:${PORT}/health`);
 // Показываем SMS настройки
  console.log(`📧 SMS Email: ${process.env.SMS_AERO_EMAIL || 'НЕ УКАЗАН'}`);
  console.log(`🔑 SMS API Key: ${process.env.SMS_AERO_API_KEY ? '[УСТАНОВЛЕН]' : 'НЕ УСТАНОВЛЕН'}`);

   if (process.env.NODE_ENV !== 'production') {
    console.log(`🔧 Prisma Studio: npx prisma studio`);
  }
  
  console.log('🎉 ========================================\n');
  
  // ✨ ИНИЦИАЛИЗАЦИЯ И ЗАПУСК CRON ЗАДАЧ
  console.log('🕐 ========================================');
  console.log('🕐 ЗАПУСК CRON ЗАДАЧ');
  console.log('🕐 ========================================');
  try {
    initCronJobs();
    startCronJobs();
    console.log('✅ Все cron задачи успешно запущены');
    console.log('🕐 ========================================\n');
  } catch (error) {
    console.error('❌ Ошибка запуска cron задач:', error);
    console.log('⚠️  Сервер продолжит работу без cron задач');
    console.log('🕐 ========================================\n');
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

// ✨ GRACEFUL SHUTDOWN С ОСТАНОВКОЙ CRON
process.on('SIGTERM', async () => {
  console.log('\n⚠️  ========================================');
  console.log('⚠️  ПОЛУЧЕН СИГНАЛ SIGTERM');
  console.log('⚠️  ========================================');
  console.log('🛑 Останавливаем cron задачи...');
  
  try {
    stopCronJobs();
    console.log('✅ Cron задачи остановлены');
  } catch (error) {
    console.error('❌ Ошибка остановки cron:', error);
  }
  
  console.log('🛑 Закрываем соединение с БД...');
  try {
    await prisma.$disconnect();
    console.log('✅ База данных отключена');
  } catch (error) {
    console.error('❌ Ошибка при отключении БД:', error);
  }
  
  console.log('🛑 Останавливаем HTTP сервер...');
  server.close(() => {
    console.log('✅ HTTP сервер остановлен');
    console.log('👋 Завершение работы...\n');
    process.exit(0);
  });
  
  // Форсированное завершение через 10 секунд
  setTimeout(() => {
    console.error('❌ Не удалось корректно завершить работу за 10 секунд');
    process.exit(1);
  }, 10000);
});

process.on('SIGINT', async () => {
  console.log('\n⚠️  ========================================');
  console.log('⚠️  ПОЛУЧЕН СИГНАЛ SIGINT (Ctrl+C)');
  console.log('⚠️  ========================================');
  console.log('🛑 Останавливаем cron задачи...');
  
  try {
    stopCronJobs();
    console.log('✅ Cron задачи остановлены');
  } catch (error) {
    console.error('❌ Ошибка остановки cron:', error);
  }
  
  console.log('🛑 Закрываем соединение с БД...');
  try {
    await prisma.$disconnect();
    console.log('✅ База данных отключена');
  } catch (error) {
    console.error('❌ Ошибка при отключении БД:', error);
  }
  
  console.log('🛑 Останавливаем HTTP сервер...');
  server.close(() => {
    console.log('✅ HTTP сервер остановлен');
    console.log('👋 Завершение работы...\n');
    process.exit(0);
  });
  
  // Форсированное завершение через 10 секунд
  setTimeout(() => {
    console.error('❌ Не удалось корректно завершить работу за 10 секунд');
    process.exit(1);
  }, 10000);
});

} else {
  // 🧪 РЕЖИМ ТЕСТИРОВАНИЯ
  console.log('🧪 ========================================');
  console.log('🧪 РЕЖИМ ТЕСТИРОВАНИЯ');
  console.log('🧪 ========================================');
  console.log('🧪 Express сервер НЕ запускается');
  console.log('🧪 Только экспорт app для тестов');
  console.log('🧪 ========================================\n');
}

module.exports = app;
