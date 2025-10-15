// test/payments.test.js
const { PrismaClient } = require('@prisma/client');
const { cleanDatabase } = require('./helpers/db-cleaner');
const prisma = new PrismaClient();

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

jest.setTimeout(30000);

describe('Payments - Критичные тесты', () => {
  
  let testUser;
  let testAddress;
  let testOrder;
  let testPayment;

  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Payments...');
    
    await cleanDatabase(prisma);

    // Создаём тестового пользователя
    testUser = await prisma.user.create({
      data: {
        phone: '79999999999',
        firstName: 'Test',
        isActive: true,
        acceptedTerms: true
      }
    });

    // Создаем адрес
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'Тестовый адрес для платежей',
        address: 'ул. Тестовая, д. 1',
        isDefault: true
      }
    });

    // Создаём тестовый заказ
    testOrder = await prisma.order.create({
      data: {
        userId: testUser.id,
        status: 'pending',
        totalAmount: 1200,
        addressId: testAddress.id
      }
    });

    console.log('✅ Тестовые данные подготовлены');
  });

  afterAll(async () => {
    console.log('🧹 Финальная очистка payments тестов...');
    await cleanDatabase(prisma);
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  test('1. БД подключается', async () => {
    const result = await prisma.$queryRaw`SELECT 1 as test`;
    expect(result[0].test).toBe(1);
    console.log('✅ Тест 1 пройден: БД подключена');
  });

  test('2. Создание записи payment', async () => {
    testPayment = await prisma.payment.create({
      data: {
        paymentId: 'TEST_' + Date.now(),
        orderId: testOrder.id,
        status: 'CREATED',
        amount: 1200,
        provider: 'tochka'
      }
    });

    expect(testPayment.id).toBeDefined();
    expect(testPayment.status).toBe('CREATED');
    console.log('✅ Тест 2 пройден: Payment создан');
  });
});
