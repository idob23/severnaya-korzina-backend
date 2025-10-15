// test/helpers/db-cleaner.js
// Безопасная очистка тестовой базы данных

const { PrismaClient } = require('@prisma/client');

/**
 * Очищает все таблицы в тестовой БД
 * ВНИМАНИЕ: Можно вызывать ТОЛЬКО в тестах!
 */
async function cleanDatabase(prisma) {
  // 🚨 Двойная проверка безопасности
  if (process.env.NODE_ENV !== 'test') {
    throw new Error('🚨 cleanDatabase можно вызывать ТОЛЬКО в тестовой среде!');
  }

  if (!process.env.DATABASE_URL || !process.env.DATABASE_URL.includes('test')) {
    throw new Error('🚨 DATABASE_URL должен содержать "test"!');
  }

  console.log('🧹 Очистка тестовой базы данных...');

  try {
    // Очищаем таблицы в правильном порядке (учитываем FK constraints)
    await prisma.orderItem.deleteMany({});
    await prisma.order.deleteMany({});
    await prisma.payment.deleteMany({});
    await prisma.batchItem.deleteMany({});
    await prisma.batch.deleteMany({});
    await prisma.product.deleteMany({});
    await prisma.category.deleteMany({});
    await prisma.address.deleteMany({});
    await prisma.user.deleteMany({});
    await prisma.systemSettings.deleteMany({});

    console.log('✅ База данных очищена');
  } catch (error) {
    console.error('❌ Ошибка при очистке БД:', error.message);
    throw error;
  }
}

/**
 * Создаёт минимальные тестовые данные
 */
async function seedTestData(prisma) {
  console.log('🌱 Создание тестовых данных...');

  const category = await prisma.category.create({
    data: {
      name: 'TEST_Category',
      description: 'Тестовая категория',
      isActive: true
    }
  });

  const product = await prisma.product.create({
    data: {
      categoryId: category.id,
      name: 'TEST_Product',
      price: 100,
      unit: 'шт',
      isActive: true
    }
  });

  console.log('✅ Тестовые данные созданы');
  return { category, product };
}

module.exports = { 
  cleanDatabase,
  seedTestData
};
