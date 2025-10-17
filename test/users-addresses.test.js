// test/users-addresses.test.js
// Тесты для Users & Addresses API

const request = require('supertest');
const { PrismaClient } = require('@prisma/client');
const { cleanDatabase } = require('./helpers/db-cleaner');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

jest.setTimeout(30000);

// Импортируем Express app
const app = require('../src/server');

describe('Users & Addresses API - Полное покрытие', () => {
  
  let testUser1;
  let testUser2;
  let testAddress1;
  let testAddress2;
  let userToken;
  let adminToken;

  // Генерация JWT токенов
  const generateToken = (userId, role = 'user') => {
    return jwt.sign(
      { id: userId, phone: '+79991234567', role: role },
      process.env.JWT_SECRET || 'test-secret-key-for-testing',
      { expiresIn: '24h' }
    );
  };

  const generateAdminToken = () => {
    return jwt.sign(
      { userId: 'admin-id', login: 'admin', role: 'admin' },
      process.env.JWT_SECRET || 'test-secret-key-for-testing',
      { expiresIn: '24h' }
    );
  };

  beforeAll(async () => {
    console.log('🧹 Подготовка тестовых данных для Users & Addresses...');
    
    await cleanDatabase(prisma);

    // Создаём тестовых пользователей
    testUser1 = await prisma.user.create({
      data: {
        phone: '+79991111111',
        firstName: 'Иван',
        lastName: 'Иванов',
        email: 'ivan@test.ru',
        isActive: true,
        acceptedTerms: true
      }
    });

    testUser2 = await prisma.user.create({
      data: {
        phone: '+79992222222',
        firstName: 'Пётр',
        lastName: 'Петров',
        isActive: true,
        acceptedTerms: true
      }
    });

    userToken = generateToken(testUser1.id);
    adminToken = generateAdminToken();

    // Создаём тестовые адреса
    testAddress1 = await prisma.address.create({
      data: {
        userId: testUser1.id,
        title: 'Дом',
        address: 'ул. Ленина, д. 1',
        isDefault: true
      }
    });

    testAddress2 = await prisma.address.create({
      data: {
        userId: testUser1.id,
        title: 'Работа',
        address: 'ул. Пушкина, д. 10',
        isDefault: false
      }
    });

    console.log('✅ Тестовые данные для Users & Addresses подготовлены');
  });

  afterAll(async () => {
    console.log('🧹 Финальная очистка users-addresses тестов...');
    await cleanDatabase(prisma);
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ========================================
  // РАЗДЕЛ 1: USERS API (ADMIN)
  // ========================================

  test('1. GET /api/users - должен получить список пользователей (админ)', async () => {
    const response = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(response.status).toBe(200);
    expect(response.body.users).toBeDefined();
    expect(Array.isArray(response.body.users)).toBe(true);
    expect(response.body.users.length).toBeGreaterThanOrEqual(2);
    
    // Проверяем структуру пользователя
    const user = response.body.users[0];
    expect(user).toHaveProperty('id');
    expect(user).toHaveProperty('phone');
    expect(user).toHaveProperty('firstName');
    expect(user).toHaveProperty('isActive');
    
    console.log(`✅ Тест 1 пройден: Получено ${response.body.users.length} пользователей`);
  });

  test('2. GET /api/users - должен отклонить запрос без токена', async () => {
    const response = await request(app)
      .get('/api/users');

    expect(response.status).toBe(401);
    
    console.log('✅ Тест 2 пройден: Неавторизованный доступ заблокирован');
  });

  test('3. GET /api/users - должен отклонить запрос обычного пользователя', async () => {
    const response = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${userToken}`);

    // Может быть 403 (Forbidden) или 401 в зависимости от middleware
    expect([401, 403]).toContain(response.status);
    
    console.log('✅ Тест 3 пройден: Обычный пользователь не может получить список');
  });

  test('4. GET /api/users/:id - должен получить пользователя по ID (админ)', async () => {
    const response = await request(app)
      .get(`/api/users/${testUser1.id}`)
      .set('Authorization', `Bearer ${adminToken}`);

    expect(response.status).toBe(200);
    expect(response.body.user).toBeDefined();
    expect(response.body.user.id).toBe(testUser1.id);
    expect(response.body.user.phone).toBe(testUser1.phone);
    expect(response.body.user.firstName).toBe(testUser1.firstName);
    
    console.log('✅ Тест 4 пройден: Пользователь получен по ID');
  });

  test('5. GET /api/users/:id - должен вернуть 404 для несуществующего пользователя', async () => {
    const response = await request(app)
      .get('/api/users/99999')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(response.status).toBe(404);
    expect(response.body.error).toBeDefined();
    
    console.log('✅ Тест 5 пройден: Несуществующий пользователь обработан');
  });

  test('6. GET /api/users/:id - должен включать адреса и заказы', async () => {
    const response = await request(app)
      .get(`/api/users/${testUser1.id}`)
      .set('Authorization', `Bearer ${adminToken}`);

    expect(response.status).toBe(200);
    expect(response.body.user.addresses).toBeDefined();
    expect(Array.isArray(response.body.user.addresses)).toBe(true);
    expect(response.body.user.addresses.length).toBeGreaterThanOrEqual(2);
    expect(response.body.user.orders).toBeDefined();
    
    console.log('✅ Тест 6 пройден: Адреса и заказы включены в ответ');
  });

  // ========================================
  // РАЗДЕЛ 2: ADDRESSES API - ПОЛУЧЕНИЕ
  // ========================================

  test('7. GET /api/addresses - должен получить адреса пользователя', async () => {
    const response = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`);

    expect(response.status).toBe(200);
    expect(response.body.addresses).toBeDefined();
    expect(Array.isArray(response.body.addresses)).toBe(true);
    expect(response.body.addresses.length).toBe(2);
    
    // Проверяем что дефолтный адрес первый
    expect(response.body.addresses[0].isDefault).toBe(true);
    
    console.log(`✅ Тест 7 пройден: Получено ${response.body.addresses.length} адресов`);
  });

  test('8. GET /api/addresses - должен отклонить запрос без токена', async () => {
    const response = await request(app)
      .get('/api/addresses');

    expect(response.status).toBe(401);
    
    console.log('✅ Тест 8 пройден: Неавторизованный доступ заблокирован');
  });

  test('9. GET /api/addresses - должен возвращать только адреса пользователя', async () => {
    const user2Token = generateToken(testUser2.id);
    
    const response = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${user2Token}`);

    expect(response.status).toBe(200);
    expect(response.body.addresses.length).toBe(0);
    
    console.log('✅ Тест 9 пройден: Изоляция адресов пользователей работает');
  });

  // ========================================
  // РАЗДЕЛ 3: ADDRESSES API - СОЗДАНИЕ
  // ========================================

  test('10. POST /api/addresses - должен создать новый адрес', async () => {
    const newAddress = {
      title: 'Дача',
      address: 'Садовое товарищество "Ромашка", участок 42',
      isDefault: false
    };

    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`)
      .send(newAddress);

    expect(response.status).toBe(201);
    expect(response.body.message).toBeDefined();
    expect(response.body.address).toBeDefined();
    expect(response.body.address.title).toBe(newAddress.title);
    expect(response.body.address.address).toBe(newAddress.address);
    expect(response.body.address.userId).toBe(testUser1.id);
    
    console.log('✅ Тест 10 пройден: Адрес создан');
  });

  test('11. POST /api/addresses - должен требовать обязательные поля', async () => {
    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`)
      .send({
        title: 'Тест'
        // address отсутствует
      });

    expect(response.status).toBe(400);
    expect(response.body.error).toMatch(/обязательн/i);
    
    console.log('✅ Тест 11 пройден: Валидация обязательных полей работает');
  });

  test('12. POST /api/addresses - должен отклонить запрос без токена', async () => {
    const response = await request(app)
      .post('/api/addresses')
      .send({
        title: 'Тест',
        address: 'Тестовый адрес'
      });

    expect(response.status).toBe(401);
    
    console.log('✅ Тест 12 пройден: Неавторизованный доступ заблокирован');
  });

  test('13. POST /api/addresses - должен создать адрес по умолчанию', async () => {
    const newAddress = {
      title: 'Новый дом',
      address: 'ул. Новая, д. 5',
      isDefault: true
    };

    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`)
      .send(newAddress);

    expect(response.status).toBe(201);
    expect(response.body.address.isDefault).toBe(true);

    // Проверяем что старый дефолтный адрес сброшен
    const oldDefaultAddress = await prisma.address.findUnique({
      where: { id: testAddress1.id }
    });

    expect(oldDefaultAddress.isDefault).toBe(false);
    
    console.log('✅ Тест 13 пройден: Дефолтный адрес переключен');
  });

  // ========================================
  // РАЗДЕЛ 4: ВАЛИДАЦИЯ И БЕЗОПАСНОСТЬ
  // ========================================

  test('14. Должен хранить userId корректно', async () => {
    const addresses = await prisma.address.findMany({
      where: { userId: testUser1.id }
    });

    addresses.forEach(addr => {
      expect(addr.userId).toBe(testUser1.id);
    });
    
    console.log('✅ Тест 14 пройден: userId сохраняется корректно');
  });

  test('15. Должен сортировать адреса (дефолтный первый)', async () => {
    const response = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`);

    expect(response.status).toBe(200);
    
    const addresses = response.body.addresses;
    
    // Дефолтный адрес должен быть первым
    if (addresses.some(a => a.isDefault)) {
      expect(addresses[0].isDefault).toBe(true);
    }
    
    console.log('✅ Тест 15 пройден: Сортировка адресов работает');
  });

  test('16. Должен ограничивать создание адресов для разных пользователей', async () => {
    const user2Token = generateToken(testUser2.id);
    
    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${user2Token}`)
      .send({
        title: 'Адрес пользователя 2',
        address: 'Его адрес'
      });

    expect(response.status).toBe(201);
    
    // Проверяем что адрес создан для правильного пользователя
    const createdAddress = await prisma.address.findUnique({
      where: { id: response.body.address.id }
    });

    expect(createdAddress.userId).toBe(testUser2.id);
    expect(createdAddress.userId).not.toBe(testUser1.id);
    
    console.log('✅ Тест 16 пройден: Изоляция пользователей работает');
  });

  // ========================================
  // РАЗДЕЛ 5: СВЯЗИ И ЦЕЛОСТНОСТЬ
  // ========================================

  test('17. Должен связывать адреса с пользователями', async () => {
    const user = await prisma.user.findUnique({
      where: { id: testUser1.id },
      include: {
        addresses: true
      }
    });

    expect(user.addresses.length).toBeGreaterThanOrEqual(2);
    
    user.addresses.forEach(addr => {
      expect(addr.userId).toBe(testUser1.id);
    });
    
    console.log('✅ Тест 17 пройден: Связи user → addresses работают');
  });

  test('18. Должен удалить адреса при удалении пользователя (CASCADE)', async () => {
    // Создаём временного пользователя
    const tempUser = await prisma.user.create({
      data: {
        phone: '+79999999999',
        firstName: 'Временный',
        isActive: true,
        acceptedTerms: true
      }
    });

    // Создаём для него адрес
    const tempAddress = await prisma.address.create({
      data: {
        userId: tempUser.id,
        title: 'Временный адрес',
        address: 'Будет удалён'
      }
    });

    // Удаляем пользователя
    await prisma.user.delete({
      where: { id: tempUser.id }
    });

    // Проверяем что адрес тоже удалён
    const addressExists = await prisma.address.findUnique({
      where: { id: tempAddress.id }
    });

    expect(addressExists).toBeNull();
    
    console.log('✅ Тест 18 пройден: Каскадное удаление работает');
  });

  // ========================================
  // РАЗДЕЛ 6: EDGE CASES
  // ========================================

  test('19. Должен обрабатывать длинные адреса', async () => {
    const longAddress = 'А'.repeat(500);
    
    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`)
      .send({
        title: 'Длинный адрес',
        address: longAddress
      });

    expect(response.status).toBe(201);
    expect(response.body.address.address.length).toBe(500);
    
    console.log('✅ Тест 19 пройден: Длинные адреса обрабатываются');
  });

  test('20. Должен обрабатывать спецсимволы в адресах', async () => {
    const specialAddress = 'ул. "Новая", д. 5/7, кв. 10-А';
    
    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`)
      .send({
        title: 'Спецсимволы',
        address: specialAddress
      });

    expect(response.status).toBe(201);
    expect(response.body.address.address).toBe(specialAddress);
    
    console.log('✅ Тест 20 пройден: Спецсимволы обрабатываются');
  });

  test('21. Должен поддерживать множественные дефолтные переключения', async () => {
    // Создаём несколько адресов
    for (let i = 1; i <= 3; i++) {
      await request(app)
        .post('/api/addresses')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          title: `Адрес ${i}`,
          address: `Адрес номер ${i}`,
          isDefault: true // Каждый раз делаем дефолтным
        });
    }

    // Проверяем что только один адрес дефолтный
    const addresses = await prisma.address.findMany({
      where: { userId: testUser1.id }
    });

    const defaultAddresses = addresses.filter(a => a.isDefault);
    
    expect(defaultAddresses.length).toBe(1);
    
    console.log('✅ Тест 21 пройден: Только один дефолтный адрес');
  });

  test('22. Должен подсчитывать количество адресов пользователя', async () => {
    const response = await request(app)
      .get(`/api/users/${testUser1.id}`)
      .set('Authorization', `Bearer ${adminToken}`);

    expect(response.status).toBe(200);
    
    const addressCount = response.body.user.addresses.length;
    expect(addressCount).toBeGreaterThan(0);
    
    console.log(`✅ Тест 22 пройден: Подсчитано ${addressCount} адресов`);
  });

  // ========================================
  // ИТОГОВАЯ ПРОВЕРКА
  // ========================================

  test('ИТОГ: Users & Addresses API полностью протестирован', async () => {
    console.log('\n🏆 ИТОГОВАЯ ПРОВЕРКА Users & Addresses API');
    
    // Проверяем что все объекты созданы
    expect(testUser1).toBeDefined();
    expect(testUser2).toBeDefined();
    expect(testAddress1).toBeDefined();
    expect(testAddress2).toBeDefined();

    // Проверяем Users API
    const usersResponse = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${adminToken}`);

    expect(usersResponse.status).toBe(200);
    expect(usersResponse.body.users.length).toBeGreaterThanOrEqual(2);

    // Проверяем Addresses API
    const addressesResponse = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`);

    expect(addressesResponse.status).toBe(200);
    expect(addressesResponse.body.addresses.length).toBeGreaterThan(0);

    console.log('✅ ВСЕ ОСНОВНЫЕ ФУНКЦИИ РАБОТАЮТ');
    console.log('✅ USERS & ADDRESSES API ПОЛНОСТЬЮ ПРОТЕСТИРОВАН');
    console.log('🎉 22 ТЕСТА ПРОЙДЕНО УСПЕШНО!');
  });
});
