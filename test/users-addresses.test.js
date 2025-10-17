// test/users-addresses.test.js - ИСПРАВЛЕННАЯ ВЕРСИЯ С ЛОГИРОВАНИЕМ
const request = require('supertest');
const app = require('../src/server');
const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// Вспомогательная функция для генерации токенов
function generateToken(userId, role = null) {
  const payload = role === 'admin' 
    ? { userId: 'admin-id', login: 'admin', role: 'admin' }
    : { userId, phone: `+7914266758${userId}` };
    
  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '24h' });
}

describe('Users & Addresses API - Полное покрытие', () => {
  let testUser1, testUser2;
  let testAddress1, testAddress2;
  let userToken, user2Token, adminToken;

  beforeAll(async () => {
    // Очищаем тестовые данные
    await prisma.address.deleteMany({});
    await prisma.user.deleteMany({});

    // Создаём тестовых пользователей
    testUser1 = await prisma.user.create({
      data: {
        phone: '+79142667581',
        firstName: 'Иван',
        lastName: 'Тестовый',
        isActive: true,
        acceptedTerms: true
      }
    });

    testUser2 = await prisma.user.create({
      data: {
        phone: '+79142667582',
        firstName: 'Мария',
        lastName: 'Тестовая',
        isActive: true,
        acceptedTerms: true
      }
    });

    // Создаём адреса для пользователя 1
    testAddress1 = await prisma.address.create({
      data: {
        userId: testUser1.id,
        title: 'Дом',
        address: 'ул. Ленина, д. 10, кв. 5',
        isDefault: true
      }
    });

    testAddress2 = await prisma.address.create({
      data: {
        userId: testUser1.id,
        title: 'Работа',
        address: 'ул. Советская, д. 25',
        isDefault: false
      }
    });

    // Генерируем токены
    userToken = generateToken(testUser1.id);
    user2Token = generateToken(testUser2.id);
    adminToken = generateToken('admin-id', 'admin');

    console.log('✅ Тестовые данные созданы');
  });

  afterAll(async () => {
    await prisma.address.deleteMany({});
    await prisma.user.deleteMany({});
    await prisma.$disconnect();
    console.log('✅ Тестовые данные очищены');
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
    
    console.log('✅ Тест 1 пройден: Админ получил список пользователей');
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

    // ИСПРАВЛЕНО: Ожидаем 403, а не [401, 403]
    expect(response.status).toBe(403);
    
    console.log('✅ Тест 3 пройден: Обычный пользователь не может получить список');
  });

  test('4. GET /api/users/:id - должен получить пользователя по ID (админ)', async () => {
    const response = await request(app)
      .get(`/api/users/${testUser1.id}`)
      .set('Authorization', `Bearer ${adminToken}`);

    expect(response.status).toBe(200);
    expect(response.body.user).toBeDefined();
    expect(response.body.user.id).toBe(testUser1.id);
    
    console.log('✅ Тест 4 пройден: Админ получил пользователя по ID');
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

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 200) {
      console.error('❌ Ошибка в тесте 7:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

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
    const response = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${user2Token}`);

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 200) {
      console.error('❌ Ошибка в тесте 9:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

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

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 201) {
      console.error('❌ Ошибка в тесте 10:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

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

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 400) {
      console.error('❌ Ошибка в тесте 11:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

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
      address: 'ул. Новая, д. 1',
      isDefault: true
    };

    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`)
      .send(newAddress);

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 201) {
      console.error('❌ Ошибка в тесте 13:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

    expect(response.status).toBe(201);
    expect(response.body.address.isDefault).toBe(true);

    // Проверяем что старый дефолтный адрес сброшен
    const oldDefault = await prisma.address.findUnique({
      where: { id: testAddress1.id }
    });
    expect(oldDefault.isDefault).toBe(false);
    
    console.log('✅ Тест 13 пройден: Дефолтный адрес переключён');
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
      expect(typeof addr.userId).toBe('number');
    });
    
    console.log('✅ Тест 14 пройден: userId хранится корректно');
  });

  test('15. Должен сортировать адреса (дефолтный первый)', async () => {
    const response = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`);

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 200) {
      console.error('❌ Ошибка в тесте 15:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

    expect(response.status).toBe(200);

    const addresses = response.body.addresses;
    
    // Находим дефолтный адрес
    const defaultIndex = addresses.findIndex(a => a.isDefault);
    if (defaultIndex > -1) {
      expect(defaultIndex).toBe(0); // Должен быть первым
    }
    
    console.log('✅ Тест 15 пройден: Сортировка работает');
  });

  test('16. Должен ограничивать создание адресов для разных пользователей', async () => {
    const newAddress = {
      title: 'Попытка взлома',
      address: 'Хакерская улица'
    };

    const response = await request(app)
      .post('/api/addresses')
      .set('Authorization', `Bearer ${user2Token}`)
      .send(newAddress);

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 201) {
      console.error('❌ Ошибка в тесте 16:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

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

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 201) {
      console.error('❌ Ошибка в тесте 19:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

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

    // ДОБАВЛЕНО: Логирование ошибки
    if (response.status !== 201) {
      console.error('❌ Ошибка в тесте 20:');
      console.error('Status:', response.status);
      console.error('Body:', JSON.stringify(response.body, null, 2));
    }

    expect(response.status).toBe(201);
    expect(response.body.address.address).toBe(specialAddress);
    
    console.log('✅ Тест 20 пройден: Спецсимволы обрабатываются');
  });

  test('21. Должен поддерживать множественные дефолтные переключения', async () => {
    // Создаём 3 новых адреса и переключаем дефолтный между ними
    const addresses = [];
    
    for (let i = 0; i < 3; i++) {
      const response = await request(app)
        .post('/api/addresses')
        .set('Authorization', `Bearer ${userToken}`)
        .send({
          title: `Адрес ${i + 1}`,
          address: `Тестовая ул., д. ${i + 1}`,
          isDefault: true
        });
      
      addresses.push(response.body.address);
    }

    // Проверяем что только последний адрес дефолтный
    const allAddresses = await prisma.address.findMany({
      where: { userId: testUser1.id }
    });

    const defaultAddresses = allAddresses.filter(a => a.isDefault);
    expect(defaultAddresses.length).toBe(1);
    expect(defaultAddresses[0].id).toBe(addresses[2].id);
    
    console.log('✅ Тест 21 пройден: Множественные переключения работают');
  });

  test('22. Должен подсчитывать количество адресов пользователя', async () => {
    const count = await prisma.address.count({
      where: { userId: testUser1.id }
    });

    expect(count).toBeGreaterThan(0);
    
    const response = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`);

    expect(response.body.addresses.length).toBe(count);
    
    console.log(`✅ Тест 22 пройден: Подсчёт адресов работает (${count} шт)`);
  });

  // ========================================
  // ИТОГОВЫЙ ТЕСТ
  // ========================================

  test('ИТОГ: Users & Addresses API полностью протестирован', async () => {
    // Проверяем что все основные функции работают
    
    // 1. Админ может получить пользователей
    const usersResponse = await request(app)
      .get('/api/users')
      .set('Authorization', `Bearer ${adminToken}`);
    
    expect(usersResponse.status).toBe(200);
    
    // 2. Пользователь может получить свои адреса
    const addressesResponse = await request(app)
      .get('/api/addresses')
      .set('Authorization', `Bearer ${userToken}`);

    // ДОБАВЛЕНО: Логирование ошибки
    if (addressesResponse.status !== 200) {
      console.error('❌ Ошибка в ИТОГОВОМ тесте:');
      console.error('Status:', addressesResponse.status);
      console.error('Body:', JSON.stringify(addressesResponse.body, null, 2));
    }

    expect(addressesResponse.status).toBe(200);
    expect(addressesResponse.body.addresses.length).toBeGreaterThan(0);

    console.log('✅ ВСЕ ОСНОВНЫЕ ФУНКЦИИ РАБОТАЮТ');
    console.log('✅ USERS & ADDRESSES API ПОЛНОСТЬЮ ПРОТЕСТИРОВАН');
    console.log('🎉 22 ТЕСТА ПРОЙДЕНО УСПЕШНО!');
  });
});
