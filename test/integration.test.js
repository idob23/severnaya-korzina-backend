// test/integration.test.js
// Integration E2E тесты - полный цикл работы системы

const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

jest.setTimeout(60000); // Увеличиваем таймаут для integration тестов

describe('Integration E2E Tests - Полный цикл', () => {
  
  let testUser;
  let testToken;
  let testAddress;
  let testCategory;
  let testProduct1;
  let testProduct2;
  let testBatch;
  let testOrder;
  let testPayment;

  // Полная очистка и подготовка
  beforeAll(async () => {
    console.log('🧹 Подготовка Integration тестов...');
    console.log('⚠️  Очистка всех тестовых данных...');

    // Удаляем все тестовые данные
    await prisma.payment.deleteMany({
      where: { provider: 'test-integration' }
    });
    await prisma.orderItem.deleteMany({});
    await prisma.order.deleteMany({
      where: { notes: { startsWith: 'INTEGRATION_TEST' } }
    });
    await prisma.batchItem.deleteMany({});
    await prisma.batch.deleteMany({
      where: { title: { startsWith: 'INTEGRATION_TEST' } }
    });
    await prisma.product.deleteMany({
      where: { name: { startsWith: 'INTEGRATION_TEST' } }
    });
    await prisma.category.deleteMany({
      where: { name: { startsWith: 'INTEGRATION_TEST' } }
    });
    await prisma.address.deleteMany({
      where: { title: { startsWith: 'INTEGRATION_TEST' } }
    });
    await prisma.user.deleteMany({
      where: { phone: '+79998881111' }
    });

    console.log('✅ Очистка завершена');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка integration тестов...');
    
    if (testPayment) await prisma.payment.delete({ where: { id: testPayment.id } }).catch(() => {});
    if (testOrder) {
      await prisma.orderItem.deleteMany({ where: { orderId: testOrder.id } });
      await prisma.order.delete({ where: { id: testOrder.id } }).catch(() => {});
    }
    if (testBatch) {
      await prisma.batchItem.deleteMany({ where: { batchId: testBatch.id } });
      await prisma.batch.delete({ where: { id: testBatch.id } }).catch(() => {});
    }
    if (testProduct1) await prisma.product.delete({ where: { id: testProduct1.id } }).catch(() => {});
    if (testProduct2) await prisma.product.delete({ where: { id: testProduct2.id } }).catch(() => {});
    if (testCategory) await prisma.category.delete({ where: { id: testCategory.id } }).catch(() => {});
    if (testAddress) await prisma.address.delete({ where: { id: testAddress.id } }).catch(() => {});
    if (testUser) await prisma.user.delete({ where: { id: testUser.id } }).catch(() => {});
    
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ========================================
  // СЦЕНАРИЙ 1: РЕГИСТРАЦИЯ ПОЛЬЗОВАТЕЛЯ
  // ========================================
  
  test('СЦЕНАРИЙ 1.1: Регистрация нового пользователя', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 1: Регистрация пользователя');
    
    testUser = await prisma.user.create({
      data: {
        phone: '+79998881111',
        firstName: 'Иван',
        lastName: 'Интеграционный',
        email: 'integration@test.ru',
        isActive: true
      }
    });

    expect(testUser).toBeDefined();
    expect(testUser.phone).toBe('+79998881111');
    
    console.log(`✅ 1.1: Пользователь зарегистрирован #${testUser.id}`);
  });

  test('СЦЕНАРИЙ 1.2: Генерация JWT токена', async () => {
    testToken = jwt.sign(
      { userId: testUser.id, phone: testUser.phone },
      process.env.JWT_SECRET || 'test-secret-key-for-testing',
      { expiresIn: '7d' }
    );

    expect(testToken).toBeDefined();
    
    const decoded = jwt.verify(
      testToken,
      process.env.JWT_SECRET || 'test-secret-key-for-testing'
    );
    expect(decoded.userId).toBe(testUser.id);
    
    console.log('✅ 1.2: JWT токен сгенерирован');
  });

  test('СЦЕНАРИЙ 1.3: Добавление адреса доставки', async () => {
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'INTEGRATION_TEST Домашний адрес',
        address: 'ул. Тестовая, д. 1, кв. 1',
        isDefault: true
      }
    });

    expect(testAddress).toBeDefined();
    expect(testAddress.userId).toBe(testUser.id);
    
    console.log(`✅ 1.3: Адрес добавлен #${testAddress.id}`);
  });

  // ========================================
  // СЦЕНАРИЙ 2: СОЗДАНИЕ КАТАЛОГА
  // ========================================

  test('СЦЕНАРИЙ 2.1: Создание категории товаров', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 2: Создание каталога');
    
    testCategory = await prisma.category.create({
      data: {
        name: 'INTEGRATION_TEST Продукты',
        description: 'Тестовая категория',
        isActive: true
      }
    });

    expect(testCategory).toBeDefined();
    
    console.log(`✅ 2.1: Категория создана #${testCategory.id}`);
  });

  test('СЦЕНАРИЙ 2.2: Добавление товаров в каталог', async () => {
    testProduct1 = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'INTEGRATION_TEST Молоко',
        price: 85.50,
        unit: 'л',
        maxQuantity: 100,
        isActive: true
      }
    });

    testProduct2 = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'INTEGRATION_TEST Хлеб',
        price: 45.00,
        unit: 'шт',
        maxQuantity: 50,
        isActive: true
      }
    });

    expect(testProduct1).toBeDefined();
    expect(testProduct2).toBeDefined();
    
    console.log(`✅ 2.2: Товары добавлены (#${testProduct1.id}, #${testProduct2.id})`);
  });

  // ========================================
  // СЦЕНАРИЙ 3: СОЗДАНИЕ ПАРТИИ
  // ========================================

  test('СЦЕНАРИЙ 3.1: Создание новой партии закупки', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 3: Создание партии');
    
    testBatch = await prisma.batch.create({
      data: {
        title: 'INTEGRATION_TEST Партия #1',
        description: 'Тестовая партия для integration тестов',
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

    expect(testBatch).toBeDefined();
    expect(testBatch.status).toBe('active');
    
    console.log(`✅ 3.1: Партия создана #${testBatch.id}`);
  });

  test('СЦЕНАРИЙ 3.2: Добавление товаров в партию', async () => {
    const batchItem1 = await prisma.batchItem.create({
      data: {
        batchId: testBatch.id,
        productId: testProduct1.id,
        price: 85.50
      }
    });

    const batchItem2 = await prisma.batchItem.create({
      data: {
        batchId: testBatch.id,
        productId: testProduct2.id,
        price: 45.00
      }
    });

    expect(batchItem1).toBeDefined();
    expect(batchItem2).toBeDefined();
    
    console.log('✅ 3.2: Товары добавлены в партию');
  });

  // ========================================
  // СЦЕНАРИЙ 4: ОФОРМЛЕНИЕ ЗАКАЗА
  // ========================================

  test('СЦЕНАРИЙ 4.1: Создание заказа пользователем', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 4: Оформление заказа');
    
    testOrder = await prisma.order.create({
      data: {
        userId: testUser.id,
        batchId: testBatch.id,
        addressId: testAddress.id,
        status: 'pending',
        totalAmount: 261, // (85.50*2 + 45*2) = 261
        notes: 'INTEGRATION_TEST Тестовый заказ'
      }
    });

    expect(testOrder).toBeDefined();
    expect(testOrder.status).toBe('pending');
    
    console.log(`✅ 4.1: Заказ создан #${testOrder.id}`);
  });

  test('СЦЕНАРИЙ 4.2: Добавление позиций в заказ', async () => {
    const item1 = await prisma.orderItem.create({
      data: {
        orderId: testOrder.id,
        productId: testProduct1.id,
        quantity: 2,
        price: 85.50
      }
    });

    const item2 = await prisma.orderItem.create({
      data: {
        orderId: testOrder.id,
        productId: testProduct2.id,
        quantity: 2,
        price: 45.00
      }
    });

    expect(item1).toBeDefined();
    expect(item2).toBeDefined();
    
    console.log('✅ 4.2: Позиции добавлены в заказ');
  });

  test('СЦЕНАРИЙ 4.3: Уменьшение остатков товаров', async () => {
    await prisma.product.update({
      where: { id: testProduct1.id },
      data: { maxQuantity: { decrement: 2 } }
    });

    await prisma.product.update({
      where: { id: testProduct2.id },
      data: { maxQuantity: { decrement: 2 } }
    });

    const product1 = await prisma.product.findUnique({
      where: { id: testProduct1.id }
    });

    const product2 = await prisma.product.findUnique({
      where: { id: testProduct2.id }
    });

    expect(product1.maxQuantity).toBe(98); // 100 - 2
    expect(product2.maxQuantity).toBe(48); // 50 - 2
    
    console.log('✅ 4.3: Остатки товаров уменьшены');
  });

  // ========================================
  // СЦЕНАРИЙ 5: ОПЛАТА ЗАКАЗА
  // ========================================

  test('СЦЕНАРИЙ 5.1: Создание платежа', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 5: Оплата заказа');
    
    testPayment = await prisma.payment.create({
      data: {
        paymentId: `INTEGRATION_TEST_${Date.now()}`,
        orderId: testOrder.id,
        status: 'CREATED',
        amount: 261,
        provider: 'test-integration'
      }
    });

    expect(testPayment).toBeDefined();
    expect(testPayment.status).toBe('CREATED');
    
    console.log(`✅ 5.1: Платеж создан #${testPayment.id}`);
  });

  test('СЦЕНАРИЙ 5.2: Обновление статуса платежа на APPROVED', async () => {
    const updated = await prisma.payment.update({
      where: { id: testPayment.id },
      data: {
        status: 'APPROVED',
        paidAt: new Date()
      }
    });

    expect(updated.status).toBe('APPROVED');
    expect(updated.paidAt).toBeDefined();
    
    console.log('✅ 5.2: Платеж одобрен');
  });

  test('СЦЕНАРИЙ 5.3: Обновление статуса заказа на paid', async () => {
    const updated = await prisma.order.update({
      where: { id: testOrder.id },
      data: {
        status: 'paid',
        updatedAt: new Date()
      }
    });

    expect(updated.status).toBe('paid');
    
    console.log('✅ 5.3: Заказ оплачен');
  });

  // ========================================
  // СЦЕНАРИЙ 6: ОБНОВЛЕНИЕ ПАРТИИ
  // ========================================

  test('СЦЕНАРИЙ 6.1: Обновление статистики партии', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 6: Обновление партии');
    
    const { updateBatchStatistics } = require('../src/utils/batchCalculations');
    const result = await updateBatchStatistics(testBatch.id);

    expect(result.success).toBe(true);
    
    console.log('✅ 6.1: Статистика партии обновлена');
  });

  test('СЦЕНАРИЙ 6.2: Проверка прогресса партии', async () => {
    const batch = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(parseFloat(batch.currentAmount)).toBeGreaterThan(0);
    expect(batch.participantsCount).toBe(1);
    expect(batch.progressPercent).toBeGreaterThan(0);
    
    console.log(`✅ 6.2: Прогресс партии = ${batch.progressPercent}%`);
  });

  // ========================================
  // СЦЕНАРИЙ 7: ЖИЗНЕННЫЙ ЦИКЛ ЗАКАЗА
  // ========================================

  test('СЦЕНАРИЙ 7.1: Обновление статуса заказа на shipped', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 7: Жизненный цикл заказа');
    
    const updated = await prisma.order.update({
      where: { id: testOrder.id },
      data: { status: 'shipped' }
    });

    expect(updated.status).toBe('shipped');
    
    console.log('✅ 7.1: Заказ отправлен');
  });

  test('СЦЕНАРИЙ 7.2: Доставка заказа', async () => {
    const updated = await prisma.order.update({
      where: { id: testOrder.id },
      data: { status: 'delivered' }
    });

    expect(updated.status).toBe('delivered');
    
    console.log('✅ 7.2: Заказ доставлен');
  });

  // ========================================
  // СЦЕНАРИЙ 8: ПРОВЕРКА ЦЕЛОСТНОСТИ
  // ========================================

  test('СЦЕНАРИЙ 8.1: Проверка связей пользователь → заказ', async () => {
    console.log('\n🎬 СЦЕНАРИЙ 8: Проверка целостности');
    
    const user = await prisma.user.findUnique({
      where: { id: testUser.id },
      include: {
        orders: true
      }
    });

    expect(user.orders.length).toBeGreaterThan(0);
    expect(user.orders[0].id).toBe(testOrder.id);
    
    console.log('✅ 8.1: Связь пользователь → заказ работает');
  });

  test('СЦЕНАРИЙ 8.2: Проверка связей заказ → платеж', async () => {
    const order = await prisma.order.findUnique({
      where: { id: testOrder.id },
      include: {
        payments: true
      }
    });

    expect(order.payments.length).toBeGreaterThan(0);
    expect(order.payments[0].id).toBe(testPayment.id);
    
    console.log('✅ 8.2: Связь заказ → платеж работает');
  });

  test('СЦЕНАРИЙ 8.3: Проверка связей партия → заказы', async () => {
    const batch = await prisma.batch.findUnique({
      where: { id: testBatch.id },
      include: {
        orders: true
      }
    });

    expect(batch.orders.length).toBeGreaterThan(0);
    
    console.log('✅ 8.3: Связь партия → заказы работает');
  });

  // ========================================
  // ИТОГОВАЯ ПРОВЕРКА
  // ========================================

  test('ИТОГ: Полный цикл завершен успешно', async () => {
    console.log('\n🏆 ИТОГОВАЯ ПРОВЕРКА');
    
    // Проверяем что все объекты созданы
    expect(testUser).toBeDefined();
    expect(testAddress).toBeDefined();
    expect(testCategory).toBeDefined();
    expect(testProduct1).toBeDefined();
    expect(testProduct2).toBeDefined();
    expect(testBatch).toBeDefined();
    expect(testOrder).toBeDefined();
    expect(testPayment).toBeDefined();

    // Проверяем финальные статусы
    const order = await prisma.order.findUnique({
      where: { id: testOrder.id }
    });
    expect(order.status).toBe('delivered');

    const payment = await prisma.payment.findUnique({
      where: { id: testPayment.id }
    });
    expect(payment.status).toBe('APPROVED');

    console.log('✅ ПОЛНЫЙ ЦИКЛ ЗАВЕРШЕН УСПЕШНО!');
    console.log('🎉 Integration тесты пройдены!');
  });
});
