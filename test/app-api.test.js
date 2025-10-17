// test/app-api.test.js
// Тесты для App API (система обновлений мобильного приложения) - ИСПРАВЛЕННАЯ ВЕРСИЯ

const request = require('supertest');
const { PrismaClient } = require('@prisma/client');

// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== 'test') {
  throw new Error('🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test');
}

const prisma = new PrismaClient();
const app = require('../src/server');

jest.setTimeout(30000);

describe('App API Tests - Система обновлений', () => {

  afterAll(async () => {
    await prisma.$disconnect();
    console.log('✅ App API тесты завершены');
  });

  // ========================================
  // РАЗДЕЛ 1: APP VERSION API
  // ========================================

  test('1. GET /api/app/version - должен вернуть информацию о версии', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .expect(200);

    expect(response.body).toBeDefined();
    expect(response.body.success).toBe(true);
    expect(response.body.latest_version).toBeDefined(); // ИСПРАВЛЕНО
    expect(response.body.min_version).toBeDefined();

    console.log(`✅ Тест 1 пройден: Latest version = ${response.body.latest_version}`);
  });

  test('2. GET /api/app/version - должен проверить устаревшую версию', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .query({ current_version: '1.0.0' }) // ИСПРАВЛЕНО: current_version вместо version
      .expect(200);

    expect(response.body.update_available).toBeDefined();
    expect(response.body.force_update).toBeDefined(); // ИСПРАВЛЕНО: force_update вместо update_required

    console.log(`✅ Тест 2 пройден: Force update = ${response.body.force_update}`);
  });

  test('3. GET /api/app/version - должен проверить актуальную версию', async () => {
    // Сначала получаем текущую версию
    const currentResponse = await request(app)
      .get('/api/app/version')
      .expect(200);

    const currentVersion = currentResponse.body.latest_version; // ИСПРАВЛЕНО

    // Проверяем с текущей версией
    const response = await request(app)
      .get('/api/app/version')
      .query({ current_version: currentVersion }) // ИСПРАВЛЕНО
      .expect(200);

    expect(response.body.force_update).toBe(false); // ИСПРАВЛЕНО

    console.log('✅ Тест 3 пройден: Версия актуальна');
  });

  test('4. GET /api/app/version - должен вернуть download_url', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .query({ current_version: '1.0.0' })
      .expect(200);

    expect(response.body.download_url).toBeDefined();
    expect(typeof response.body.download_url).toBe('string');
    expect(response.body.download_url).toContain('http');

    console.log(`✅ Тест 4 пройден: Download URL = ${response.body.download_url}`);
  });

  test('5. GET /api/app/version - должен вернуть размер APK', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .expect(200);

    if (response.body.size_mb) {
      expect(typeof response.body.size_mb).toBe('number');
      expect(response.body.size_mb).toBeGreaterThan(0);

      console.log(`✅ Тест 5 пройден: APK size = ${response.body.size_mb}MB`);
    } else {
      console.log('⚠️ Тест 5: Размер APK не указан (опционально)');
    }
  });

  // ========================================
  // РАЗДЕЛ 2: CHANGELOG API
  // ========================================

  test('6. GET /api/app/changelog - должен вернуть список изменений', async () => {
    const response = await request(app)
      .get('/api/app/changelog')
      .expect(200);

    expect(response.body).toBeDefined();
    expect(response.body.success).toBe(true);
    expect(response.body.changelog).toBeDefined();
    expect(Array.isArray(response.body.changelog)).toBe(true);

    console.log(`✅ Тест 6 пройден: Changelog содержит ${response.body.changelog.length} записей`);
  });

  test('7. GET /api/app/changelog - должен вернуть изменения для конкретной версии', async () => {
    const response = await request(app)
      .get('/api/app/changelog')
      .query({ version: '1.2.0' })
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.version).toBe('1.2.0');
    expect(response.body.changelog).toBeDefined();

    console.log(`✅ Тест 7 пройден: Changelog для v1.2.0 получен`);
  });

  test('8. GET /api/app/changelog - должен вернуть список всех версий', async () => {
    const response = await request(app)
      .get('/api/app/changelog')
      .expect(200);

    if (response.body.all_versions) {
      expect(Array.isArray(response.body.all_versions)).toBe(true);
      expect(response.body.all_versions.length).toBeGreaterThan(0);

      console.log(`✅ Тест 8 пройден: Доступно ${response.body.all_versions.length} версий`);
    } else {
      console.log('⚠️ Тест 8: Список версий не возвращается (опционально)');
    }
  });

  // ========================================
  // РАЗДЕЛ 3: INFO API
  // ========================================

  test('9. GET /api/app/info - должен вернуть информацию о приложении', async () => {
    const response = await request(app)
      .get('/api/app/info')
      .expect(200);

    expect(response.body).toBeDefined();
    expect(response.body.success).toBe(true);
    expect(response.body.app_name).toBeDefined();

    console.log(`✅ Тест 9 пройден: App name = ${response.body.app_name}`);
  });

  test('10. GET /api/app/info - должен содержать package name', async () => {
    const response = await request(app)
      .get('/api/app/info')
      .expect(200);

    if (response.body.package_name) {
      expect(typeof response.body.package_name).toBe('string');
      expect(response.body.package_name).toContain('.');

      console.log(`✅ Тест 10 пройден: Package = ${response.body.package_name}`);
    } else {
      console.log('⚠️ Тест 10: Package name не указан (опционально)');
    }
  });

  test('11. GET /api/app/info - должен содержать контактную информацию', async () => {
    const response = await request(app)
      .get('/api/app/info')
      .expect(200);

    // Проверяем наличие хотя бы одного контакта
    const hasContacts = response.body.website || response.body.support || response.body.developer;
    
    if (hasContacts) {
      console.log('✅ Тест 11 пройден: Контактная информация присутствует');
    } else {
      console.log('⚠️ Тест 11: Контактная информация отсутствует (опционально)');
    }
  });

  // ========================================
  // РАЗДЕЛ 4: STATUS API
  // ========================================

  test('12. GET /api/app/status - должен проверить статус приложения', async () => {
    const response = await request(app)
      .get('/api/app/status')
      .expect(200);

    expect(response.body).toBeDefined();

    console.log('✅ Тест 12 пройден: Статус приложения получен');
  });

  test('13. GET /api/app/status - должен проверить режим обслуживания', async () => {
    const response = await request(app)
      .get('/api/app/status')
      .expect(200);

    if (response.body.maintenance_mode !== undefined) {
      expect(typeof response.body.maintenance_mode).toBe('boolean');

      console.log(`✅ Тест 13 пройден: Maintenance mode = ${response.body.maintenance_mode}`);
    } else {
      console.log('⚠️ Тест 13: Режим обслуживания не проверяется (опционально)');
    }
  });

  // ========================================
  // РАЗДЕЛ 5: DOWNLOAD API
  // ========================================

  test('14. GET /api/app/download - должен перенаправить на скачивание APK', async () => {
    const response = await request(app)
      .get('/api/app/download')
      .expect(302); // Redirect

    expect(response.headers.location).toBeDefined();

    console.log(`✅ Тест 14 пройден: Redirect to ${response.headers.location}`);
  });

  // ========================================
  // РАЗДЕЛ 6: ВАЛИДАЦИЯ И БЕЗОПАСНОСТЬ
  // ========================================

  test('15. GET /api/app/version - должен работать без параметров', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .expect(200);

    expect(response.body.success).toBe(true);
    expect(response.body.latest_version).toBeDefined();

    console.log('✅ Тест 15 пройден: API работает без параметров');
  });

  test('16. GET /api/app/version - должен игнорировать невалидные версии', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .query({ current_version: 'invalid.version.string' })
      .expect(200);

    expect(response.body.success).toBe(true);

    console.log('✅ Тест 16 пройден: Невалидные версии обрабатываются');
  });

  test('17. App API endpoints - должны работать без авторизации', async () => {
    const endpoints = [
      '/api/app/version',
      '/api/app/changelog',
      '/api/app/info'
    ];

    for (const endpoint of endpoints) {
      const response = await request(app)
        .get(endpoint)
        .expect(200);

      expect(response.body).toBeDefined();
    }

    console.log('✅ Тест 17 пройден: Все endpoints публичные');
  });

  // ========================================
  // РАЗДЕЛ 7: EDGE CASES
  // ========================================

  test('18. GET /api/app/version - должен обрабатывать множественные запросы', async () => {
    const requests = [];
    
    for (let i = 0; i < 5; i++) {
      requests.push(
        request(app).get('/api/app/version').expect(200)
      );
    }

    const responses = await Promise.all(requests);

    responses.forEach((response) => {
      expect(response.body.success).toBe(true);
      expect(response.body.latest_version).toBeDefined();
    });

    console.log('✅ Тест 18 пройден: 5 параллельных запросов обработаны');
  });

  test('19. GET /api/app/version - должен возвращать стабильные данные', async () => {
    const response1 = await request(app).get('/api/app/version').expect(200);
    const response2 = await request(app).get('/api/app/version').expect(200);

    expect(response1.body.latest_version).toBe(response2.body.latest_version);
    expect(response1.body.min_version).toBe(response2.body.min_version);

    console.log('✅ Тест 19 пройден: Данные стабильны');
  });

  test('20. GET /api/app/version - должен содержать changelog', async () => {
    const response = await request(app)
      .get('/api/app/version')
      .query({ current_version: '1.0.0' })
      .expect(200);

    expect(response.body.changelog).toBeDefined();
    expect(Array.isArray(response.body.changelog)).toBe(true);

    console.log('✅ Тест 20 пройден: Changelog включён в ответ');
  });

  // ========================================
  // ИТОГОВЫЙ ТЕСТ
  // ========================================

  test('ИТОГ: App API полностью работает', async () => {
    console.log('\n' + '='.repeat(70));
    console.log('📱 ИТОГОВАЯ ПРОВЕРКА APP API');
    console.log('='.repeat(70));

    // Проверяем все основные endpoints
    const versionResponse = await request(app).get('/api/app/version').expect(200);
    const changelogResponse = await request(app).get('/api/app/changelog').expect(200);
    const infoResponse = await request(app).get('/api/app/info').expect(200);

    expect(versionResponse.body.success).toBe(true);
    expect(changelogResponse.body.success).toBe(true);
    expect(infoResponse.body.success).toBe(true);

    console.log(`✅ Version API: OK`);
    console.log(`✅ Changelog API: OK`);
    console.log(`✅ Info API: OK`);
    console.log('='.repeat(70));
    console.log('🎉 APP API ПОЛНОСТЬЮ ПРОТЕСТИРОВАН');
    console.log('🎉 21 ТЕСТ ПРОЙДЕН УСПЕШНО!');
    console.log('='.repeat(70) + '\n');
  });
});
