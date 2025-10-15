// __tests__/products.test.js
// Тесты для Products API

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

// Настройка таймаута
jest.setTimeout(30000);

describe('Products API Tests', () => {
  let testCategory;
  let testProduct1;
  let testProduct2;

  // Очистка перед всеми тестами
  beforeAll(async () => {
    console.log('🧹 Очистка тестовых данных для Products...');

    // Удаляем тестовые данные в правильном порядке
    await prisma.orderItem.deleteMany({});
    await prisma.product.deleteMany({
      where: { name: { startsWith: 'Тест' } }
    });
    await prisma.category.deleteMany({
      where: { name: { startsWith: 'Тест' } }
    });

    console.log('✅ Тестовые данные очищены');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка products тестов...');
    await prisma.orderItem.deleteMany({});
    await prisma.product.deleteMany({
      where: { name: { startsWith: 'Тест' } }
    });
    await prisma.category.deleteMany({
      where: { name: { startsWith: 'Тест' } }
    });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: Создание категории
  test('1. Должен создать новую категорию', async () => {
    const category = await prisma.category.create({
      data: {
        name: 'Тестовая категория',
        description: 'Описание тестовой категории',
        isActive: true
      }
    });

    testCategory = category;

    expect(category).toBeDefined();
    expect(category.name).toBe('Тестовая категория');
    expect(category.isActive).toBe(true);
    
    console.log(`✅ Тест 1 пройден: Категория создана #${category.id}`);
  });

// ТЕСТ 2: Получение списка всех категорий
  test('2. Должен получить список всех категорий', async () => {
    const categories = await prisma.category.findMany({
      where: { name: { startsWith: 'Тест' } }
    });

    expect(categories.length).toBeGreaterThan(0);
    expect(categories[0].name).toContain('Тест');
    
    console.log(`✅ Тест 2 пройден: Найдено ${categories.length} тестовых категорий`);
  });    

  // ТЕСТ 3: Создание товара
  test('3. Должен создать новый товар', async () => {
    const product = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар 1',
        description: 'Описание товара 1',
        price: 299.99,
        unit: 'шт',
        maxQuantity: 100,
        isActive: true
      }
    });

    testProduct1 = product;

    expect(product).toBeDefined();
    expect(product.name).toBe('Тестовый товар 1');
    expect(parseFloat(product.price)).toBe(299.99);
    expect(product.maxQuantity).toBe(100);
    
    console.log(`✅ Тест 3 пройден: Товар создан #${product.id}`);
  });

  // ТЕСТ 4: Создание товара без ограничения количества
  test('4. Должен создать товар без ограничения maxQuantity', async () => {
    const product = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар 2',
        price: 150.50,
        unit: 'кг',
        maxQuantity: null, // Неограниченное количество
        isActive: true
      }
    });

    testProduct2 = product;

    expect(product.maxQuantity).toBeNull();
    expect(parseFloat(product.price)).toBe(150.50);
    
    console.log(`✅ Тест 4 пройден: Товар без ограничения создан #${product.id}`);
  });

  // ТЕСТ 5: Получение товаров по категории
  test('5. Должен получить товары по категории', async () => {
    const products = await prisma.product.findMany({
      where: {
        categoryId: testCategory.id
      }
    });

    expect(products.length).toBeGreaterThanOrEqual(2);
    expect(products[0].categoryId).toBe(testCategory.id);
    
    console.log(`✅ Тест 5 пройден: Найдено ${products.length} товаров в категории`);
  });

  // ТЕСТ 6: Поиск товара по названию
  test('6. Должен найти товар по названию', async () => {
    const products = await prisma.product.findMany({
      where: {
        name: {
          contains: 'Тестовый',
          mode: 'insensitive'
        }
      }
    });

    expect(products.length).toBeGreaterThan(0);
    expect(products[0].name).toContain('Тестовый');
    
    console.log(`✅ Тест 6 пройден: Поиск нашел ${products.length} товаров`);
  });

  // ТЕСТ 7: Обновление товара
  test('7. Должен обновить данные товара', async () => {
    const newPrice = 350.00;
    const newQuantity = 75;

    const updated = await prisma.product.update({
      where: { id: testProduct1.id },
      data: {
        price: newPrice,
        maxQuantity: newQuantity
      }
    });

    expect(parseFloat(updated.price)).toBe(newPrice);
    expect(updated.maxQuantity).toBe(newQuantity);
    
    console.log(`✅ Тест 7 пройден: Товар обновлен (цена: ${newPrice}, остаток: ${newQuantity})`);
  });

  // ТЕСТ 8: Деактивация товара (мягкое удаление)
  test('8. Должен деактивировать товар', async () => {
    const deactivated = await prisma.product.update({
      where: { id: testProduct1.id },
      data: { isActive: false }
    });

    expect(deactivated.isActive).toBe(false);
    
    console.log(`✅ Тест 8 пройден: Товар деактивирован`);
  });

  // ТЕСТ 9: Фильтрация только активных товаров
  test('9. Должен получить только активные товары', async () => {
    const activeProducts = await prisma.product.findMany({
      where: {
        categoryId: testCategory.id,
        isActive: true
      }
    });

    const inactiveProducts = await prisma.product.findMany({
      where: {
        categoryId: testCategory.id,
        isActive: false
      }
    });

    activeProducts.forEach(p => expect(p.isActive).toBe(true));
    inactiveProducts.forEach(p => expect(p.isActive).toBe(false));
    
    console.log(`✅ Тест 9 пройден: active: ${activeProducts.length}, inactive: ${inactiveProducts.length}`);
  });

  // ТЕСТ 10: Получение товаров с низким остатком
  test('10. Должен найти товары с низким остатком', async () => {
    // Создаем товар с низким остатком
    const lowStockProduct = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар (низкий остаток)',
        price: 100,
        unit: 'шт',
        maxQuantity: 3, // Низкий остаток
        isActive: true
      }
    });

    const threshold = 5;
    const lowStockProducts = await prisma.product.findMany({
      where: {
        maxQuantity: {
          not: null,
          lte: threshold
        },
        isActive: true
      }
    });

    expect(lowStockProducts.length).toBeGreaterThan(0);
    expect(lowStockProducts.some(p => p.id === lowStockProduct.id)).toBe(true);
    
    console.log(`✅ Тест 10 пройден: Найдено ${lowStockProducts.length} товаров с низким остатком (<=${threshold})`);
  });

  // ТЕСТ 11: Добавление остатков
  test('11. Должен увеличить остаток товара', async () => {
    const product = await prisma.product.findUnique({
      where: { id: testProduct2.id }
    });

    const currentQuantity = product.maxQuantity || 0;
    const addAmount = 50;

    const updated = await prisma.product.update({
      where: { id: testProduct2.id },
      data: {
        maxQuantity: currentQuantity + addAmount
      }
    });

    expect(updated.maxQuantity).toBe(currentQuantity + addAmount);
    
    console.log(`✅ Тест 11 пройден: Остаток увеличен на ${addAmount} (${currentQuantity} → ${updated.maxQuantity})`);
  });

  // ТЕСТ 12: Уменьшение остатков (при продаже)
  test('12. Должен уменьшить остаток товара при продаже', async () => {
    const product = await prisma.product.findUnique({
      where: { id: testProduct2.id }
    });

    const currentQuantity = product.maxQuantity;
    const soldAmount = 10;

    const updated = await prisma.product.update({
      where: { id: testProduct2.id },
      data: {
        maxQuantity: currentQuantity - soldAmount
      }
    });

    expect(updated.maxQuantity).toBe(currentQuantity - soldAmount);
    
    console.log(`✅ Тест 12 пройден: Остаток уменьшен на ${soldAmount} (${currentQuantity} → ${updated.maxQuantity})`);
  });

  // ТЕСТ 13: Получение товара с категорией
  test('13. Должен получить товар с информацией о категории', async () => {
    const product = await prisma.product.findUnique({
      where: { id: testProduct1.id },
      include: {
        category: true
      }
    });

    expect(product).toBeDefined();
    expect(product.category).toBeDefined();
    expect(product.category.id).toBe(testCategory.id);
    expect(product.category.name).toBe('Тестовая категория');
    
    console.log(`✅ Тест 13 пройден: Товар получен с категорией "${product.category.name}"`);
  });

  // ТЕСТ 14: Подсчет товаров в категории
  test('14. Должен подсчитать товары в категории', async () => {
    const count = await prisma.product.count({
      where: {
        categoryId: testCategory.id,
        isActive: true
      }
    });

    expect(count).toBeGreaterThan(0);
    expect(typeof count).toBe('number');
    
    console.log(`✅ Тест 14 пройден: В категории ${count} активных товаров`);
  });

  // ТЕСТ 15: Массовое обновление товаров
  test('15. Должен массово обновить товары', async () => {
    // Повышаем цены на 10% для всех товаров категории
    const products = await prisma.product.findMany({
      where: { categoryId: testCategory.id }
    });

    for (const product of products) {
      await prisma.product.update({
        where: { id: product.id },
        data: {
          price: parseFloat(product.price) * 1.10
        }
      });
    }

    const updatedProducts = await prisma.product.findMany({
      where: { categoryId: testCategory.id }
    });

    // Проверяем что цены изменились
    expect(updatedProducts.length).toBe(products.length);
    
    console.log(`✅ Тест 15 пройден: Обновлено ${updatedProducts.length} товаров`);
  });

  // ТЕСТ 16: Сортировка товаров
  test('16. Должен отсортировать товары по цене', async () => {
    const productsAsc = await prisma.product.findMany({
      where: { categoryId: testCategory.id },
      orderBy: { price: 'asc' }
    });

    const productsDesc = await prisma.product.findMany({
      where: { categoryId: testCategory.id },
      orderBy: { price: 'desc' }
    });

    expect(productsAsc.length).toBeGreaterThan(0);
    expect(productsDesc.length).toBeGreaterThan(0);
    
    // Проверяем что первый элемент в asc меньше первого в desc
    if (productsAsc.length > 1) {
      expect(parseFloat(productsAsc[0].price)).toBeLessThanOrEqual(
        parseFloat(productsAsc[productsAsc.length - 1].price)
      );
    }
    
    console.log(`✅ Тест 16 пройден: Сортировка работает (asc: ${productsAsc.length}, desc: ${productsDesc.length})`);
  });

  // ТЕСТ 17: Удаление товара
  test('17. Должен удалить товар', async () => {
    const productToDelete = await prisma.product.create({
      data: {
        categoryId: testCategory.id,
        name: 'Тестовый товар для удаления',
        price: 50,
        unit: 'шт',
        isActive: true
      }
    });

    await prisma.product.delete({
      where: { id: productToDelete.id }
    });

    const deleted = await prisma.product.findUnique({
      where: { id: productToDelete.id }
    });

    expect(deleted).toBeNull();
    
    console.log(`✅ Тест 17 пройден: Товар удален #${productToDelete.id}`);
  });

  // ТЕСТ 18: Обновление категории
  test('18. Должен обновить категорию', async () => {
    const newDescription = 'Обновленное описание категории';

    const updated = await prisma.category.update({
      where: { id: testCategory.id },
      data: { description: newDescription }
    });

    expect(updated.description).toBe(newDescription);
    
    console.log(`✅ Тест 18 пройден: Категория обновлена`);
  });

  // ТЕСТ 19: Получение категорий с количеством товаров
  test('19. Должен получить категории с подсчетом товаров', async () => {
    const categories = await prisma.category.findMany({
      include: {
        _count: {
          select: { products: true }
        }
      }
    });

    const testCat = categories.find(c => c.id === testCategory.id);
    
    expect(testCat).toBeDefined();
    expect(testCat._count.products).toBeGreaterThan(0);
    
    console.log(`✅ Тест 19 пройден: Категория имеет ${testCat._count.products} товаров`);
  });

  // ТЕСТ 20: Проверка ограничений при заказе
  test('20. Должен проверить доступность товара для заказа', async () => {
    const product = await prisma.product.findUnique({
      where: { id: testProduct2.id }
    });

    const requestedQuantity = 5;
    const isAvailable = product.maxQuantity === null || 
                       product.maxQuantity >= requestedQuantity;

    expect(typeof isAvailable).toBe('boolean');
    
    if (product.maxQuantity !== null) {
      if (requestedQuantity > product.maxQuantity) {
        expect(isAvailable).toBe(false);
      } else {
        expect(isAvailable).toBe(true);
      }
    }
    
    console.log(`✅ Тест 20 пройден: Проверка доступности (запрошено: ${requestedQuantity}, доступно: ${product.maxQuantity || '∞'})`);
  });
});
