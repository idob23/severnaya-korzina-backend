// test/api-integration.test.js
// API Integration тесты - вызов реальных endpoints

const request = require('supertest');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}
const { cleanDatabase } = require('./helpers/db-cleaner');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

const { PrismaClient } = require('@prisma/client');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}
const { cleanDatabase } = require('./helpers/db-cleaner');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

const jwt = require('jsonwebtoken');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}
const { cleanDatabase } = require('./helpers/db-cleaner');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}


const prisma = new PrismaClient();

// Импортируем Express app
const app = require('../src/server');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}
const { cleanDatabase } = require('./helpers/db-cleaner');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}


jest.setTimeout(30000);

describe('API Integration Tests', () => {
  
  let testUser;
  let testToken;
  let testAddress;
  let testCategory;
  let testProduct;
  let testBatch;

  // Генерация JWT токена
  const generateToken = (userId) => {
    return jwt.sign(
      { id: userId },
      process.env.JWT_SECRET || 'test-secret-key-for-testing',
      { expiresIn: '24h' }
    );
  };

  // Подготовка данных
  beforeAll(async () => {
    console.log('🧹 Подготовка API integration тестов...');

    // Создаем тестового пользователя
    testUser = await prisma.user.create({
      data: {
        phone: '+79991112233',
        firstName: 'API',
        lastName: 'Тестовый',
        isActive: true
      }
    });

    testToken = generateToken(testUser.id);

    // Создаем адрес
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'API тест адрес',
        address: 'ул. API, д. 1',
        isDefault: true
      }
    });

    // Создаем категорию
    testCategory = await prisma.category.create({
      data: {
        name: 'API тест категория',
        isActive: true
      }
    });

    // Создаем товар
    testProduct = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'API тест товар',
        price: 100,
        unit: 'шт',
        maxQuantity: 10,
        isActive: true
      }
    });

    // Создаем партию
    testBatch = await prisma.batch.create({
      data: {
        title: 'API тест партия',
        status: 'active',
        targetAmount: 10000,
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        marginPercent: 20,
        startDate: new Date(),
        endDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
      }
    });

    console.log('✅ Данные для API тестов подготовлены');
  });

  // Очистка
  afterAll(async () => {
    console.log('🧹 Очистка API integration тестов...');
    await prisma.orderItem.deleteMany({});
    await prisma.order.deleteMany({});
    await prisma.batchItem.deleteMany({});
    await prisma.batch.delete({ where: { id: testBatch.id } });
    await prisma.product.delete({ where: { id: testProduct.id } });
    await prisma.category.delete({ where: { id: testCategory.id } });
    await prisma.address.delete({ where: { id: testAddress.id } });
    await prisma.user.delete({ where: { id: testUser.id } });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: GET /api/products - получение списка товаров
  test('1. GET /api/products - должен получить список товаров', async () => {
    const response = await request(app)
      .get('/api/products')
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(Array.isArray(response.body.data)).toBe(true);
    expect(response.body.data.length).toBeGreaterThan(0);

    console.log(`✅ Тест 1 пройден: Получено ${response.body.data.length} товаров`);
  });

  // ТЕСТ 2: GET /api/products/:id - получение одного товара
  test('2. GET /api/products/:id - должен получить товар по ID', async () => {
    const response = await request(app)
      .get(`/api/products/${testProduct.id}`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.data.id).toBe(testProduct.id);
    expect(response.body.data.name).toBe('API тест товар');

    console.log(`✅ Тест 2 пройден: Товар #${testProduct.id} получен`);
  });

  // ТЕСТ 3: GET /api/categories - получение категорий
  test('3. GET /api/categories - должен получить список категорий', async () => {
    const response = await request(app)
      .get('/api/categories')
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(Array.isArray(response.body.data)).toBe(true);

    console.log(`✅ Тест 3 пройден: Получено ${response.body.data.length} категорий`);
  });

  // ТЕСТ 4: GET /api/batches - получение партий
  test('4. GET /api/batches - должен получить список партий', async () => {
    const response = await request(app)
      .get('/api/batches')
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(Array.isArray(response.body.data)).toBe(true);

    console.log(`✅ Тест 4 пройден: Получено ${response.body.data.length} партий`);
  });

  // ТЕСТ 5: GET /api/batches/:id - получение партии по ID
  test('5. GET /api/batches/:id - должен получить партию по ID', async () => {
    const response = await request(app)
      .get(`/api/batches/${testBatch.id}`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.data.id).toBe(testBatch.id);

    console.log(`✅ Тест 5 пройден: Партия #${testBatch.id} получена`);
  });

  // ТЕСТ 6: POST /api/orders - создание заказа (с авторизацией)
  test('6. POST /api/orders - должен создать заказ', async () => {
    const response = await request(app)
      .post('/api/orders')
      .set('Authorization', `Bearer ${testToken}`)
      .send({
        batchId: testBatch.id,
        addressId: testAddress.id,
        items: [
          {
            productId: testProduct.id,
            quantity: 2,
            price: 100
          }
        ]
      })
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data.id).toBeDefined();
    expect(response.body.data.status).toBe('pending');

    console.log(`✅ Тест 6 пройден: Заказ #${response.body.data.id} создан`);
  });

  // ТЕСТ 7: GET /api/orders/my - получение своих заказов
  test('7. GET /api/orders/my - должен получить свои заказы', async () => {
    const response = await request(app)
      .get('/api/orders/my')
      .set('Authorization', `Bearer ${testToken}`)
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(Array.isArray(response.body.data)).toBe(true);
    expect(response.body.data.length).toBeGreaterThan(0);

    console.log(`✅ Тест 7 пройден: Получено ${response.body.data.length} заказов`);
  });

  // ТЕСТ 8: GET /api/settings - получение настроек
  test('8. GET /api/settings - должен получить настройки', async () => {
    const response = await request(app)
      .get('/api/settings')
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(typeof response.body.data).toBe('object');

    console.log('✅ Тест 8 пройден: Настройки получены');
  });

  // ТЕСТ 9: POST /api/orders без токена - должен вернуть 401
  test('9. POST /api/orders без авторизации - должен вернуть 401', async () => {
    const response = await request(app)
      .post('/api/orders')
      .send({
        batchId: testBatch.id,
        addressId: testAddress.id,
        items: []
      })
      .expect(401);

    expect(response.body.success).toBe(false);

    console.log('✅ Тест 9 пройден: Неавторизованный доступ заблокирован');
  });

  // ТЕСТ 10: GET /api/products/999999 - несуществующий товар
  test('10. GET /api/products/999999 - должен вернуть 404', async () => {
    const response = await request(app)
      .get('/api/products/999999')
      .expect(404);

    expect(response.body.success).toBe(false);

    console.log('✅ Тест 10 пройден: Несуществующий товар обработан');
  });

});
