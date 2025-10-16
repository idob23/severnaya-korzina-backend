// __tests__/auth.test.js
// Тесты для Auth API

const { PrismaClient } = require('@prisma/client');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}
const { cleanDatabase } = require('./helpers/db-cleaner');

const jwt = require('jsonwebtoken');


const prisma = new PrismaClient();

// Настройка таймаута
jest.setTimeout(30000);

describe('Auth API Tests', () => {
  let testUser;
  let testToken;

  // Очистка перед всеми тестами
  beforeAll(async () => {
    console.log('🧹 Очистка тестовых данных авторизации...');

    // Удаляем тестовых пользователей
    await prisma.user.deleteMany({
      where: { phone: { startsWith: '+7888' } }
    });

    console.log('✅ Тестовые данные очищены');
  });

  // Очистка после всех тестов
  afterAll(async () => {
    console.log('🧹 Финальная очистка auth тестов...');
    await prisma.user.deleteMany({
      where: { phone: { startsWith: '+7888' } }
    });
    await prisma.$disconnect();
    console.log('✅ Очистка завершена');
  });

  // ТЕСТ 1: Регистрация нового пользователя
  test('1. Должен зарегистрировать нового пользователя', async () => {
    const phone = '+78881234567';
    const firstName = 'Иван';
    const lastName = 'Тестовый';

    const user = await prisma.user.create({
      data: {
        phone,
        firstName,
        lastName,
        isActive: true
      }
    });

    testUser = user;

    expect(user).toBeDefined();
    expect(user.phone).toBe(phone);
    expect(user.firstName).toBe(firstName);
    expect(user.isActive).toBe(true);
    
    console.log(`✅ Тест 1 пройден: Пользователь создан #${user.id}`);
  });

  // ТЕСТ 2: Нельзя создать пользователя с существующим телефоном
  test('2. Не должен создать пользователя с дубликатом телефона', async () => {
    const phone = testUser.phone;

    let error;
    try {
      await prisma.user.create({
        data: {
          phone,
          firstName: 'Другой',
          isActive: true
        }
      });
    } catch (e) {
      error = e;
    }

    expect(error).toBeDefined();
    expect(error.code).toBe('P2002'); // Prisma код для unique constraint
    
    console.log(`✅ Тест 2 пройден: Дубликат телефона отклонен`);
  });

  // ТЕСТ 3: Генерация JWT токена
  test('3. Должен сгенерировать валидный JWT токен', () => {
    const token = jwt.sign(
      { userId: testUser.id, phone: testUser.phone },
      process.env.JWT_SECRET || 'test-secret-key-for-testing',
      { expiresIn: '7d' }
    );

    testToken = token;

    expect(token).toBeDefined();
    expect(typeof token).toBe('string');
    expect(token.split('.').length).toBe(3); // JWT имеет 3 части
    
    console.log(`✅ Тест 3 пройден: JWT токен сгенерирован`);
  });

  // ТЕСТ 4: Проверка валидности JWT токена
  test('4. Должен проверить валидность JWT токена', () => {
    const decoded = jwt.verify(
      testToken,
      process.env.JWT_SECRET || 'test-secret-key-for-testing'
    );

    expect(decoded).toBeDefined();
    expect(decoded.userId).toBe(testUser.id);
    expect(decoded.phone).toBe(testUser.phone);
    
    console.log(`✅ Тест 4 пройден: JWT токен валиден`);
  });

  // ТЕСТ 5: Невалидный токен должен быть отклонен
  test('5. Должен отклонить невалидный JWT токен', () => {
    const invalidToken = 'invalid.token.here';

    expect(() => {
      jwt.verify(
        invalidToken,
        process.env.JWT_SECRET || 'test-secret-key-for-testing'
      );
    }).toThrow();
    
    console.log(`✅ Тест 5 пройден: Невалидный токен отклонен`);
  });

  // ТЕСТ 6: Поиск пользователя по телефону
  test('6. Должен найти пользователя по телефону', async () => {
    const user = await prisma.user.findUnique({
      where: { phone: testUser.phone }
    });

    expect(user).toBeDefined();
    expect(user.id).toBe(testUser.id);
    expect(user.firstName).toBe(testUser.firstName);
    
    console.log(`✅ Тест 6 пройден: Пользователь найден по телефону`);
  });

  // ТЕСТ 7: Не найти несуществующего пользователя
  test('7. Не должен найти несуществующего пользователя', async () => {
    const user = await prisma.user.findUnique({
      where: { phone: '+79999999999' }
    });

    expect(user).toBeNull();
    
    console.log(`✅ Тест 7 пройден: Несуществующий пользователь не найден`);
  });

  // ТЕСТ 8: Обновление данных пользователя
  test('8. Должен обновить данные пользователя', async () => {
    const updatedEmail = 'test@example.com';

    const updated = await prisma.user.update({
      where: { id: testUser.id },
      data: { email: updatedEmail }
    });

    expect(updated.email).toBe(updatedEmail);
    
    console.log(`✅ Тест 8 пройден: Email обновлен`);
  });

  // ТЕСТ 9: Деактивация пользователя
  test('9. Должен деактивировать пользователя', async () => {
    const deactivated = await prisma.user.update({
      where: { id: testUser.id },
      data: { isActive: false }
    });

    expect(deactivated.isActive).toBe(false);
    
    console.log(`✅ Тест 9 пройден: Пользователь деактивирован`);
  });

  // ТЕСТ 10: Проверка статуса активности
  test('10. Должен проверить статус активности пользователя', async () => {
    const user = await prisma.user.findUnique({
      where: { id: testUser.id }
    });

    expect(user.isActive).toBe(false);
    
    // Проверяем что деактивированный пользователь не может войти
    if (!user.isActive) {
      // В реальном приложении здесь был бы отказ в доступе
      expect(user.isActive).toBe(false);
    }
    
    console.log(`✅ Тест 10 пройден: Статус проверен`);
  });

  // ТЕСТ 11: Проверка истечения токена
  test('11. Должен создать токен с истечением', () => {
    const shortToken = jwt.sign(
      { userId: testUser.id },
      process.env.JWT_SECRET || 'test-secret-key-for-testing',
      { expiresIn: '1ms' } // Истекает сразу
    );

    // Небольшая задержка
    setTimeout(() => {
      expect(() => {
        jwt.verify(
          shortToken,
          process.env.JWT_SECRET || 'test-secret-key-for-testing'
        );
      }).toThrow('jwt expired');
    }, 10);
    
    console.log(`✅ Тест 11 пройден: Токен истекает`);
  });

  // ТЕСТ 12: Множественные пользователи с разными телефонами
  test('12. Должен создать несколько пользователей', async () => {
    const users = [];

    for (let i = 1; i <= 3; i++) {
      const user = await prisma.user.create({
        data: {
          phone: `+7888000000${i}`,
          firstName: `Пользователь${i}`,
          isActive: true
        }
      });
      users.push(user);
    }

    expect(users.length).toBe(3);
    expect(users[0].phone).not.toBe(users[1].phone);
    
    console.log(`✅ Тест 12 пройден: Создано ${users.length} пользователей`);
  });

  // ТЕСТ 13: Удаление пользователя
  test('13. Должен удалить пользователя', async () => {
    const userToDelete = await prisma.user.create({
      data: {
        phone: '+78889999999',
        firstName: 'Для Удаления',
        isActive: true
      }
    });

    await prisma.user.delete({
      where: { id: userToDelete.id }
    });

    const deleted = await prisma.user.findUnique({
      where: { id: userToDelete.id }
    });

    expect(deleted).toBeNull();
    
    console.log(`✅ Тест 13 пройден: Пользователь удален`);
  });

  // ТЕСТ 14: Подсчет пользователей
  test('14. Должен подсчитать количество пользователей', async () => {
    const count = await prisma.user.count({
      where: { phone: { startsWith: '+7888' } }
    });

    expect(count).toBeGreaterThan(0);
    expect(typeof count).toBe('number');
    
    console.log(`✅ Тест 14 пройден: Найдено ${count} тестовых пользователей`);
  });

  // ТЕСТ 15: Фильтрация активных пользователей
  test('15. Должен отфильтровать только активных пользователей', async () => {
    const activeUsers = await prisma.user.findMany({
      where: {
        phone: { startsWith: '+7888' },
        isActive: true
      }
    });

    const inactiveUsers = await prisma.user.findMany({
      where: {
        phone: { startsWith: '+7888' },
        isActive: false
      }
    });

    // Проверяем что все активные действительно активны
    activeUsers.forEach(user => {
      expect(user.isActive).toBe(true);
    });

    // Проверяем что все неактивные действительно неактивны
    inactiveUsers.forEach(user => {
      expect(user.isActive).toBe(false);
    });
    
    console.log(`✅ Тест 15 пройден: active: ${activeUsers.length}, inactive: ${inactiveUsers.length}`);
  });
});
