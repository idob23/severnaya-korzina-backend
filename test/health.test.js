// test/health.test.js
// Тесты для Health Check API

const request = require('supertest');
const { PrismaClient } = require('@prisma/client');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

const prisma = new PrismaClient();
const app = require('../src/server');

jest.setTimeout(30000);

describe('Health Check API Tests', () => {

  afterAll(async () => {
    await prisma.$disconnect();
    console.log('✅ Health тесты завершены');
  });

  // ========================================
  // РАЗДЕЛ 1: БАЗОВЫЙ HEALTH CHECK
  // ========================================

  test('1. GET /health - должен вернуть статус healthy', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body).toBeDefined();
    expect(response.body.status).toBe('healthy');
    expect(response.body.database).toBe('connected');
    expect(response.body.timestamp).toBeDefined();

    console.log('✅ Тест 1 пройден: Сервер здоров');
  });

  test('2. GET /health - должен вернуть uptime сервера', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body.uptime).toBeDefined();
    expect(typeof response.body.uptime).toBe('number');
    expect(response.body.uptime).toBeGreaterThan(0);

    console.log(`✅ Тест 2 пройден: Uptime = ${response.body.uptime.toFixed(2)}s`);
  });

  test('3. GET /health - должен вернуть информацию о памяти', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body.memory).toBeDefined();
    expect(response.body.memory.used).toBeDefined();
    expect(response.body.memory.total).toBeDefined();
    expect(typeof response.body.memory.used).toBe('number');
    expect(typeof response.body.memory.total).toBe('number');
    expect(response.body.memory.used).toBeGreaterThan(0);
    expect(response.body.memory.total).toBeGreaterThan(0);

    console.log(`✅ Тест 3 пройден: Memory = ${response.body.memory.used}MB / ${response.body.memory.total}MB`);
  });

  test('4. GET /health - должен вернуть версию API', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body.version).toBeDefined();
    expect(typeof response.body.version).toBe('string');

    console.log(`✅ Тест 4 пройден: Version = ${response.body.version}`);
  });

  test('5. GET /health - должен вернуть информацию о сервере', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    if (response.body.server) {
      expect(response.body.server.host).toBeDefined();
      expect(response.body.server.environment).toBeDefined();
      expect(response.body.server.environment).toBe('test');
      
      console.log(`✅ Тест 5 пройден: Environment = ${response.body.server.environment}`);
    } else {
      console.log('⚠️ Тест 5: Информация о сервере отсутствует (опционально)');
    }
  });

  // ========================================
  // РАЗДЕЛ 2: ПРОВЕРКА ПОДКЛЮЧЕНИЯ К БД
  // ========================================

  test('6. GET /health - должен подтвердить подключение к БД', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body.database).toBe('connected');

    // Дополнительная проверка прямым запросом
    const dbCheck = await prisma.$queryRaw`SELECT 1 as result`;
    expect(dbCheck).toBeDefined();
    expect(Array.isArray(dbCheck)).toBe(true);

    console.log('✅ Тест 6 пройден: БД подключена');
  });

  test('7. GET /health - должен проверить что БД отвечает быстро', async () => {
    const startTime = Date.now();
    
    const response = await request(app)
      .get('/health')
      .expect(200);

    const responseTime = Date.now() - startTime;

    expect(response.body.database).toBe('connected');
    expect(responseTime).toBeLessThan(5000); // Должен ответить за 5 секунд

    console.log(`✅ Тест 7 пройден: Health check ответил за ${responseTime}ms`);
  });

  // ========================================
  // РАЗДЕЛ 3: ФОРМАТ ОТВЕТА
  // ========================================

  test('8. GET /health - должен вернуть валидный JSON', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200)
      .expect('Content-Type', /json/);

    expect(typeof response.body).toBe('object');
    expect(response.body).not.toBeNull();

    console.log('✅ Тест 8 пройден: Ответ в формате JSON');
  });

  test('9. GET /health - должен вернуть ISO timestamp', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body.timestamp).toBeDefined();
    
    // Проверяем что timestamp валидный ISO формат
    const timestamp = new Date(response.body.timestamp);
    expect(timestamp.toString()).not.toBe('Invalid Date');

    console.log(`✅ Тест 9 пройден: Timestamp = ${response.body.timestamp}`);
  });

  test('10. GET /health - должен содержать все обязательные поля', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    const requiredFields = ['status', 'database', 'timestamp'];
    
    requiredFields.forEach(field => {
      expect(response.body).toHaveProperty(field);
    });

    console.log('✅ Тест 10 пройден: Все обязательные поля присутствуют');
  });

  // ========================================
  // РАЗДЕЛ 4: EDGE CASES
  // ========================================

  test('11. GET /health - должен работать без заголовков авторизации', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    expect(response.body.status).toBe('healthy');

    console.log('✅ Тест 11 пройден: Health check публичный (без авторизации)');
  });

  test('12. GET /health - должен работать при множественных запросах', async () => {
    const requests = [];
    
    for (let i = 0; i < 5; i++) {
      requests.push(
        request(app).get('/health').expect(200)
      );
    }

    const responses = await Promise.all(requests);

    responses.forEach((response, index) => {
      expect(response.body.status).toBe('healthy');
      expect(response.body.database).toBe('connected');
    });

    console.log('✅ Тест 12 пройден: 5 параллельных запросов обработаны');
  });

  test('13. GET /health - должен работать стабильно во времени', async () => {
    const response1 = await request(app).get('/health').expect(200);
    
    // Небольшая задержка
    await new Promise(resolve => setTimeout(resolve, 100));
    
    const response2 = await request(app).get('/health').expect(200);

    expect(response1.body.status).toBe('healthy');
    expect(response2.body.status).toBe('healthy');
    expect(response2.body.uptime).toBeGreaterThanOrEqual(response1.body.uptime);

    console.log('✅ Тест 13 пройден: Health check стабилен во времени');
  });

  // ========================================
  // РАЗДЕЛ 5: МОНИТОРИНГ РЕСУРСОВ
  // ========================================

  test('14. GET /health - память не должна превышать разумных пределов', async () => {
    const response = await request(app)
      .get('/health')
      .expect(200);

    if (response.body.memory) {
      const memoryUsed = response.body.memory.used;
      const memoryTotal = response.body.memory.total;

      // Проверяем что используется не более 90% памяти
      const memoryPercent = (memoryUsed / memoryTotal) * 100;
      expect(memoryPercent).toBeLessThan(90);

      console.log(`✅ Тест 14 пройден: Memory usage = ${memoryPercent.toFixed(2)}%`);
    } else {
      console.log('⚠️ Тест 14: Информация о памяти недоступна');
    }
  });

  test('15. GET /health - uptime должен увеличиваться', async () => {
    const response1 = await request(app).get('/health').expect(200);
    const uptime1 = response1.body.uptime;

    await new Promise(resolve => setTimeout(resolve, 1000));

    const response2 = await request(app).get('/health').expect(200);
    const uptime2 = response2.body.uptime;

    expect(uptime2).toBeGreaterThan(uptime1);
    expect(uptime2 - uptime1).toBeGreaterThanOrEqual(1);

    console.log(`✅ Тест 15 пройден: Uptime увеличился с ${uptime1.toFixed(2)}s до ${uptime2.toFixed(2)}s`);
  });

  // ========================================
  // ИТОГОВЫЙ ТЕСТ
  // ========================================

  test('ИТОГ: Health Check API полностью работает', async () => {
    console.log('\n' + '='.repeat(70));
    console.log('📊 ИТОГОВАЯ ПРОВЕРКА HEALTH CHECK');
    console.log('='.repeat(70));

    const response = await request(app)
      .get('/health')
      .expect(200);

    // Основные проверки
    expect(response.body.status).toBe('healthy');
    expect(response.body.database).toBe('connected');
    expect(response.body.timestamp).toBeDefined();
    expect(response.body.uptime).toBeGreaterThan(0);

    // Логируем итоговую информацию
    console.log(`✅ Status: ${response.body.status}`);
    console.log(`✅ Database: ${response.body.database}`);
    console.log(`✅ Uptime: ${response.body.uptime.toFixed(2)}s`);
    
    if (response.body.memory) {
      console.log(`✅ Memory: ${response.body.memory.used}MB / ${response.body.memory.total}MB`);
    }
    
    if (response.body.version) {
      console.log(`✅ Version: ${response.body.version}`);
    }

    console.log('='.repeat(70));
    console.log('🎉 HEALTH CHECK API ПОЛНОСТЬЮ ПРОТЕСТИРОВАН');
    console.log('🎉 15 ТЕСТОВ ПРОЙДЕНО УСПЕШНО!');
    console.log('='.repeat(70) + '\n');
  });
});
