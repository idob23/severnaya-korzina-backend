const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

describe('Payments - Критичные тесты', () => {
  
  let testOrder;
  let testPayment;

  // Создаём тестовые данные
  beforeAll(async () => {
    // Создаём тестового пользователя если нет
    const user = await prisma.user.upsert({
      where: { phone: '79999999999' },
      update: {},
      create: {
        phone: '79999999999',
        firstName: 'Test',
        acceptedTerms: true
      }
    });

    // Создаём тестовый заказ
    testOrder = await prisma.order.create({
      data: {
        userId: user.id,
        status: 'pending',
        totalAmount: 1200,
        addressId: 1
      }
    });
  });

  afterAll(async () => {
    // Очистка
    if (testPayment) await prisma.payment.delete({ where: { id: testPayment.id } }).catch(() => {});
    if (testOrder) await prisma.order.delete({ where: { id: testOrder.id } }).catch(() => {});
    await prisma.$disconnect();
  });

  test('БД подключается', async () => {
    const result = await prisma.$queryRaw`SELECT 1 as test`;
    expect(result[0].test).toBe(1);
  });

  test('Создание записи payment', async () => {
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
  });

  test('Обновление статуса payment на APPROVED', async () => {
    const updated = await prisma.payment.update({
      where: { id: testPayment.id },
      data: { 
        status: 'APPROVED',
        paidAt: new Date()
      }
    });

    expect(updated.status).toBe('APPROVED');
    expect(updated.paidAt).toBeDefined();
  });

  test('Каскадное удаление: order удаляется → payment удаляется', async () => {
    // Создаём новую пару order-payment
    const order = await prisma.order.create({
      data: {
        userId: testOrder.userId,
        status: 'pending',
        totalAmount: 100,
        addressId: 1
      }
    });

    const payment = await prisma.payment.create({
      data: {
        paymentId: 'CASCADE_TEST_' + Date.now(),
        orderId: order.id,
        status: 'CREATED',
        amount: 100
      }
    });

    // Удаляем order
    await prisma.order.delete({ where: { id: order.id } });

    // Проверяем что payment тоже удалился
    const deletedPayment = await prisma.payment.findUnique({
      where: { id: payment.id }
    });

    expect(deletedPayment).toBeNull();
  });
});
