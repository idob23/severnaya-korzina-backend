// setup-tochka-webhook.js - Настройка вебхука в Точка Банк
// Запуск: node setup-tochka-webhook.js

require('dotenv').config();
const axios = require('axios');

const API_URL = process.env.TOCHKA_API_URL || 'https://enter.tochka.com/uapi';
const JWT_TOKEN = process.env.TOCHKA_JWT_TOKEN;
const WEBHOOK_URL = 'https://app.sevkorzina.ru/api/payments/webhook';

async function listWebhooks() {
  console.log('📋 Проверяем существующие вебхуки...\n');
  
  try {
    const response = await axios.get(`${API_URL}/webhook/v1.0/list`, {
      headers: {
        'Authorization': `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json'
      }
    });

    console.log('✅ Текущие вебхуки:');
    console.log(JSON.stringify(response.data, null, 2));
    
    return response.data;
  } catch (error) {
    console.error('❌ Ошибка получения списка вебхуков:');
    if (error.response) {
      console.error('Статус:', error.response.status);
      console.error('Данные:', JSON.stringify(error.response.data, null, 2));
    } else {
      console.error(error.message);
    }
    return null;
  }
}

async function createWebhook() {
  console.log('\n🔧 Создаём новый вебхук...\n');
  console.log(`URL: ${WEBHOOK_URL}`);
  console.log(`Event: acquiringInternetPayment\n`);
  
  try {
    const response = await axios.post(
      `${API_URL}/webhook/v1.0/create`,
      {
        Data: {
          url: WEBHOOK_URL,
          events: ['acquiringInternetPayment']
        }
      },
      {
        headers: {
          'Authorization': `Bearer ${JWT_TOKEN}`,
          'Content-Type': 'application/json'
        }
      }
    );

    console.log('✅ Вебхук успешно создан!');
    console.log(JSON.stringify(response.data, null, 2));
    
    return response.data;
  } catch (error) {
    console.error('❌ Ошибка создания вебхука:');
    if (error.response) {
      console.error('Статус:', error.response.status);
      console.error('Данные:', JSON.stringify(error.response.data, null, 2));
      
      // Если вебхук уже существует - это нормально
      if (error.response.status === 400 && 
          error.response.data?.Errors?.some(e => e.message?.includes('already exists'))) {
        console.log('\n⚠️ Вебхук уже существует - это нормально!');
        return { alreadyExists: true };
      }
    } else {
      console.error(error.message);
    }
    return null;
  }
}

async function deleteWebhook(webhookId) {
  console.log(`\n🗑️ Удаляем вебхук ${webhookId}...\n`);
  
  try {
    const response = await axios.delete(
      `${API_URL}/webhook/v1.0/delete`,
      {
        headers: {
          'Authorization': `Bearer ${JWT_TOKEN}`,
          'Content-Type': 'application/json'
        },
        data: {
          Data: {
            id: webhookId
          }
        }
      }
    );

    console.log('✅ Вебхук удалён!');
    console.log(JSON.stringify(response.data, null, 2));
    
    return response.data;
  } catch (error) {
    console.error('❌ Ошибка удаления вебхука:');
    if (error.response) {
      console.error('Статус:', error.response.status);
      console.error('Данные:', JSON.stringify(error.response.data, null, 2));
    } else {
      console.error(error.message);
    }
    return null;
  }
}

async function testWebhook() {
  console.log('\n🧪 Тестируем вебхук локально...\n');
  
  // Отправляем тестовый webhook на локальный сервер
  const testData = {
    event: 'acquiringInternetPayment',
    data: {
      operationId: 'TEST_WEBHOOK_' + Date.now(),
      status: 'APPROVED',
      amount: 100.00,
      currency: 'RUB',
      createdAt: new Date().toISOString(),
      paidAt: new Date().toISOString(),
      metadata: {
        test: true
      }
    }
  };
  
  try {
    const response = await axios.post(WEBHOOK_URL, testData, {
      headers: {
        'Content-Type': 'application/json'
      },
      timeout: 5000
    });
    
    console.log('✅ Тестовый вебхук отправлен успешно!');
    console.log('Ответ сервера:', response.data);
  } catch (error) {
    if (error.code === 'ECONNREFUSED') {
      console.error('❌ Сервер недоступен. Убедитесь, что backend запущен на порту 3000');
    } else {
      console.error('❌ Ошибка отправки тестового вебхука:', error.message);
    }
  }
}

async function main() {
  console.log('=====================================');
  console.log('🔧 НАСТРОЙКА ВЕБХУКА ТОЧКА БАНК');
  console.log('=====================================\n');

  if (!JWT_TOKEN) {
    console.error('❌ JWT токен не найден в .env!');
    console.log('Добавьте TOCHKA_JWT_TOKEN в файл .env');
    process.exit(1);
  }

  console.log(`API URL: ${API_URL}`);
  console.log(`Webhook URL: ${WEBHOOK_URL}\n`);

  // Получаем аргументы командной строки
  const action = process.argv[2];

  switch (action) {
    case 'list':
      await listWebhooks();
      break;
      
    case 'create':
      await createWebhook();
      break;
      
    case 'delete':
      const webhookId = process.argv[3];
      if (!webhookId) {
        console.error('❌ Укажите ID вебхука для удаления');
        console.log('Использование: node setup-tochka-webhook.js delete <webhook_id>');
        process.exit(1);
      }
      await deleteWebhook(webhookId);
      break;
      
    case 'test':
      await testWebhook();
      break;
      
    default:
      // По умолчанию - полная настройка
      console.log('🔄 ПОЛНАЯ НАСТРОЙКА (list → create)\n');
      
      // 1. Проверяем существующие вебхуки
      await listWebhooks();
      
      // 2. Создаём новый вебхук
      await createWebhook();
      
      // 3. Проверяем результат
      console.log('\n📋 Финальная проверка вебхуков:');
      await listWebhooks();
      
      console.log('\n=====================================');
      console.log('✅ НАСТРОЙКА ЗАВЕРШЕНА');
      console.log('=====================================\n');
      console.log('💡 Доступные команды:');
      console.log('   node setup-tochka-webhook.js list   - список вебхуков');
      console.log('   node setup-tochka-webhook.js create - создать вебхук');
      console.log('   node setup-tochka-webhook.js delete <id> - удалить вебхук');
      console.log('   node setup-tochka-webhook.js test   - тест локального вебхука\n');
  }
}

// Запуск
main().then(() => {
  console.log('\n✅ Готово!');
  process.exit(0);
}).catch(err => {
  console.error('\n❌ Критическая ошибка:', err.message);
  process.exit(1);
});
