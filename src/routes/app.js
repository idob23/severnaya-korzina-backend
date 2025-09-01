// src/routes/app.js
// API endpoints для системы обновлений мобильного приложения

const express = require('express');
const router = express.Router();
const path = require('path');

// ==========================================
// КОНФИГУРАЦИЯ ПРИЛОЖЕНИЯ
// ==========================================

// Здесь храним информацию о текущей версии
// При выпуске новой версии просто обновляем эти значения
const CURRENT_APP_CONFIG = {
  // Версия приложения (должна совпадать с version в pubspec.yaml)
  version: '1.2.7',
  
  // Минимальная поддерживаемая версия (для принудительного обновления)
  min_version: '1.0.0',
  
  // URL для скачивания APK (можете использовать свой домен)
download_url: 'http://84.201.149.245:3000/downloads/severnaya-korzina-1.2.7.apk',
  
  // Альтернативный вариант - локальный путь (будет редирект)
    // download_url: 'https://sevkorzina.ru/downloads/severnaya-korzina-1.2.0.apk',
  
  // Размер файла в МБ (для отображения пользователю)
  size_mb: 48.9,
  
  // Дата релиза
  release_date: '2025-09-1',
  
  // Список изменений
  changelog: [
    '🎉 Новые функции:',
    '• Добавлена возможность отслеживания доставки',
    '• Улучшен интерфейс корзины',
    '',
    '🐛 Исправления:',
    '• Исправлена ошибка при оплате картой',
    '• Улучшена стабильность приложения',
    '',
    '⚡ Улучшения:',
    '• Ускорена загрузка каталога',
    '• Оптимизирован размер приложения'
  ],
  
  // Дополнительные параметры
  features: {
    // Можно ли отложить обновление
    can_skip: true,
    
    // Через сколько дней напомнить снова (если отложили)
    remind_later_days: 3,
    
    // Показывать ли changelog
    show_changelog: true
  },
  
  // URL для дополнительной информации
  website_url: 'https://sevkorzina.ru',
  support_url: 'https://sevkorzina.ru/support'
};

// ==========================================
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ==========================================

/**
 * Сравнение версий (semantic versioning)
 * Возвращает: -1 если v1 < v2, 0 если равны, 1 если v1 > v2
 */
function compareVersions(v1, v2) {
  const parts1 = v1.split('.').map(Number);
  const parts2 = v2.split('.').map(Number);
  
  for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
    const part1 = parts1[i] || 0;
    const part2 = parts2[i] || 0;
    
    if (part1 > part2) return 1;
    if (part1 < part2) return -1;
  }
  
  return 0;
}

/**
 * Определяет, требуется ли принудительное обновление
 */
function isForceUpdateRequired(clientVersion) {
  return compareVersions(clientVersion, CURRENT_APP_CONFIG.min_version) < 0;
}

/**
 * Определяет, доступна ли новая версия
 */
function isUpdateAvailable(clientVersion) {
  return compareVersions(CURRENT_APP_CONFIG.version, clientVersion) > 0;
}

// ==========================================
// API ENDPOINTS
// ==========================================

/**
 * GET /api/app/version
 * Проверка доступности новой версии приложения
 * 
 * Query params:
 * - current_version: текущая версия приложения на устройстве
 * - platform: платформа (android/ios) - опционально
 */
router.get('/version', async (req, res) => {
  try {
    const { current_version, platform = 'android' } = req.query;
    
    // Логируем запрос для статистики
    console.log(`📱 Version check: ${current_version} (${platform})`);
    
    // Если версия не передана, возвращаем текущую конфигурацию
    if (!current_version) {
      return res.json({
        success: true,
        latest_version: CURRENT_APP_CONFIG.version,
        min_version: CURRENT_APP_CONFIG.min_version,
        message: 'Please provide current_version parameter'
      });
    }
    
    // Проверяем, нужно ли обновление
    const updateAvailable = isUpdateAvailable(current_version);
    const forceUpdate = isForceUpdateRequired(current_version);
    
    // Формируем ответ
    const response = {
      success: true,
      update_available: updateAvailable,
      force_update: forceUpdate,
      latest_version: CURRENT_APP_CONFIG.version,
      min_version: CURRENT_APP_CONFIG.min_version,
      current_version: current_version,
      download_url: CURRENT_APP_CONFIG.download_url,
      size_mb: CURRENT_APP_CONFIG.size_mb,
      release_date: CURRENT_APP_CONFIG.release_date,
      changelog: CURRENT_APP_CONFIG.changelog,
      features: CURRENT_APP_CONFIG.features,
      website_url: CURRENT_APP_CONFIG.website_url,
      support_url: CURRENT_APP_CONFIG.support_url
    };
    
    // Добавляем сообщение для пользователя
    if (forceUpdate) {
      response.message = 'Критическое обновление! Пожалуйста, обновите приложение для продолжения работы.';
    } else if (updateAvailable) {
      response.message = 'Доступна новая версия приложения с улучшениями и исправлениями.';
    } else {
      response.message = 'У вас установлена последняя версия приложения.';
    }
    
    res.json(response);
    
  } catch (error) {
    console.error('❌ Ошибка проверки версии:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка при проверке версии',
      message: 'Попробуйте позже'
    });
  }
});

/**
 * GET /api/app/download
 * Перенаправление на скачивание APK файла
 * Можно использовать для подсчета статистики скачиваний
 */
router.get('/download', async (req, res) => {
  try {
    const { version = CURRENT_APP_CONFIG.version } = req.query;
    
    // Логируем скачивание для статистики
    const userAgent = req.headers['user-agent'] || 'unknown';
    const ip = req.ip || req.connection.remoteAddress;
    console.log(`📥 APK download: v${version} from ${ip} (${userAgent.substring(0, 50)}...)`);
    
    // Здесь можно добавить сохранение статистики в БД, если нужно
    // await saveDownloadStats({ version, ip, userAgent, timestamp: new Date() });
    
    // Перенаправляем на реальный файл
    res.redirect(CURRENT_APP_CONFIG.download_url);
    
  } catch (error) {
    console.error('❌ Ошибка скачивания:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка при скачивании',
      message: 'Попробуйте скачать напрямую',
      direct_url: CURRENT_APP_CONFIG.download_url
    });
  }
});

/**
 * GET /api/app/changelog
 * Получение списка изменений для конкретной версии или всех версий
 */
router.get('/changelog', async (req, res) => {
  try {
    const { version = CURRENT_APP_CONFIG.version } = req.query;
    
    // Здесь можно хранить историю изменений для разных версий
    const changelogs = {
      '1.2.0': CURRENT_APP_CONFIG.changelog,
      '1.1.0': [
        '• Добавлена корзина покупок',
        '• Исправлены ошибки авторизации',
        '• Улучшена производительность'
      ],
      '1.0.0': [
        '• Первый релиз приложения',
        '• Базовый функционал каталога',
        '• Оформление заказов'
      ]
    };
    
    res.json({
      success: true,
      version: version,
      changelog: changelogs[version] || ['Информация о версии недоступна'],
      all_versions: Object.keys(changelogs).sort(compareVersions).reverse()
    });
    
  } catch (error) {
    console.error('❌ Ошибка получения changelog:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка при получении списка изменений'
    });
  }
});

/**
 * GET /api/app/info
 * Общая информация о приложении (для страницы "О приложении")
 */
router.get('/info', async (req, res) => {
  try {
    res.json({
      success: true,
      app_name: 'Северная Корзина',
      package_name: 'com.severnaya.korzina',
      current_version: CURRENT_APP_CONFIG.version,
      min_supported_version: CURRENT_APP_CONFIG.min_version,
      release_date: CURRENT_APP_CONFIG.release_date,
      size_mb: CURRENT_APP_CONFIG.size_mb,
      developer: 'Северная Корзина Team',
      website: CURRENT_APP_CONFIG.website_url,
      support: CURRENT_APP_CONFIG.support_url,
      description: 'Платформа коллективных закупок для жителей Усть-Неры'
    });
    
  } catch (error) {
    console.error('❌ Ошибка получения информации:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка при получении информации'
    });
  }
});

// ==========================================
// СТАТИСТИКА (опционально)
// ==========================================

/**
 * GET /api/app/stats
 * Статистика по версиям приложения (для админки)
 * Требует авторизации администратора
 */
router.get('/stats', async (req, res) => {
  try {
    // Здесь должна быть проверка прав администратора
    // if (!req.user || !req.user.isAdmin) {
    //   return res.status(403).json({ error: 'Доступ запрещен' });
    // }
    
    // Пример статистики (в реальности брать из БД)
    const stats = {
      total_downloads: 0,
      downloads_today: 0,
      active_versions: {
        '1.2.0': 0,
        '1.1.0': 0,
        '1.0.0': 0
      },
      platforms: {
        android: 0,
        ios: 0
      }
    };
    
    res.json({
      success: true,
      stats: stats,
      current_version: CURRENT_APP_CONFIG.version,
      last_update: CURRENT_APP_CONFIG.release_date
    });
    
  } catch (error) {
    console.error('❌ Ошибка получения статистики:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка при получении статистики'
    });
  }
});

module.exports = router;
