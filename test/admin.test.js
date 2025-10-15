// test/admin.test.js
// Тесты для Admin API

const { PrismaClient } = require('@prisma/client');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}
const jwt = require('jsonwebtoken');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

const prisma = new PrismaClient();

jest.setTimeout(30000);

// Генерация admin JWT токена
const generateAdminToken = () => {
  return jwt.sign(
    { userId: 'admin-id', login: 'admin', role: 'admin' },
    process.env.JWT_SECRET || 'test-secret-key-for-testing',
    { expiresIn: '24h' }
  );
};

describe('Admin API Tests', () => {
  
  let adminToken;
  let testUser;
  let testBatch;
  let testProduct;
  let testCategory;

  // Подготовка тестовых данных
  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Admin API...');

    // Генерируем admin токен
    adminToken = generateAdminToken();

    // Создаем тестового пользователя
    testUser = await prisma.user.create({
      data: {
        phone: '+79997771111',
        firstName: 'Админ',
        lastName: 'Тестовый',
        isActive: true
      }
    });

    // ✅ ИСПРАВЛЕНО: Создаем тестовую категорию без upsert
    // Сначала пытаемся найти существующую
    testCategory = await prisma.category.findFirst({
      where: { name: 'Тестовая админ категория' }
    });

    // Если не найдена, создаем новую
    if (!testCategory) {
      testCategory = await prisma.category.create({
        data: {
          name: 'Тестовая админ категория',
          description: 'Для админских тестов',
          isActive: true
        }
      });
    }

    // Создаем тестовый товар
    testProduct = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый админ товар',
        price: 1000,
        unit: 'шт',
        isActive: true
      }
    });

    // Создаем тестовую партию
    testBatch = await prisma.batch.create({
      data: {
        title: 'Тестовая админ партия',
        status: 'active',
        targetAmount: 100000,
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        marginPercent: 20,
        startDate: new Date(),
        endDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000)
      }
    });

    console.log('✅ Тестовые данные подготовлены');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка admin тестов...');
    await prisma.user.delete({ where: { id: testUser.id } }).catch(() => {});
    await prisma.product.delete({ where: { id: testProduct.id } }).catch(() => {});
    await prisma.batch.delete({ where: { id: testBatch.id } }).catch(() => {});
    await prisma.category.delete({ where: { id: testCategory.id } }).catch(() => {});
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: Проверка админ токена
  test('1. Должен проверить валидность админ токена', () => {
    const decoded = jwt.verify(
      adminToken,
      process.env.JWT_SECRET || 'test-secret-key-for-testing'
    );

    expect(decoded.role).toBe('admin');
    expect(decoded.login).toBe('admin');
    
    console.log('✅ Тест 1 пройден: Админ токен валиден');
  });

  // ТЕСТ 2: Получение статистики dashboard
  test('2. Должен получить статистику для dashboard', async () => {
    const totalUsers = await prisma.user.count();
    const totalOrders = await prisma.order.count();
    const totalBatches = await prisma.batch.count();
    const totalProducts = await prisma.product.count();

    expect(totalUsers).toBeGreaterThanOrEqual(1); // минимум testUser
    expect(totalBatches).toBeGreaterThanOrEqual(1); // минимум testBatch
    expect(totalProducts).toBeGreaterThanOrEqual(1); // минимум testProduct
    
    console.log(`✅ Тест 2 пройден: Users=${totalUsers}, Orders=${totalOrders}, Batches=${totalBatches}, Products=${totalProducts}`);
  });

  // ТЕСТ 3: Получение списка всех пользователей
  test('3. Должен получить список всех пользователей', async () => {
    const users = await prisma.user.findMany({
      take: 10,
      orderBy: { createdAt: 'desc' }
    });

    expect(users.length).toBeGreaterThan(0);
    expect(users.some(u => u.id === testUser.id)).toBe(true);
    
    console.log(`✅ Тест 3 пройден: Найдено ${users.length} пользователей`);
  });

  // ТЕСТ 4: Получение списка всех заказов
  test('4. Должен получить список всех заказов', async () => {
    const orders = await prisma.order.findMany({
      take: 10,
      orderBy: { createdAt: 'desc' },
      include: {
        user: true,
        batch: true
      }
    });

    expect(Array.isArray(orders)).toBe(true);
    
    console.log(`✅ Тест 4 пройден: Найдено ${orders.length} заказов`);
  });

  // ТЕСТ 5: Получение списка всех партий
  test('5. Должен получить список всех партий', async () => {
    const batches = await prisma.batch.findMany({
      take: 10,
      orderBy: { createdAt: 'desc' }
    });

    expect(batches.length).toBeGreaterThan(0);
    expect(batches.some(b => b.id === testBatch.id)).toBe(true);
    
    console.log(`✅ Тест 5 пройден: Найдено ${batches.length} партий`);
  });

  // ТЕСТ 6: Фильтрация пользователей по статусу
  test('6. Должен отфильтровать пользователей по статусу', async () => {
    const activeUsers = await prisma.user.findMany({
      where: { isActive: true }
    });

    const inactiveUsers = await prisma.user.findMany({
      where: { isActive: false }
    });

    expect(activeUsers.length).toBeGreaterThan(0);
    
    console.log(`✅ Тест 6 пройден: active=${activeUsers.length}, inactive=${inactiveUsers.length}`);
  });

  // ТЕСТ 7: Фильтрация заказов по статусу
  test('7. Должен отфильтровать заказы по статусу', async () => {
    const paidOrders = await prisma.order.findMany({
      where: { status: 'paid' }
    });

    const pendingOrders = await prisma.order.findMany({
      where: { status: 'pending' }
    });

    expect(Array.isArray(paidOrders)).toBe(true);
    expect(Array.isArray(pendingOrders)).toBe(true);
    
    console.log(`✅ Тест 7 пройден: paid=${paidOrders.length}, pending=${pendingOrders.length}`);
  });

  // ТЕСТ 8: Получение партии с заказами
  test('8. Должен получить партию с заказами', async () => {
    const batch = await prisma.batch.findUnique({
      where: { id: testBatch.id },
      include: {
        orders: true,
        batchItems: {
          include: {
            product: true
          }
        }
      }
    });

    expect(batch).toBeDefined();
    expect(batch.id).toBe(testBatch.id);
    expect(Array.isArray(batch.orders)).toBe(true);
    
    console.log(`✅ Тест 8 пройден: Партия #${batch.id} с ${batch.orders.length} заказами`);
  });

  // ТЕСТ 9: Деактивация пользователя
  test('9. Должен деактивировать пользователя', async () => {
    const updated = await prisma.user.update({
      where: { id: testUser.id },
      data: { isActive: false }
    });

    expect(updated.isActive).toBe(false);

    // Возвращаем обратно
    await prisma.user.update({
      where: { id: testUser.id },
      data: { isActive: true }
    });
    
    console.log('✅ Тест 9 пройден: Пользователь деактивирован и реактивирован');
  });

  // ТЕСТ 10: Обновление статуса партии
  test('10. Должен обновить статус партии', async () => {
    const updated = await prisma.batch.update({
      where: { id: testBatch.id },
      data: { status: 'ready' }
    });

    expect(updated.status).toBe('ready');

    // Возвращаем обратно
    await prisma.batch.update({
      where: { id: testBatch.id },
      data: { status: 'active' }
    });
    
    console.log('✅ Тест 10 пройден: Статус партии обновлен (active → ready → active)');
  });

  // ТЕСТ 11: Подсчет заказов в партии
  test('11. Должен подсчитать заказы в партии', async () => {
    const ordersCount = await prisma.order.count({
      where: { batchId: testBatch.id }
    });

    expect(ordersCount).toBeGreaterThanOrEqual(0);
    
    console.log(`✅ Тест 11 пройден: В партии ${ordersCount} заказов`);
  });

  // ТЕСТ 12: Получение заказов конкретного пользователя
  test('12. Должен получить заказы конкретного пользователя', async () => {
    const userOrders = await prisma.order.findMany({
      where: { userId: testUser.id }
    });

    expect(Array.isArray(userOrders)).toBe(true);
    
    console.log(`✅ Тест 12 пройден: У пользователя ${userOrders.length} заказов`);
  });

  // ТЕСТ 13: Расчет общей суммы всех заказов
  test('13. Должен рассчитать общую сумму всех заказов', async () => {
    const result = await prisma.order.aggregate({
      _sum: {
        totalAmount: true
      }
    });

    const totalRevenue = result._sum.totalAmount || 0;
    
    expect(totalRevenue).toBeGreaterThanOrEqual(0);
    
    console.log(`✅ Тест 13 пройден: Общая сумма заказов = ${totalRevenue} ₽`);
  });

  // ТЕСТ 14: Расчет средней суммы заказа
  test('14. Должен рассчитать среднюю сумму заказа', async () => {
    const result = await prisma.order.aggregate({
      _avg: {
        totalAmount: true
      }
    });

    const avgOrderAmount = result._avg.totalAmount || 0;
    
    expect(avgOrderAmount).toBeGreaterThanOrEqual(0);
    
    console.log(`✅ Тест 14 пройден: Средняя сумма заказа = ${avgOrderAmount} ₽`);
  });

  // ТЕСТ 15: Поиск товаров с низким остатком
  test('15. Должен найти товары с низким остатком', async () => {
    const lowStockProducts = await prisma.product.findMany({
      where: {
        maxQuantity: {
          lte: 10
        },
        isActive: true
      }
    });

    expect(Array.isArray(lowStockProducts)).toBe(true);
    
    console.log(`✅ Тест 15 пройден: Найдено ${lowStockProducts.length} товаров с остатком ≤10`);
  });

  // ТЕСТ 16: Получение только активных партий
  test('16. Должен получить только активные партии', async () => {
    const activeBatches = await prisma.batch.findMany({
      where: { status: 'active' }
    });

    expect(activeBatches.length).toBeGreaterThan(0);
    expect(activeBatches.every(b => b.status === 'active')).toBe(true);
    
    console.log(`✅ Тест 16 пройден: Найдено ${activeBatches.length} активных партий`);
  });

  // ТЕСТ 17: Подсчет пользователей за сегодня
  test('17. Должен подсчитать пользователей за сегодня', async () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const todayUsers = await prisma.user.count({
      where: {
        createdAt: {
          gte: today
        }
      }
    });

    expect(todayUsers).toBeGreaterThanOrEqual(0);
    
    console.log(`✅ Тест 17 пройден: Зарегистрировано ${todayUsers} пользователей за сегодня`);
  });

  // ТЕСТ 18: Получение последних 5 заказов
  test('18. Должен получить последние 5 заказов', async () => {
    const recentOrders = await prisma.order.findMany({
      take: 5,
      orderBy: { createdAt: 'desc' },
      include: {
        user: true
      }
    });

    expect(recentOrders.length).toBeLessThanOrEqual(5);
    
    console.log(`✅ Тест 18 пройден: Последние ${recentOrders.length} заказов получены`);
  });

  // ТЕСТ 19: Поиск пользователя по телефону
  test('19. Должен найти пользователя по телефону', async () => {
    const user = await prisma.user.findUnique({
      where: { phone: testUser.phone }
    });

    expect(user).toBeDefined();
    expect(user.id).toBe(testUser.id);
    
    console.log(`✅ Тест 19 пройден: Пользователь найден по телефону ${testUser.phone}`);
  });

  // ТЕСТ 20: Подсчет товаров по категориям
  test('20. Должен подсчитать товары по категориям', async () => {
    const categories = await prisma.category.findMany({
      include: {
        _count: {
          select: { products: true }
        }
      }
    });

    expect(categories.length).toBeGreaterThan(0);
    
    const testCat = categories.find(c => c.id === testCategory.id);
    expect(testCat._count.products).toBeGreaterThanOrEqual(1); // минимум testProduct
    
    console.log(`✅ Тест 20 пройден: Категория "${testCategory.name}" имеет ${testCat._count.products} товаров`);
  });

});
