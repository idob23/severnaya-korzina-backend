// test-tochka.js - Тест интеграции Точка Банк
// Запуск: node test-tochka.js

require('dotenv').config();
const TochkaPaymentService = require('./src/services/tochkaPaymentService');

async function testTochkaIntegration() {
  console.log('🧪 Тестирование интеграции Точка Банк...\n');

  const tochka = new TochkaPaymentService();

  // Проверка конфигурации
  console.log('📋 Конфигурация:');
  console.log('   API URL:', tochka.apiUrl);
  console.log('   Customer Code:', tochka.customerCode);
  console.log('   Merchant ID:', tochka.merchantId);
  console.log('   Terminal ID:', tochka.terminalId);
  console.log('   JWT Token:', tochka.jwtToken ? '✅ Установлен' : '❌ Отсутствует');
  console.log('');

  if (!tochka.jwtToken) {
    console.error('❌ JWT токен не найден в переменных окружения!');
    console.log('Добавьте TOCHKA_JWT_TOKEN в файл .env');
    return;
  }

  try {
    // Тест 1: Создание платежа
    console.log('🧪 Тест 1: Создание тестового платежа');
    console.log('━'.repeat(50));
    
    const testPayment = await tochka.createPayment({
      amount: 100,
      orderId: 'TEST_' + Date.now(),
      userId: 1,
      batchId: null,
      marginPercent: 20,
      vatCode: 6,
      customerPhone: '79999999999'
    });

    console.log('✅ Платеж создан успешно!');
    console.log('   Payment ID:', testPayment.paymentId);
    console.log('   Status:', testPayment.status);
    console.log('   Payment Link:', testPayment.confirmationUrl);
    console.log('   Breakdown:');
    console.log('     - Товары:', testPayment.breakdown.goods, '₽');
    console.log('     - Услуга:', testPayment.breakdown.service, '₽');
    console.log('     - Итого:', testPayment.breakdown.total, '₽');
    console.log('');

    // Тест 2: Проверка статуса
    console.log('🧪 Тест 2: Проверка статуса платежа');
    console.log('━'.repeat(50));
    
    // Небольшая задержка, чтобы платеж успел зарегистрироваться в системе
    console.log('⏳ Ожидание 2 секунды...');
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    const status = await tochka.checkPaymentStatus(testPayment.paymentId);
    
    console.log('✅ Статус получен!');
    console.log('   Payment ID:', status.paymentId);
    console.log('   Status:', status.status);
    console.log('   Is Paid:', status.isPaid);
    console.log('   Is Pending:', status.isPending);
    console.log('   Amount:', status.amount, '₽');
    console.log('');

    console.log('━'.repeat(50));
    console.log('✅ ВСЕ ТЕСТЫ ПРОЙДЕНЫ УСПЕШНО!');
    console.log('');
    console.log('🔗 Тестовая ссылка для оплаты:');
    console.log(testPayment.confirmationUrl);
    console.log('');
    console.log('💡 Вы можете открыть эту ссылку в браузере для тестовой оплаты');

  } catch (error) {
    console.error('❌ ОШИБКА:', error.message);
    
    if (error.response) {
      console.error('   API Response:', JSON.stringify(error.response.data, null, 2));
    }
    
    console.log('');
    console.log('💡 Возможные причины:');
    console.log('   1. Неверный JWT токен');
    console.log('   2. Истек срок действия токена');
    console.log('   3. Неверные параметры merchantId или customerCode');
    console.log('   4. Проблемы с сетью');
  }
}

// Запуск теста
testTochkaIntegration().then(() => {
  console.log('Тест завершен');
  process.exit(0);
}).catch(err => {
  console.error('Критическая ошибка:', err);
  process.exit(1);
});
