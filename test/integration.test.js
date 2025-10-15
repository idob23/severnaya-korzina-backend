// test/integration.test.js
const { PrismaClient } = require('@prisma/client');
const { cleanDatabase } = require('./helpers/db-cleaner');
const prisma = new PrismaClient();

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

jest.setTimeout(30000);

describe('Integration Tests - Полный цикл', () => {
  
  let testUser, testAddress, testCategory, testProduct1;
  let testBatch, testOrder, testPayment;

  beforeAll(async () => {
    console.log('🧹 Подготовка для integration тестов...');
    await cleanDatabase(prisma);
  });

  afterAll(async () => {
    console.log('🧹 Финальная очистка integration тестов...');
    await cleanDatabase(prisma);
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  test('СЦЕНАРИЙ 1.1: Создание пользователя', async () => {
    testUser = await prisma.user.create({
      data: {
        phone: '79991234567',
        firstName: 'INTEGRATION_TEST',
        isActive: true,
        acceptedTerms: true
      }
    });

    expect(testUser).toBeDefined();
    console.log('✅ 1.1: Пользователь создан');
  });

  test('СЦЕНАРИЙ 1.2: Добавление адреса', async () => {
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'Тестовый адрес',
        address: 'ул. Тестовая, д. 1',
        isDefault: true
      }
    });

    expect(testAddress).toBeDefined();
    console.log('✅ 1.2: Адрес добавлен');
  });

  test('ИТОГ: Полный цикл завершен успешно', async () => {
    expect(testUser).toBeDefined();
    expect(testAddress).toBeDefined();
    console.log('✅ INTEGRATION тесты пройдены!');
  });
});
