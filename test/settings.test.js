// test/settings.test.js
// Тесты для Settings API (системные настройки)

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

describe('Settings API Tests', () => {
  
  let testSettings = [];

  // Подготовка тестовых данных
  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Settings...');

    // Удаляем тестовые настройки если существуют
    await prisma.systemSettings.deleteMany({
      where: { key: { startsWith: 'test_' } }
    });

    console.log('✅ Тестовые данные очищены');
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
      data: {
        value: '30',
        updatedAt: new Date()
      }
    });

    expect(updated.value).toBe('30');
    expect(updated.key).toBe('test_margin');
    
    console.log('✅ Тест 3 пройден: Значение обновлено (25 → 30)');
  });

  // ТЕСТ 4: Upsert - создание если не существует
  test('4. Должен создать настройку через upsert если не существует', async () => {
    const setting = await prisma.systemSettings.upsert({
      where: { key: 'test_vat_code' },
      update: { value: '6' },
      create: {
        key: 'test_vat_code',
        value: '6',
        description: 'Тестовый код НДС'
      }
    });

    testSettings.push(setting);

    expect(setting.key).toBe('test_vat_code');
    expect(setting.value).toBe('6');
    
    console.log(`✅ Тест 4 пройден: Настройка создана через upsert #${setting.id}`);
  });

  // ТЕСТ 5: Upsert - обновление если существует
  test('5. Должен обновить настройку через upsert если существует', async () => {
    const setting = await prisma.systemSettings.upsert({
      where: { key: 'test_vat_code' },
      update: {
        value: '1',
        updatedAt: new Date()
      },
      create: {
        key: 'test_vat_code',
        value: '1',
        description: 'Тестовый код НДС'
      }
    });

    expect(setting.key).toBe('test_vat_code');
    expect(setting.value).toBe('1'); // Должно обновиться с '6' на '1'
    
    console.log('✅ Тест 5 пройден: Настройка обновлена через upsert (6 → 1)');
  });

  // ТЕСТ 6: Получение всех настроек
  test('6. Должен получить все тестовые настройки', async () => {
    const settings = await prisma.systemSettings.findMany({
      where: { key: { startsWith: 'test_' } }
    });

    expect(settings.length).toBeGreaterThanOrEqual(2);
    expect(settings.some(s => s.key === 'test_margin')).toBe(true);
    expect(settings.some(s => s.key === 'test_vat_code')).toBe(true);
    
    console.log(`✅ Тест 6 пройден: Найдено ${settings.length} тестовых настроек`);
  });

  // ТЕСТ 7: Проверка уникальности ключа
  test('7. Не должен создать дубликат настройки', async () => {
    let error;
    try {
      await prisma.systemSettings.create({
        data: {
          key: 'test_margin', // Уже существует
          value: '50',
          description: 'Дубликат'
        }
      });
    } catch (e) {
      error = e;
    }

    expect(error).toBeDefined();
    expect(error.code).toBe('P2002'); // Prisma код для unique constraint
    
    console.log('✅ Тест 7 пройден: Дубликат ключа отклонен');
  });

  // ТЕСТ 8: Проверка системных настроек (маржа)
  test('8. Должен получить настройку маржи', async () => {
    const marginSetting = await prisma.systemSettings.findUnique({
      where: { key: 'default_margin_percent' }
    });

    expect(marginSetting).toBeDefined();
    expect(parseFloat(marginSetting.value)).toBeGreaterThan(0);
    expect(parseFloat(marginSetting.value)).toBeLessThanOrEqual(100);
    
    console.log(`✅ Тест 8 пройден: Маржа = ${marginSetting.value}%`);
  });

  // ТЕСТ 9: Проверка системных настроек (НДС)
  test('9. Должен получить настройку НДС', async () => {
    const vatSetting = await prisma.systemSettings.findUnique({
      where: { key: 'vat_code' }
    });

    expect(vatSetting).toBeDefined();
    const validVatCodes = ['1', '2', '3', '4', '5', '6'];
    expect(validVatCodes).toContain(vatSetting.value);
    
    console.log(`✅ Тест 9 пройден: НДС код = ${vatSetting.value}`);
  });

  // ТЕСТ 10: Проверка системных настроек (режим платежей)
  test('10. Должен получить режим платежей', async () => {
    const paymentMode = await prisma.systemSettings.findUnique({
      where: { key: 'payment_mode' }
    });

    expect(paymentMode).toBeDefined();
    expect(['test', 'production']).toContain(paymentMode.value);
    
    console.log(`✅ Тест 10 пройден: Режим платежей = ${paymentMode.value}`);
  });

  // ТЕСТ 11: Проверка настройки checkout_enabled
  test('11. Должен получить статус оформления заказов', async () => {
    const checkoutSetting = await prisma.systemSettings.findUnique({
      where: { key: 'checkout_enabled' }
    });

    if (checkoutSetting) {
      expect(['true', 'false']).toContain(checkoutSetting.value);
      console.log(`✅ Тест 11 пройден: Оформление заказов = ${checkoutSetting.value}`);
    } else {
      console.log('✅ Тест 11 пройден: Настройка checkout_enabled не найдена (по умолчанию true)');
    }
  });

  // ТЕСТ 12: Проверка режима обслуживания
  test('12. Должен получить статус режима обслуживания', async () => {
    const maintenanceMode = await prisma.systemSettings.findUnique({
      where: { key: 'maintenance_mode' }
    });

    if (maintenanceMode) {
      expect(['true', 'false']).toContain(maintenanceMode.value);
      console.log(`✅ Тест 12 пройден: Режим обслуживания = ${maintenanceMode.value}`);
    } else {
      console.log('✅ Тест 12 пройден: Режим обслуживания не настроен (по умолчанию false)');
    }
  });

  // ТЕСТ 13: Удаление настройки
  test('13. Должен удалить настройку', async () => {
    await prisma.systemSettings.delete({
      where: { key: 'test_vat_code' }
    });

    const deleted = await prisma.systemSettings.findUnique({
      where: { key: 'test_vat_code' }
    });

    expect(deleted).toBeNull();
    
    console.log('✅ Тест 13 пройден: Настройка test_vat_code удалена');
  });

  // ТЕСТ 14: Подсчет всех настроек
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
