// test/setup.js
// Настройка тестового окружения с проверками безопасности

const { PrismaClient } = require('@prisma/client');
const path = require('path');
const dotenv = require('dotenv');

// 🔥 КРИТИЧНО: Загружаем .env.test с ПЕРЕЗАПИСЬЮ существующих переменных
const envPath = path.resolve(__dirname, '../.env.test');
console.log(`📄 Загрузка конфигурации из: ${envPath}`);

// override: true - перезаписывает существующие переменные окружения
const result = dotenv.config({ path: envPath, override: true });

if (result.error) {
  console.error('❌ Ошибка загрузки .env.test:', result.error);
  process.exit(1);
}

console.log('✅ Файл .env.test загружен');
console.log(`📊 DATABASE_URL: ${process.env.DATABASE_URL}`);

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА #1: NODE_ENV
if (process.env.NODE_ENV !== 'test') {
  console.error('\n🚨 ОШИБКА: Тесты можно запускать ТОЛЬКО с NODE_ENV=test');
  console.error(`   Текущий NODE_ENV: "${process.env.NODE_ENV}"`);
  console.error('   Используйте: NODE_ENV=test npm test\n');
  process.exit(1);
}

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА #2: DATABASE_URL
if (!process.env.DATABASE_URL) {
  console.error('\n🚨 ОШИБКА: DATABASE_URL не установлен');
  console.error('   Создайте файл .env.test с тестовой БД\n');
  process.exit(1);
}

if (!process.env.DATABASE_URL.includes('test')) {
  console.error('\n🚨 ОШИБКА: DATABASE_URL должен содержать "test"');
  console.error(`   Текущий URL: ${process.env.DATABASE_URL}`);
  console.error('   Это защита от случайного использования production БД!\n');
  process.exit(1);
}

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА #3: Запрет production БД
const productionIndicators = [
  'rc1a-30l5jck6ggdjdle6',
  'yandexcloud.net',
  ':6432/',
  'severnaya_korzina?'
];

const hasProductionIndicator = productionIndicators.some(indicator => 
  process.env.DATABASE_URL.includes(indicator)
);

if (hasProductionIndicator) {
  console.error('\n🚨 КРИТИЧЕСКАЯ ОШИБКА: Обнаружена PRODUCTION база данных!');
  console.error(`   URL: ${process.env.DATABASE_URL}`);
  console.error('   Тесты ЗАПРЕЩЕНЫ на production БД!\n');
  process.exit(1);
}

// ✅ Все проверки пройдены
console.log('\n✅ Проверки безопасности пройдены');
console.log(`📊 Тестовая БД: ${process.env.DATABASE_URL.split('@')[1] || 'localhost'}`);
console.log(`🔧 NODE_ENV: ${process.env.NODE_ENV}\n`);

// Экспорт Prisma клиента для тестов
const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL
    }
  }
});

module.exports = { prisma };
