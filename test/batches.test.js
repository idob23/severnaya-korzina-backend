// test/batches.test.js - ИСПРАВЛЕННАЯ ВЕРСИЯ
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

const { updateBatchStatistics } = require('../src/utils/batchCalculations');

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

jest.setTimeout(30000);

describe('Batches - Расчёты и статистика', () => {
  
  let testBatch;
  let testUsers = [];
  let testAddresses = []; // ← ДОБАВИЛИ
  let testOrders = [];

  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Batches...');

    // Создаём партию
    testBatch = await prisma.batch.create({
      data: {
        title: 'TEST Партия',
        status: 'collecting',
        targetAmount: 10000,
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        marginPercent: 20,
        startDate: new Date(),
        endDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
      }
    });
    console.log(`✅ Создана тестовая партия: ${testBatch.id}`);

    // Создаём 3 тестовых пользователей
    for (let i = 1; i <= 3; i++) {
      const user = await prisma.user.upsert({
        where: { phone: `7999999999${i}` },
        update: {},
        create: {
          phone: `7999999999${i}`,
          firstName: `TestUser${i}`,
          isActive: true
        }
      });
      testUsers.push(user);

      // ✅ СОЗДАЕМ АДРЕС ДЛЯ КАЖДОГО ПОЛЬЗОВАТЕЛЯ
      const address = await prisma.address.create({
        data: {
          userId: user.id,
          title: `Адрес тестового пользователя ${i}`,
          address: `ул. Тестовая, д. ${i}`,
          isDefault: true
        }
      });
      testAddresses.push(address);
      console.log(`✅ Создан пользователь и адрес #${i}`);
    }
  });

  afterAll(async () => {
    console.log('🧹 Финальная очистка batches тестов...');
    // Удаляем тестовые данные
    await prisma.order.deleteMany({ where: { batchId: testBatch.id } });
    await prisma.batch.delete({ where: { id: testBatch.id } });
    await prisma.address.deleteMany({ where: { userId: { in: testUsers.map(u => u.id) } } });
    await prisma.user.deleteMany({ where: { id: { in: testUsers.map(u => u.id) } } });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  test('Начальные значения партии = 0', () => {
    expect(testBatch.currentAmount.toNumber()).toBe(0);
    expect(testBatch.participantsCount).toBe(0);
    expect(testBatch.progressPercent).toBe(0);
    console.log('✅ Тест 1 пройден: Начальные значения партии = 0');
  });

  test('Добавление 1 оплаченного заказа → обновление статистики', async () => {
    // Создаём заказ с ПРАВИЛЬНЫМ addressId
    const order = await prisma.order.create({
      data: {
        userId: testUsers[0].id,
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 3000,
        addressId: testAddresses[0].id // ✅ ИСПОЛЬЗУЕМ СОЗДАННЫЙ АДРЕС
      }
    });
    testOrders.push(order);

    // Обновляем статистику
    await updateBatchStatistics(testBatch.id);

    // Проверяем
    const updated = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(updated.currentAmount.toNumber()).toBe(3000);
    expect(updated.participantsCount).toBe(1);
    expect(updated.progressPercent).toBe(30); // 3000/10000 * 100
    console.log('✅ Тест 2 пройден: Добавление 1 заказа (3000₽, 30%, 1 участник)');
  });

  test('Добавление 2-го заказа того же пользователя → participantsCount = 1', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUsers[0].id, // тот же пользователь
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 2000,
        addressId: testAddresses[0].id // ✅ ИСПОЛЬЗУЕМ АДРЕС ЭТОГО ПОЛЬЗОВАТЕЛЯ
      }
    });
    testOrders.push(order);

    await updateBatchStatistics(testBatch.id);

    const updated = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(updated.currentAmount.toNumber()).toBe(5000); // 3000 + 2000
    expect(updated.participantsCount).toBe(1); // ВСЁ ЕЩЁ 1 пользователь
    expect(updated.progressPercent).toBe(50);
    console.log('✅ Тест 3 пройден: 2-й заказ того же пользователя (5000₽, 50%, 1 участник)');
  });

  test('Добавление заказа от другого пользователя → participantsCount = 2', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUsers[1].id, // другой пользователь
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 3000,
        addressId: testAddresses[1].id // ✅ АДРЕС ВТОРОГО ПОЛЬЗОВАТЕЛЯ
      }
    });
    testOrders.push(order);

    await updateBatchStatistics(testBatch.id);

    const updated = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(updated.currentAmount.toNumber()).toBe(8000);
    expect(updated.participantsCount).toBe(2); // теперь 2
    expect(updated.progressPercent).toBe(80);
    console.log('✅ Тест 4 пройден: Заказ от другого пользователя (8000₽, 80%, 2 участника)');
  });

  test('Достижение 100% → статус меняется на ready', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUsers[2].id,
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 2000,
        addressId: testAddresses[2].id // ✅ АДРЕС ТРЕТЬЕГО ПОЛЬЗОВАТЕЛЯ
      }
    });
    testOrders.push(order);

    await updateBatchStatistics(testBatch.id);

    const updated = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(updated.currentAmount.toNumber()).toBe(10000);
    expect(updated.progressPercent).toBe(100);
    expect(updated.status).toBe('ready'); // АВТОСМЕНА СТАТУСА
    console.log('✅ Тест 5 пройден: Достижение 100% → статус ready');
  });

  test('Только paid заказы учитываются в сумме', async () => {
    // Создаём pending заказ
    await prisma.order.create({
      data: {
        userId: testUsers[2].id,
        batchId: testBatch.id,
        status: 'pending', // НЕ оплачен
        totalAmount: 5000,
        addressId: testAddresses[2].id // ✅ ИСПОЛЬЗУЕМ АДРЕС
      }
    });

    await updateBatchStatistics(testBatch.id);

    const updated = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    // Сумма НЕ должна измениться
    expect(updated.currentAmount.toNumber()).toBe(10000);
    console.log('✅ Тест 6 пройден: pending заказы НЕ учитываются (сумма осталась 10000₽)');
  });
});
