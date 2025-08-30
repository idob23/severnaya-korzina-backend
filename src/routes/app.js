// src/routes/app.js - НОВЫЙ ФАЙЛ
const express = require('express');
const router = express.Router();

// ==========================================
// КОНФИГУРАЦИЯ ВЕРСИИ ПРИЛОЖЕНИЯ
// ==========================================
// ⚠️  ОБНОВЛЯЙТЕ ПЕРЕД КАЖДЫМ РЕЛИЗОМ!

const CURRENT_APP_CONFIG = {
  // Основная информация о версии
  version: '1.0.1',
  build_number: 2,
  release_date: '2025-08-29',
  
  // Настройки обновления
  force_update: false, // ⚠️ КРИТИЧНО: Принудительное обновление
  min_supported_version: '1.0.0', // Минимальная поддерживаемая версия
  
  // Ссылки для скачивания
  download_url: 'https://sevkorzina.ru/downloads/app-release.apk',
  website_url: 'https://sevkorzina.ru',
  
  // Changelog для пользователей
  changelog: [
    '🎯 Исправлена проблема с оплатой на iPhone Safari',
    '🚀 Значительно улучшена скорость загрузки',
    '🔧 Исправлены мелкие ошибки интерфейса',
    '📱 Оптимизирована работа на старых устройствах',
    '🔒 Повышена безопасность обработки платежей'
  ],
  
  // Дополнительная информация
  size_mb: 25, // Размер APK в мегабайтах  
  features: [
    'Улучшенные уведомления',
    'Быстрая синхронизация данных',
    'Новый дизайн экранов'
  ]
};

// ==========================================
// API ENDPOINTS
// ==========================================

/**
 * GET /api/app/version
 * Проверка доступности обновлений
 */
router.get('/version', async (req, res) => {
  try {
    const clientVersion = req.query.current_version || req.headers['app-version'];
    const userAgent = req.headers['user-agent'] || '';
    const clientIP = req.ip || 'unknown';
    
    console.log(`📱 Проверка версии - IP: ${clientIP}, Версия: ${clientVersion}, UA: ${userAgent.substring(0, 50)}...`);
    
    // Определяем, нужно ли обновление
    const needsUpdate = clientVersion ? 
      _compareVersions(clientVersion, CURRENT_APP_CONFIG.version) < 0 : true;
    
    // Проверяем, поддерживается ли версия клиента  
    const isSupported = clientVersion ? 
      _compareVersions(clientVersion, CURRENT_APP_CONFIG.min_supported_version) >= 0 : false;
    
    // Формируем ответ
    const response = {
      success: true,
      timestamp: new Date().toISOString(),
      
      // Информация о версиях
      current_version: CURRENT_APP_CONFIG.version,
      client_version: clientVersion || null,
      
      // Флаги обновления
      needs_update: needsUpdate,
      force_update: !isSupported || CURRENT_APP_CONFIG.force_update,
      is_supported: isSupported,
      
      // Полная информация о релизе
      ...CURRENT_APP_CONFIG
    };
    
    // Логируем статистику
    if (clientVersion) {
      const updateStatus = needsUpdate ? 
        (response.force_update ? '🔴 ПРИНУДИТЕЛЬНОЕ ОБНОВЛЕНИЕ' : '🟡 рекомендуется обновление') : 
        '✅ актуальная версия';
      
      console.log(`📊 Статистика: ${clientVersion} -> ${updateStatus}`);
    }
    
    res.json(response);
    
  } catch (error) {
    console.error('❌ Ошибка проверки версии:', error);
    res.status(500).json({
      success: false,
      error: 'Server error during version check',
      current_version: CURRENT_APP_CONFIG.version,
      timestamp: new Date().toISOString()
    });
  }
});

/**
 * GET /api/app/download
 * Статистика и перенаправление на скачивание APK
 */
router.get('/download', async (req, res) => {
  try {
    const userAgent = req.headers['user-agent'] || '';
    const clientIP = req.ip || 'unknown';
    const referer = req.headers['referer'] || 'direct';
    
    console.log(`📥 Скачивание APK - IP: ${clientIP}, Referer: ${referer}, UA: ${userAgent.substring(0, 50)}...`);
    
    // В будущем здесь можно добавить запись статистики в БД
    /*
    await prisma.downloadStat.create({
      data: {
        ip: clientIP,
        userAgent: userAgent,
        referer: referer,
        version: CURRENT_APP_CONFIG.version,
        timestamp: new Date()
      }
    });
    */
    
    // Перенаправляем на файл APK
    res.redirect(302, CURRENT_APP_CONFIG.download_url);
    
  } catch (error) {
    console.error('❌ Ошибка скачивания APK:', error);
    res.status(500).json({
      success: false,
      error: 'Download error',
      download_url: CURRENT_APP_CONFIG.download_url
    });
  }
});

/**
 * GET /api/app/info
 * Публичная информация о приложении
 */
router.get('/info', async (req, res) => {
  try {
    const publicInfo = {
      success: true,
      app_name: 'Северная Корзина',
      version: CURRENT_APP_CONFIG.version,
      release_date: CURRENT_APP_CONFIG.release_date,
      size_mb: CURRENT_APP_CONFIG.size_mb,
      website_url: CURRENT_APP_CONFIG.website_url,
      features: CURRENT_APP_CONFIG.features,
      changelog: CURRENT_APP_CONFIG.changelog.slice(0, 3), // Показываем только первые 3 пункта
      min_android_version: 'Android 5.0 (API 21)',
      supported_architectures: ['ARM64', 'ARM32', 'x86_64'],
      timestamp: new Date().toISOString()
    };
    
    res.json(publicInfo);
    
  } catch (error) {
    console.error('❌ Ошибка получения информации о приложении:', error);
    res.status(500).json({
      success: false,
      error: 'Server error'
    });
  }
});

// ==========================================
// УТИЛИТЫ
// ==========================================

/**
 * Сравнение версий (семантическое версионирование)
 * @param {string} version1 
 * @param {string} version2 
 * @returns {number} -1 если version1 < version2, 0 если равны, 1 если version1 > version2
 */
function _compareVersions(version1, version2) {
  if (!version1 || !version2) return 0;
  
  const v1parts = version1.split('.').map(part => parseInt(part) || 0);
  const v2parts = version2.split('.').map(part => parseInt(part) || 0);
  
  // Дополняем версии нулями до одинаковой длины
  while (v1parts.length < 3) v1parts.push(0);
  while (v2parts.length < 3) v2parts.push(0);
  
  for (let i = 0; i < Math.max(v1parts.length, v2parts.length); i++) {
    const v1part = v1parts[i] || 0;
    const v2part = v2parts[i] || 0;
    
    if (v1part < v2part) return -1;
    if (v1part > v2part) return 1;
  }
  
  return 0;
}

/**
 * Middleware для логирования запросов (опционально)
 */
router.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`🌐 ${timestamp} - ${req.method} ${req.path} - IP: ${req.ip}`);
  next();
});

module.exports = router;

// ==========================================
// ИНСТРУКЦИИ ДЛЯ РАЗРАБОТЧИКА
// ==========================================
/*
📝 КАК ОБНОВИТЬ ВЕРСИЮ:

1. Измените CURRENT_APP_CONFIG в начале файла:
   - version: новая версия (например: '1.0.2')  
   - build_number: увеличить на 1
   - release_date: текущая дата
   - changelog: список изменений
   - force_update: true для критических обновлений

2. Убедитесь, что новый APK файл загружен по пути download_url

3. Перезапустите сервер: npm restart

4. Пользователи получат уведомление об обновлении при следующем запуске

⚠️ ВАЖНО: 
- Всегда тестируйте новую версию перед включением force_update
- Следите за логами для отслеживания статистики обновлений
- Регулярно обновляйте min_supported_version для безопасности
*/
