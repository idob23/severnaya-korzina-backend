// test/setup.js
// КРИТИЧЕСКАЯ ЗАЩИТА ОТ ПОВРЕЖДЕНИЯ PRODUCTION БД

const { PrismaClient } = require('@prisma/client');
const path = require('path');
const dotenv = require('dotenv');

console.log('\n🔒 ПРОВЕРКА БЕЗОПАСНОСТИ ТЕСТОВ...\n');

// ============================================
// ЗАЩИТА #1: БЛОКИРОВКА PRODUCTION NODE_ENV
// ============================================
if (process.env.NODE_ENV === 'production') {
  console.error('╔════════════════════════════════════════════════════════╗');
  console.error('║  🚨🚨🚨 КРИТИЧЕСКАЯ ОШИБКА 🚨🚨🚨                     ║');
  console.error('║                                                        ║');
  console.error('║  ТЕСТЫ ЗАПРЕЩЕНЫ В РЕЖИМЕ PRODUCTION!                  ║');
  console.error('║                                                        ║');
  console.error('║  Текущий NODE_ENV: "production"                        ║');
  console.error('║                                                        ║');
  console.error('║  Используйте: NODE_ENV=test npm test                   ║');
  console.error('║                                                        ║');
  console.error('╚════════════════════════════════════════════════════════╝\n');
  process.exit(1);
}

// ============================================
// ЗАЩИТА #2: ПРИНУДИТЕЛЬНАЯ ЗАГРУЗКА .env.test
// ============================================
const envTestPath = path.resolve(__dirname, '../.env.test');
console.log(`📄 Загрузка .env.test из: ${envTestPath}`);

// Удаляем старые переменные окружения перед загрузкой
delete process.env.DATABASE_URL;

const result = dotenv.config({ path: envTestPath, override: true });

if (result.error) {
  console.error('\n╔════════════════════════════════════════════════════════╗');
  console.error('║  ❌ ОШИБКА: Файл .env.test не найден!                  ║');
  console.error('║                                                        ║');
  console.error('║  Создайте файл .env.test с тестовой БД:                ║');
  console.error('║  DATABASE_URL="postgresql://...localhost.../test"     ║');
  console.error('║  NODE_ENV=test                                         ║');
  console.error('╚════════════════════════════════════════════════════════╝\n');
  process.exit(1);
}

console.log('✅ Файл .env.test загружен\n');

// ============================================
// ЗАЩИТА #3: ПРОВЕРКА NODE_ENV=test
// ============================================
if (process.env.NODE_ENV !== 'test') {
  console.error('\n╔════════════════════════════════════════════════════════╗');
  console.error('║  🚨 ОШИБКА: NODE_ENV должен быть "test"                ║');
  console.error(`║  Текущее значение: "${process.env.NODE_ENV}"           ║`);
  console.error('║                                                        ║');
  console.error('║  В файле .env.test должно быть:                        ║');
  console.error('║  NODE_ENV=test                                         ║');
  console.error('╚════════════════════════════════════════════════════════╝\n');
  process.exit(1);
}

// ============================================
// ЗАЩИТА #4: ПРОВЕРКА DATABASE_URL
// ============================================
if (!process.env.DATABASE_URL) {
  console.error('\n╔════════════════════════════════════════════════════════╗');
  console.error('║  ❌ ОШИБКА: DATABASE_URL не установлен!                ║');
  console.error('║                                                        ║');
  console.error('║  Добавьте в .env.test:                                 ║');
  console.error('║  DATABASE_URL="postgresql://localhost:5432/test_db"   ║');
  console.error('╚════════════════════════════════════════════════════════╝\n');
  process.exit(1);
}

// ============================================
// ЗАЩИТА #5: URL ДОЛЖЕН СОДЕРЖАТЬ "test"
// ============================================
if (!process.env.DATABASE_URL.toLowerCase().includes('test')) {
  console.error('\n╔════════════════════════════════════════════════════════╗');
  console.error('║  🚨 КРИТИЧЕСКАЯ ОШИБКА!                                ║');
  console.error('║                                                        ║');
  console.error('║  DATABASE_URL ОБЯЗАН содержать слово "test"!           ║');
  console.error('║                                                        ║');
  const urlPreview = process.env.DATABASE_URL.substring(0, 50);
  console.error(`║  URL: ${urlPreview.padEnd(49)} ║`);
  console.error('║                                                        ║');
  console.error('║  Правильные примеры:                                   ║');
  console.error('║  - postgresql://localhost:5432/severnaya_test          ║');
  console.error('║  - postgresql://localhost:5432/test_db                 ║');
  console.error('╚════════════════════════════════════════════════════════╝\n');
  process.exit(1);
}

// ============================================
// ЗАЩИТА #6: ЗАПРЕТ PRODUCTION БД YANDEX CLOUD
// ============================================
const FORBIDDEN_PRODUCTION_MARKERS = [
  'rc1a-30l5jck6ggdjdle6',           // ID твоего production кластера
  'yandexcloud.net',                  // Домен Yandex Cloud
  ':6432/',                           // Стандартный порт Yandex Managed PostgreSQL
  'severnaya_korzina?',               // Имя production БД (без _test)
  'c-rc1a',                           // Префикс managed кластеров Yandex
];

const foundProductionMarker = FORBIDDEN_PRODUCTION_MARKERS.find(marker => 
  process.env.DATABASE_URL.includes(marker)
);

if (foundProductionMarker) {
  console.error('\n╔════════════════════════════════════════════════════════╗');
  console.error('║  🚨🚨🚨 КРИТИЧЕСКАЯ ОШИБКА! 🚨🚨🚨                     ║');
  console.error('║                                                        ║');
  console.error('║  ОБНАРУЖЕНА PRODUCTION БАЗА ДАННЫХ YANDEX CLOUD!       ║');
  console.error('║                                                        ║');
  console.error(`║  Найден маркер: ${foundProductionMarker.padEnd(37)} ║`);
  const urlPreview = process.env.DATABASE_URL.substring(0, 40);
  console.error(`║  URL: ${urlPreview.padEnd(47)} ║`);
  console.error('║                                                        ║');
  console.error('║  🛑 ТЕСТЫ НА PRODUCTION БД СТРОГО ЗАПРЕЩЕНЫ!           ║');
  console.error('║                                                        ║');
  console.error('║  Используйте локальную БД:                             ║');
  console.error('║  DATABASE_URL="postgresql://localhost:5432/test_db"   ║');
  console.error('╚════════════════════════════════════════════════════════╝\n');
  process.exit(1);
}

// ============================================
// ЗАЩИТА #7: LOCALHOST ИЛИ 127.0.0.1 РЕКОМЕНДУЮТСЯ
// ============================================
const isLocalhost = process.env.DATABASE_URL.includes('localhost') || 
                    process.env.DATABASE_URL.includes('127.0.0.1');

if (!isLocalhost) {
  console.warn('\n╔════════════════════════════════════════════════════════╗');
  console.warn('║  ⚠️  ВНИМАНИЕ: Удалённая БД обнаружена!                ║');
  console.warn('║                                                        ║');
  console.warn('║  Для максимальной безопасности рекомендуется           ║');
  console.warn('║  использовать локальную БД (localhost/127.0.0.1)       ║');
  console.warn('║                                                        ║');
  const urlPreview = process.env.DATABASE_URL.substring(0, 40);
  console.warn(`║  Текущий URL: ${urlPreview.padEnd(38)} ║`);
  console.warn('║                                                        ║');
  console.warn('║  Продолжаем выполнение (прошла все проверки)...        ║');
  console.warn('╚════════════════════════════════════════════════════════╝\n');
}

// ============================================
// ✅ ВСЕ ПРОВЕРКИ ПРОЙДЕНЫ
// ============================================
console.log('╔════════════════════════════════════════════════════════╗');
console.log('║  ✅ ВСЕ ПРОВЕРКИ БЕЗОПАСНОСТИ ПРОЙДЕНЫ!                ║');
console.log('║                                                        ║');

const dbInfo = process.env.DATABASE_URL.split('@')[1] || 'localhost';
const dbInfoShort = dbInfo.substring(0, 45);
console.log(`║  📊 БД: ${dbInfoShort.padEnd(45)} ║`);
console.log('║  🔧 NODE_ENV: test                                     ║');
console.log('║                                                        ║');
console.log('║  🛡️  Production БД надёжно защищена!                   ║');
console.log('╚════════════════════════════════════════════════════════╝\n');

// ============================================
// ЭКСПОРТ PRISMA КЛИЕНТА
// ============================================
const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL
    }
  },
  log: ['error', 'warn'] // Только важные логи
});

module.exports = { prisma };
