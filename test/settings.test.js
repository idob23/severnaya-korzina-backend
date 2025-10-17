// test/settings.test.js
// Тесты для Settings API (системные настройки)

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

const { PrismaClient } = require('@prisma/client');
const { cleanDatabase } = require('./helpers/db-cleaner');

const prisma = new PrismaClient();
jest.setTimeout(30000);

describe('Settings API Tests', () => {
  
  let testSettings = [];

  // Подготовка тестовых данных
  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Settings...');

    // Удаляем тестовые настройки если существуют
    await prisma.systemSettings.deleteMany({
      where: { key: { startsWith: 'test_' } }
    });

    // ✅ Создаём базовые системные настройки для тестов
    await prisma.systemSettings.upsert({
      where: { key: 'default_margin_percent' },
      update: {},
      create: { 
        key: 'default_margin_percent', 
        value: '20', 
        description: 'Маржа по умолчанию' 
      }
    });
    
    await prisma.systemSettings.upsert({
      where: { key: 'vat_code' },
      update: {},
      create: { 
        key: 'vat_code', 
        value: '1', 
        description: 'Код НДС для фискализации' 
      }
    });
    
    await prisma.systemSettings.upsert({
      where: { key: 'payment_mode' },
      update: {},
      create: { 
        key: 'payment_mode', 
        value: 'test', 
        description: 'Режим платежей' 
      }
    });

    console.log('✅ Тестовые данные подготовлены');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка settings тестов...');
    await prisma.systemSettings.deleteMany({
      where: { key: { startsWith: 'test_' } }
    });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: Создание новой настройки
  test('1. Должен создать новую настройку', async () => {
    const setting = await prisma.systemSettings.create({
      data: {
        key: 'test_margin',
        value: '25',
        description: 'Тестовая маржа'
      }
    });

    testSettings.push(setting);

    expect(setting).toBeDefined();
    expect(setting.key).toBe('test_margin');
    expect(setting.value).toBe('25');
    
    console.log(`✅ Тест 1 пройден: Настройка создана #${setting.id}`);
  });

  // ТЕСТ 2: Получение настройки по ключу
  test('2. Должен получить настройку по ключу', async () => {
    const setting = await prisma.systemSettings.findUnique({
      where: { key: 'test_margin' }
    });

    expect(setting).toBeDefined();
    expect(setting.value).toBe('25');
    
    console.log('✅ Тест 2 пройден: Настройка получена по ключу');
  });

  // ТЕСТ 3: Обновление значения настройки
  test('3. Должен обновить значение настройки', async () => {
    const updated = await prisma.systemSettings.update({
      where: { key: 'test_margin' },
      data: { value: '30' }
    });

    expect(updated.value).toBe('30');
    
    console.log('✅ Тест 3 пройден: Значение обновлено (25 → 30)');
  });

  // ТЕСТ 4: Получение всех настроек
  test('4. Должен получить все настройки', async () => {
    const settings = await prisma.systemSettings.findMany({
      orderBy: { key: 'asc' }
    });

    expect(settings.length).toBeGreaterThan(0);
    
    console.log(`✅ Тест 4 пройден: Получено ${settings.length} настроек`);
  });

  // ТЕСТ 5: Удаление настройки
  test('5. Должен удалить настройку', async () => {
    await prisma.systemSettings.delete({
      where: { key: 'test_margin' }
    });

    const deleted = await prisma.systemSettings.findUnique({
      where: { key: 'test_margin' }
    });

    expect(deleted).toBeNull();
    
    console.log('✅ Тест 5 пройден: Настройка удалена');
  });

  // ТЕСТ 6: Создание настройки с пустым значением
  test('6. Должен создать настройку с пустым значением', async () => {
    const setting = await prisma.systemSettings.create({
      data: {
        key: 'test_empty',
        value: '',
        description: 'Пустое значение'
      }
    });

    testSettings.push(setting);

    expect(setting.value).toBe('');
    
    console.log('✅ Тест 6 пройден: Настройка с пустым значением создана');
  });

  // ТЕСТ 7: Поиск настроек по префиксу
  test('7. Должен найти настройки по префиксу "test_"', async () => {
    const settings = await prisma.systemSettings.findMany({
      where: {
        key: {
          startsWith: 'test_'
        }
      }
    });

    expect(settings.length).toBeGreaterThan(0);
    
    console.log(`✅ Тест 7 пройден: Найдено ${settings.length} тестовых настроек`);
  });

  // ТЕСТ 8: Upsert - создание или обновление
  test('8. Должен создать или обновить настройку (upsert)', async () => {
    const setting = await prisma.systemSettings.upsert({
      where: { key: 'test_upsert' },
      update: { value: 'updated' },
      create: {
        key: 'test_upsert',
        value: 'created',
        description: 'Тест upsert'
      }
    });

    testSettings.push(setting);

    expect(setting.value).toBe('created');
    
    // Повторный upsert должен обновить
    const updated = await prisma.systemSettings.upsert({
      where: { key: 'test_upsert' },
      update: { value: 'updated' },
      create: {
        key: 'test_upsert',
        value: 'created',
        description: 'Тест upsert'
      }
    });

    expect(updated.value).toBe('updated');
    
    console.log('✅ Тест 8 пройден: Upsert работает (создание → обновление)');
  });

  // ТЕСТ 9: Проверка уникальности ключа
  test('9. Должен выдать ошибку при дублировании ключа', async () => {
    await prisma.systemSettings.create({
      data: {
        key: 'test_unique',
        value: 'value1',
        description: 'Тест уникальности'
      }
    });

    testSettings.push({ key: 'test_unique' });

    await expect(
      prisma.systemSettings.create({
        data: {
          key: 'test_unique',
          value: 'value2',
          description: 'Дубликат'
        }
      })
    ).rejects.toThrow();
    
    console.log('✅ Тест 9 пройден: Дублирование ключа заблокировано');
  });

  // ТЕСТ 10: Массовое создание настроек
  test('10. Должен создать несколько настроек сразу', async () => {
    const created = await prisma.systemSettings.createMany({
      data: [
        { key: 'test_batch1', value: 'val1', description: 'Batch 1' },
        { key: 'test_batch2', value: 'val2', description: 'Batch 2' },
        { key: 'test_batch3', value: 'val3', description: 'Batch 3' }
      ]
    });

    expect(created.count).toBe(3);
    
    console.log(`✅ Тест 10 пройден: Создано ${created.count} настроек`);
  });

  // ТЕСТ 11: Обновление нескольких настроек
  test('11. Должен обновить несколько настроек', async () => {
    const updated = await prisma.systemSettings.updateMany({
      where: {
        key: {
          startsWith: 'test_batch'
        }
      },
      data: {
        value: 'updated_value'
      }
    });

    expect(updated.count).toBe(3);
    
    console.log(`✅ Тест 11 пройден: Обновлено ${updated.count} настроек`);
  });

  // ТЕСТ 12: Удаление нескольких настроек
  test('12. Должен удалить несколько настроек', async () => {
    const deleted = await prisma.systemSettings.deleteMany({
      where: {
        key: {
          startsWith: 'test_batch'
        }
      }
    });

    expect(deleted.count).toBe(3);
    
    console.log(`✅ Тест 12 пройден: Удалено ${deleted.count} настроек`);
  });

  // ТЕСТ 13: Проверка существования настройки
  test('13. Должен проверить существование настройки', async () => {
    const exists = await prisma.systemSettings.findUnique({
      where: { key: 'default_margin_percent' }
    });

    expect(exists).not.toBeNull();
    
    console.log('✅ Тест 13 пройден: Настройка default_margin_percent существует');
  });

  // ТЕСТ 14: Подсчет количества настроек
  test('14. Должен подсчитать количество настроек', async () => {
    const count = await prisma.systemSettings.count();

    expect(count).toBeGreaterThan(0);
    expect(typeof count).toBe('number');
    
    console.log(`✅ Тест 14 пройден: Всего настроек в системе = ${count}`);
  });

  // ТЕСТ 15: Фильтрация настроек по описанию
  test('15. Должен найти настройки по описанию', async () => {
    const settings = await prisma.systemSettings.findMany({
      where: {
        description: {
          contains: 'НДС',
          mode: 'insensitive'
        }
      }
    });

    expect(settings.length).toBeGreaterThan(0);
    
    console.log(`✅ Тест 15 пройден: Найдено ${settings.length} настроек с описанием "НДС"`);
  });
});
