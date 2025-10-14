const { PrismaClient } = require('@prisma/client');
const { updateBatchStatistics } = require('../src/utils/batchCalculations');
const prisma = new PrismaClient();

describe('Batches - Расчёты и статистика', () => {
  
  let testBatch;
  let testUsers = [];
  let testOrders = [];

  beforeAll(async () => {
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

    // Создаём 3 тестовых пользователей
    for (let i = 1; i <= 3; i++) {
      const user = await prisma.user.upsert({
        where: { phone: `7999999999${i}` },
        update: {},
        create: {
          phone: `7999999999${i}`,
          firstName: `TestUser${i}`,
          acceptedTerms: true
        }
      });
      testUsers.push(user);
    }
  });

  afterAll(async () => {
    // Удаляем тестовые данные
    await prisma.order.deleteMany({ where: { batchId: testBatch.id } });
    await prisma.batch.delete({ where: { id: testBatch.id } });
    await prisma.$disconnect();
  });

  test('Начальные значения партии = 0', () => {
    expect(testBatch.currentAmount.toNumber()).toBe(0);
    expect(testBatch.participantsCount).toBe(0);
    expect(testBatch.progressPercent).toBe(0);
  });

  test('Добавление 1 оплаченного заказа → обновление статистики', async () => {
    // Создаём заказ
    const order = await prisma.order.create({
      data: {
        userId: testUsers[0].id,
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 3000,
        addressId: 1
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
  });

  test('Добавление 2-го заказа того же пользователя → participantsCount = 1', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUsers[0].id, // тот же пользователь
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 2000,
        addressId: 1
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
  });

  test('Добавление заказа от другого пользователя → participantsCount = 2', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUsers[1].id, // другой пользователь
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 3000,
        addressId: 1
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
  });

  test('Достижение 100% → статус меняется на ready', async () => {
    const order = await prisma.order.create({
      data: {
        userId: testUsers[2].id,
        batchId: testBatch.id,
        status: 'paid',
        totalAmount: 2000,
        addressId: 1
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
  });

  test('Только paid заказы учитываются в сумме', async () => {
    // Создаём pending заказ
    await prisma.order.create({
      data: {
        userId: testUsers[2].id,
        batchId: testBatch.id,
        status: 'pending', // НЕ оплачен
        totalAmount: 5000,
        addressId: 1
      }
    });

    await updateBatchStatistics(testBatch.id);

    const updated = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    // Сумма НЕ должна измениться
    expect(updated.currentAmount.toNumber()).toBe(10000);
  });
});
