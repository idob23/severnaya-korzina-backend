// test/orders.test.js
// Тесты для Orders API

const { PrismaClient } = require('@prisma/client');
const { cleanDatabase } = require('./helpers/db-cleaner');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

jest.setTimeout(30000);

// Вспомогательные функции
const generateTestToken = (userId) => {
  return jwt.sign(
    { id: userId, phone: '+79991234567' },
    process.env.JWT_SECRET || 'test-secret-key-for-testing',
    { expiresIn: '24h' }
  );
};

describe('Orders API Tests', () => {
  let testUser;
  let testAddress;
  let testBatch;
  let testCategory;
  let testProduct1;
  let testProduct2;
  let testToken;

  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Orders...');
    
    // Очищаем тестовую БД
    await cleanDatabase(prisma);

    // Создаем тестового пользователя
    testUser = await prisma.user.create({
      data: {
        phone: '+79991234567',
        firstName: 'Тестовый',
        lastName: 'Пользователь',
        isActive: true,
        acceptedTerms: true
      }
    });

    // Создаем тестовый адрес
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'Тестовый адрес',
        address: 'ул. Тестовая, д. 1',
        isDefault: true
      }
    });

    // Создаем категорию и товары
    testCategory = await prisma.category.create({
      data: {
        name: 'TEST_Category_Orders',
        isActive: true
      }
    });

    testProduct1 = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'TEST_Product_1',
        price: 100,
        unit: 'шт',
        isActive: true
      }
    });

    testProduct2 = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'TEST_Product_2',
        price: 200,
        unit: 'кг',
        isActive: true
      }
    });

    // Создаем партию
    testBatch = await prisma.batch.create({
      data: {
        title: 'TEST_Batch_Orders',
        status: 'active',
        targetAmount: 10000,
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        marginPercent: 20,
        startDate: new Date(),
        endDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000)
      }
    });

    // Добавляем товары в партию
    await prisma.batchItem.createMany({
      data: [
        {
          batchId: testBatch.id,
          productId: testProduct1.id,
          price: testProduct1.price,
          discount: 10,
          isActive: true
        },
        {
          batchId: testBatch.id,
          productId: testProduct2.id,
          price: testProduct2.price,
          discount: 15,
          isActive: true
        }
      ]
    });

    testToken = generateTestToken(testUser.id);
    console.log('✅ Тестовые данные подготовлены');
  });

  afterAll(async () => {
    console.log('🧹 Финальная очистка orders тестов...');
    await cleanDatabase(prisma);
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  test('1. Создание заказа', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUser.id,
        batchId: testBatch.id,
        addressId: testAddress.id,
        status: 'pending',
        totalAmount: 300
      }
    });

    expect(order).toBeDefined();
    expect(order.status).toBe('pending');
    console.log('✅ Тест 1 пройден: Заказ создан');
  });
});
