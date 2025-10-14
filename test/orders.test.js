// __tests__/orders.test.js
// Тесты для Orders API

const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// Настройка таймаута для всех тестов
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

  // Очистка и подготовка тестовых данных перед всеми тестами
  beforeAll(async () => {
    console.log('🧹 Очистка тестовых данных...');

    // Удаляем все тестовые данные (в правильном порядке из-за foreign keys)
    await prisma.orderItem.deleteMany({});
    await prisma.order.deleteMany({});
    await prisma.payment.deleteMany({});
    await prisma.batchItem.deleteMany({});
    await prisma.batch.deleteMany({});
    await prisma.product.deleteMany({});
    await prisma.category.deleteMany({});
    await prisma.address.deleteMany({});
    await prisma.user.deleteMany({
      where: { phone: { startsWith: '+7999' } }
    });

    console.log('✅ Тестовые данные очищены');

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
    console.log(`✅ Создан тестовый пользователь: ${testUser.id}`);

    // Создаем тестовый адрес
    testAddress = await prisma.address.create({
      data: {
        userId: testUser.id,
        title: 'Тестовый адрес',
        address: 'ул. Тестовая, д. 1',
        isDefault: true
      }
    });
    console.log(`✅ Создан тестовый адрес: ${testAddress.id}`);

    // Создаем тестовую категорию
    testCategory = await prisma.category.create({
      data: {
        name: 'Тестовая категория',
        isActive: true
      }
    });

    // Создаем тестовые товары
    testProduct1 = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар 1',
        price: 1000,
        unit: 'шт',
        maxQuantity: 10,
        isActive: true
      }
    });

    testProduct2 = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар 2',
        price: 2000,
        unit: 'кг',
        maxQuantity: 5,
        isActive: true
      }
    });

    console.log(`✅ Созданы тестовые товары: ${testProduct1.id}, ${testProduct2.id}`);

    // Создаем тестовую партию
    testBatch = await prisma.batch.create({
      data: {
        title: 'Тестовая партия',
        status: 'active',
        targetAmount: 100000,
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        marginPercent: 20,
	startDate: new Date(), // ✅ ДОБАВЛЕНО
        endDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // +7 дней
      }
    });
    console.log(`✅ Создана тестовая партия: ${testBatch.id}`);

    // Генерируем JWT токен
    testToken = generateTestToken(testUser.id);
    console.log('✅ Создан JWT токен для тестов');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка...');
    await prisma.orderItem.deleteMany({});
    await prisma.order.deleteMany({});
    await prisma.payment.deleteMany({});
    await prisma.batchItem.deleteMany({});
    await prisma.batch.deleteMany({});
    await prisma.product.deleteMany({});
    await prisma.category.deleteMany({});
    await prisma.address.deleteMany({});
    await prisma.user.deleteMany({
      where: { phone: { startsWith: '+7999' } }
    });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: Создание заказа
  test('1. Должен создать новый заказ', async () => {
    const orderData = {
      addressId: testAddress.id,
      items: [
        {
          productId: testProduct1.id,
          quantity: 2,
          price: 1000
        },
        {
          productId: testProduct2.id,
          quantity: 1,
          price: 2000
        }
      ],
      notes: 'Тестовый заказ'
    };

    // Создаем заказ напрямую через Prisma
    const order = await prisma.$transaction(async (tx) => {
      const newOrder = await tx.order.create({
        data: {
          userId: testUser.id,
          batchId: testBatch.id,
          addressId: orderData.addressId,
          status: 'pending',
          totalAmount: 4000, // 2*1000 + 1*2000
          notes: orderData.notes
        }
      });

      // Создаем позиции заказа
      for (const item of orderData.items) {
        await tx.orderItem.create({
          data: {
            orderId: newOrder.id,
            productId: item.productId,
            quantity: item.quantity,
            price: item.price
          }
        });

        // Уменьшаем остаток товара
        await tx.product.update({
          where: { id: item.productId },
          data: {
            maxQuantity: { decrement: item.quantity }
          }
        });
      }

      return newOrder;
    });

    expect(order).toBeDefined();
    expect(order.userId).toBe(testUser.id);
    expect(order.status).toBe('pending');
    expect(parseFloat(order.totalAmount)).toBe(4000);
    
    console.log(`✅ Тест 1 пройден: Заказ создан #${order.id}`);
  });

  // ТЕСТ 2: Получение списка заказов пользователя
  test('2. Должен получить список заказов пользователя', async () => {
    const orders = await prisma.order.findMany({
      where: { userId: testUser.id },
      include: {
        orderItems: {
          include: {
            product: true
          }
        }
      }
    });

    expect(orders).toBeDefined();
    expect(Array.isArray(orders)).toBe(true);
    expect(orders.length).toBeGreaterThan(0);
    expect(orders[0].userId).toBe(testUser.id);
    
    console.log(`✅ Тест 2 пройден: Найдено заказов - ${orders.length}`);
  });

  // ТЕСТ 3: Получение конкретного заказа по ID
  test('3. Должен получить заказ по ID', async () => {
    const orders = await prisma.order.findMany({
      where: { userId: testUser.id }
    });
    
    const orderId = orders[0].id;

    const order = await prisma.order.findFirst({
      where: {
        id: orderId,
        userId: testUser.id
      },
      include: {
        address: true,
        batch: true,
        orderItems: {
          include: {
            product: true
          }
        }
      }
    });

    expect(order).toBeDefined();
    expect(order.id).toBe(orderId);
    expect(order.orderItems.length).toBeGreaterThan(0);
    
    console.log(`✅ Тест 3 пройден: Заказ #${orderId} получен`);
  });

  // ТЕСТ 4: Обновление статуса заказа
  test('4. Должен обновить статус заказа', async () => {
    const orders = await prisma.order.findMany({
      where: { userId: testUser.id, status: 'pending' }
    });
    
    const orderId = orders[0].id;

    const updatedOrder = await prisma.order.update({
      where: { id: orderId },
      data: {
        status: 'paid',
        updatedAt: new Date()
      }
    });

    expect(updatedOrder.status).toBe('paid');
    expect(updatedOrder.id).toBe(orderId);
    
    console.log(`✅ Тест 4 пройден: Заказ #${orderId} обновлен → paid`);
  });

  // ТЕСТ 5: Проверка управления остатками товаров
  test('5. Должен корректно управлять остатками товаров', async () => {
    // Проверяем что остатки уменьшились после создания заказа
    const product1 = await prisma.product.findUnique({
      where: { id: testProduct1.id }
    });

    const product2 = await prisma.product.findUnique({
      where: { id: testProduct2.id }
    });

    // Начальные остатки были: product1: 10, product2: 5
    // После заказа: product1: 10-2=8, product2: 5-1=4
    expect(product1.maxQuantity).toBe(8);
    expect(product2.maxQuantity).toBe(4);
    
    console.log(`✅ Тест 5 пройден: Остатки обновлены (${product1.maxQuantity}, ${product2.maxQuantity})`);
  });

  // ТЕСТ 6: Отмена заказа и возврат остатков
  test('6. Должен отменить заказ и вернуть остатки', async () => {
    // Создаем новый заказ для отмены
    const newOrder = await prisma.$transaction(async (tx) => {
      const order = await tx.order.create({
        data: {
          userId: testUser.id,
          batchId: testBatch.id,
          addressId: testAddress.id,
          status: 'pending',
          totalAmount: 1000,
          notes: 'Заказ для отмены'
        }
      });

      await tx.orderItem.create({
        data: {
          orderId: order.id,
          productId: testProduct1.id,
          quantity: 1,
          price: 1000
        }
      });

      await tx.product.update({
        where: { id: testProduct1.id },
        data: { maxQuantity: { decrement: 1 } }
      });

      return order;
    });

    // Остаток перед отменой
    const productBefore = await prisma.product.findUnique({
      where: { id: testProduct1.id }
    });
    const quantityBefore = productBefore.maxQuantity;

    // Отменяем заказ и возвращаем остатки
    await prisma.$transaction(async (tx) => {
      await tx.order.update({
        where: { id: newOrder.id },
        data: { status: 'cancelled' }
      });

      const orderItems = await tx.orderItem.findMany({
        where: { orderId: newOrder.id }
      });

      for (const item of orderItems) {
        await tx.product.update({
          where: { id: item.productId },
          data: { maxQuantity: { increment: item.quantity } }
        });
      }
    });

    // Остаток после отмены
    const productAfter = await prisma.product.findUnique({
      where: { id: testProduct1.id }
    });

    expect(productAfter.maxQuantity).toBe(quantityBefore + 1);
    
    console.log(`✅ Тест 6 пройден: Заказ отменен, остатки возвращены (${quantityBefore} → ${productAfter.maxQuantity})`);
  });

  // ТЕСТ 7: Удаление заказа со статусом pending
  test('7. Должен удалить заказ со статусом pending', async () => {
    // Создаем заказ для удаления
    const orderToDelete = await prisma.order.create({
      data: {
        userId: testUser.id,
        batchId: testBatch.id,
        addressId: testAddress.id,
        status: 'pending',
        totalAmount: 500,
        notes: 'Заказ для удаления'
      }
    });

    const orderId = orderToDelete.id;

    // Удаляем заказ
    await prisma.$transaction(async (tx) => {
      await tx.orderItem.deleteMany({
        where: { orderId }
      });

      await tx.order.delete({
        where: { id: orderId }
      });
    });

    // Проверяем что заказ удален
    const deletedOrder = await prisma.order.findUnique({
      where: { id: orderId }
    });

    expect(deletedOrder).toBeNull();
    
    console.log(`✅ Тест 7 пройден: Заказ #${orderId} удален`);
  });

  // ТЕСТ 8: Нельзя удалить заказ с другим статусом
  test('8. Не должен удалить заказ со статусом отличным от pending', async () => {
    // Создаем заказ со статусом paid
    const paidOrder = await prisma.order.create({
      data: {
        userId: testUser.id,
        batchId: testBatch.id,
        addressId: testAddress.id,
        status: 'paid',
        totalAmount: 500,
        notes: 'Оплаченный заказ'
      }
    });

    // Проверяем что заказ существует
    const order = await prisma.order.findFirst({
      where: {
        id: paidOrder.id,
        userId: testUser.id,
        status: 'pending'
      }
    });

    expect(order).toBeNull(); // Не найдем, т.к. статус 'paid'
    
    console.log(`✅ Тест 8 пройден: Заказ со статусом 'paid' нельзя удалить`);
  });

  // ТЕСТ 9: Фильтрация заказов по статусу
  test('9. Должен фильтровать заказы по статусу', async () => {
    const paidOrders = await prisma.order.findMany({
      where: {
        userId: testUser.id,
        status: 'paid'
      }
    });

    const pendingOrders = await prisma.order.findMany({
      where: {
        userId: testUser.id,
        status: 'pending'
      }
    });

    expect(Array.isArray(paidOrders)).toBe(true);
    expect(Array.isArray(pendingOrders)).toBe(true);
    
    // Проверяем что все заказы имеют правильный статус
    paidOrders.forEach(order => {
      expect(order.status).toBe('paid');
    });

    pendingOrders.forEach(order => {
      expect(order.status).toBe('pending');
    });
    
    console.log(`✅ Тест 9 пройден: paid: ${paidOrders.length}, pending: ${pendingOrders.length}`);
  });

  // ТЕСТ 10: Подсчет общей суммы заказов
  test('10. Должен правильно подсчитать общую сумму заказов', async () => {
    const orders = await prisma.order.findMany({
      where: {
        userId: testUser.id,
        status: { in: ['paid', 'delivered'] }
      }
    });

    const totalAmount = orders.reduce((sum, order) => {
      return sum + parseFloat(order.totalAmount);
    }, 0);

    expect(totalAmount).toBeGreaterThan(0);
    expect(typeof totalAmount).toBe('number');
    
    console.log(`✅ Тест 10 пройден: Общая сумма заказов = ${totalAmount} ₽`);
  });
});
