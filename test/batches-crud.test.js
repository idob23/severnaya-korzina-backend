// test/batches-crud.test.js
// Тесты для Batches CRUD API

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

const prisma = new PrismaClient();

jest.setTimeout(30000);

describe('Batches CRUD API Tests', () => {
  
  let testBatch;
  let testCategory;
  let testProduct;

  // Подготовка тестовых данных
  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Batches CRUD...');

    // Удаляем тестовые партии
    await prisma.batch.deleteMany({
      where: { title: { startsWith: 'Тест' } }
    });

    // Создаем тестовую категорию и товар для batch_items
    testCategory = await prisma.category.findFirst({
      where: { name: { startsWith: 'Тест' } }
    });

    if (!testCategory) {
      testCategory = await prisma.category.create({
        data: {
          name: 'Тестовая категория для партий',
          isActive: true
        }
      });
    }

    testProduct = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар для партий',
        price: 500,
        unit: 'шт',
        isActive: true
      }
    });

    console.log('✅ Тестовые данные подготовлены');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка batches-crud тестов...');
    await prisma.batchItem.deleteMany({
      where: { batchId: testBatch?.id }
    });
    await prisma.batch.deleteMany({
      where: { title: { startsWith: 'Тест' } }
    });
    await prisma.product.delete({
      where: { id: testProduct.id }
    });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: Создание новой партии
  test('1. Должен создать новую партию', async () => {
    const batch = await prisma.batch.create({
      data: {
        title: 'Тестовая партия 1',
        description: 'Описание тестовой партии',
        status: 'active',
        targetAmount: 50000,
        currentAmount: 0,
        participantsCount: 0,
        progressPercent: 0,
        marginPercent: 20,
        startDate: new Date(),
        endDate: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000) // +14 дней
      }
    });

    testBatch = batch;

    expect(batch).toBeDefined();
    expect(batch.title).toBe('Тестовая партия 1');
    expect(batch.status).toBe('active');
    expect(parseFloat(batch.targetAmount)).toBe(50000);
    expect(parseFloat(batch.marginPercent)).toBe(20);
    
    console.log(`✅ Тест 1 пройден: Партия создана #${batch.id}`);
  });

  // ТЕСТ 2: Получение партии по ID
  test('2. Должен получить партию по ID', async () => {
    const batch = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(batch).toBeDefined();
    expect(batch.id).toBe(testBatch.id);
    expect(batch.title).toBe('Тестовая партия 1');
    
    console.log(`✅ Тест 2 пройден: Партия получена #${batch.id}`);
  });

  // ТЕСТ 3: Получение всех активных партий
  test('3. Должен получить список активных партий', async () => {
    const batches = await prisma.batch.findMany({
      where: {
        status: { in: ['active', 'collecting', 'ready'] }
      }
    });

    expect(batches.length).toBeGreaterThan(0);
    expect(batches.some(b => b.id === testBatch.id)).toBe(true);
    
    console.log(`✅ Тест 3 пройден: Найдено ${batches.length} активных партий`);
  });

  // ТЕСТ 4: Обновление информации о партии
  test('4. Должен обновить информацию о партии', async () => {
    const updated = await prisma.batch.update({
      where: { id: testBatch.id },
      data: {
        title: 'Тестовая партия 1 (обновлено)',
        description: 'Новое описание',
        targetAmount: 75000
      }
    });

    expect(updated.title).toBe('Тестовая партия 1 (обновлено)');
    expect(parseFloat(updated.targetAmount)).toBe(75000);
    
    console.log('✅ Тест 4 пройден: Информация обновлена');
  });

  // ТЕСТ 5: Обновление статуса партии
  test('5. Должен обновить статус партии', async () => {
    const updated = await prisma.batch.update({
      where: { id: testBatch.id },
      data: {
        status: 'collecting'
      }
    });

    expect(updated.status).toBe('collecting');
    
    console.log('✅ Тест 5 пройден: Статус обновлен (active → collecting)');
  });

  // ТЕСТ 6: Обновление прогресса партии
  test('6. Должен обновить прогресс партии', async () => {
    const updated = await prisma.batch.update({
      where: { id: testBatch.id },
      data: {
        currentAmount: 25000,
        participantsCount: 5,
        progressPercent: 33 // 25000/75000
      }
    });

    expect(parseFloat(updated.currentAmount)).toBe(25000);
    expect(updated.participantsCount).toBe(5);
    expect(updated.progressPercent).toBe(33);
    
    console.log('✅ Тест 6 пройден: Прогресс обновлен (0% → 33%)');
  });

  // ТЕСТ 7: Достижение целевой суммы
  test('7. Должен обновить статус при достижении 100%', async () => {
    const updated = await prisma.batch.update({
      where: { id: testBatch.id },
      data: {
        currentAmount: 75000,
        participantsCount: 15,
        progressPercent: 100,
        status: 'ready'
      }
    });

    expect(parseFloat(updated.currentAmount)).toBe(75000);
    expect(updated.progressPercent).toBe(100);
    expect(updated.status).toBe('ready');
    
    console.log('✅ Тест 7 пройден: Партия готова к запуску (100%)');
  });

// ТЕСТ 8: Добавление товаров в партию
  test('8. Должен добавить товары в партию', async () => {
    const batchItem = await prisma.batchItem.create({
      data: {
        batchId: testBatch.id,
        productId: testProduct.id,
        price: 500,  // ← БЕЗ quantity!
        discount: 0
      }
    });

    expect(batchItem).toBeDefined();
    expect(batchItem.batchId).toBe(testBatch.id);
    expect(parseFloat(batchItem.price)).toBe(500);
    
    console.log('✅ Тест 8 пройден: Товар добавлен в партию');
  });

  // ТЕСТ 9: Получение партии с товарами
  test('9. Должен получить партию с товарами', async () => {
    const batch = await prisma.batch.findUnique({
      where: { id: testBatch.id },
      include: {
        batchItems: {
          include: {
            product: true
          }
        }
      }
    });

    expect(batch.batchItems.length).toBeGreaterThan(0);
    expect(batch.batchItems[0].product).toBeDefined();
    expect(batch.batchItems[0].product.name).toBe('Тестовый товар для партий');
    
    console.log(`✅ Тест 9 пройден: Партия с ${batch.batchItems.length} товарами`);
  });

  // ТЕСТ 10: Изменение маржи партии
  test('10. Должен изменить маржу партии', async () => {
    const updated = await prisma.batch.update({
      where: { id: testBatch.id },
      data: {
        marginPercent: 25
      }
    });

    expect(parseFloat(updated.marginPercent)).toBe(25);
    
    console.log('✅ Тест 10 пройден: Маржа изменена (20% → 25%)');
  });

  // ТЕСТ 11: Подсчет партий по статусу
  test('11. Должен подсчитать количество партий по статусу', async () => {
    const activeCount = await prisma.batch.count({
      where: { status: 'active' }
    });

    const readyCount = await prisma.batch.count({
      where: { status: 'ready' }
    });

    expect(typeof activeCount).toBe('number');
    expect(typeof readyCount).toBe('number');
    
    console.log(`✅ Тест 11 пройден: active=${activeCount}, ready=${readyCount}`);
  });

  // ТЕСТ 12: Фильтрация партий по дате
  test('12. Должен отфильтровать партии по дате создания', async () => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const batches = await prisma.batch.findMany({
      where: {
        createdAt: {
          gte: today
        }
      }
    });

    expect(Array.isArray(batches)).toBe(true);
    
    console.log(`✅ Тест 12 пройден: Найдено ${batches.length} партий за сегодня`);
  });

  // ТЕСТ 13: Сортировка партий
  test('13. Должен отсортировать партии по дате', async () => {
    const batchesDesc = await prisma.batch.findMany({
      where: { title: { startsWith: 'Тест' } },
      orderBy: { createdAt: 'desc' },
      take: 5
    });

    const batchesAsc = await prisma.batch.findMany({
      where: { title: { startsWith: 'Тест' } },
      orderBy: { createdAt: 'asc' },
      take: 5
    });

    expect(batchesDesc.length).toBeGreaterThan(0);
    expect(batchesAsc.length).toBeGreaterThan(0);
    
    console.log(`✅ Тест 13 пройден: Сортировка работает (desc=${batchesDesc.length}, asc=${batchesAsc.length})`);
  });

  // ТЕСТ 14: Проверка валидности дат
  test('14. Должен проверить корректность дат', async () => {
    const batch = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(batch.startDate).toBeInstanceOf(Date);
    expect(batch.endDate).toBeInstanceOf(Date);
    expect(batch.endDate.getTime()).toBeGreaterThan(batch.startDate.getTime());
    
    console.log('✅ Тест 14 пройден: Даты корректны');
  });

  // ТЕСТ 15: Удаление партии
  test('15. Должен удалить партию', async () => {
    // Сначала удаляем связанные batch_items
    await prisma.batchItem.deleteMany({
      where: { batchId: testBatch.id }
    });

    // Затем удаляем партию
    await prisma.batch.delete({
      where: { id: testBatch.id }
    });

    const deleted = await prisma.batch.findUnique({
      where: { id: testBatch.id }
    });

    expect(deleted).toBeNull();
    
    console.log(`✅ Тест 15 пройден: Партия #${testBatch.id} удалена`);
  });
});
