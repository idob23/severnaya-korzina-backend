// test/payments.test.js - ИСПРАВЛЕННАЯ ВЕРСИЯ
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

jest.setTimeout(30000);

describe('Payments - Критичные тесты', () => {
  
  let testUser;
  let testAddress; // ← ДОБАВИЛИ
  let testOrder;
  let testPayment;

  // Создаём тестовые данные
  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Payments...');

    // Создаём тестового пользователя если нет
    testUser = await prisma.user.upsert({
      where: { phone: '79999999999' },
      update: {},
      create: {
        phone: '79999999999',
        firstName: 'Test',
        isActive: true
      }
    });
    console.log(`✅ Создан тестовый пользователь: ${testUser.id}`);

    // ✅ СОЗДАЕМ АДРЕС ДЛЯ ПОЛЬЗОВАТЕЛЯ
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'Тестовый адрес для платежей',
        address: 'ул. Тестовая, д. 1',
        isDefault: true
      }
    });
    console.log(`✅ Создан тестовый адрес: ${testAddress.id}`);

    // Создаём тестовый заказ
    testOrder = await prisma.order.create({
      data: {
        userId: testUser.id,
        status: 'pending',
        totalAmount: 1200,
        addressId: testAddress.id // ✅ ИСПОЛЬЗУЕМ СОЗДАННЫЙ АДРЕС
      }
    });
    console.log(`✅ Создан тестовый заказ: ${testOrder.id}`);
  });

  afterAll(async () => {
    console.log('🧹 Финальная очистка payments тестов...');
    // Очистка
    if (testPayment) await prisma.payment.delete({ where: { id: testPayment.id } }).catch(() => {});
    if (testOrder) await prisma.order.delete({ where: { id: testOrder.id } }).catch(() => {});
    if (testAddress) await prisma.address.delete({ where: { id: testAddress.id } }).catch(() => {});
    if (testUser) await prisma.user.delete({ where: { id: testUser.id } }).catch(() => {});
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
    console.log(`✅ Тест 2 пройден: Payment создан #${testPayment.id}`);
  });

  test('3. Обновление статуса payment на APPROVED', async () => {
    const updated = await prisma.payment.update({
      where: { id: testPayment.id },
      data: { 
        status: 'APPROVED',
        paidAt: new Date()
      }
    });

    expect(updated.status).toBe('APPROVED');
    expect(updated.paidAt).toBeDefined();
    console.log('✅ Тест 3 пройден: Статус обновлен на APPROVED');
  });

  test('4. Каскадное удаление: order удаляется → payment удаляется', async () => {
    // Создаём новую пару order-payment
    const order = await prisma.order.create({
      data: {
        userId: testUser.id,
        status: 'pending',
        totalAmount: 100,
        addressId: testAddress.id // ✅ ИСПОЛЬЗУЕМ АДРЕС
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
    console.log('✅ Тест 4 пройден: Каскадное удаление работает');
  });
});
