// test-tochka-fixed.js
// Исправленная версия - правильно извлекает merchantId

const axios = require('axios');

const JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3NWJmNzBiZTIxYmFlNzdlODBmMmYxYjFjNmMwYmViOSIsInN1YiI6ImY1ZjE1NDNjLTU0NjEtNGJkMS1hOTc5LWQ0ZWQxODUxOGZiNiIsImN1c3RvbWVyX2NvZGUiOiIzMDUyNTA2MjYifQ.L3b9c_R6fQh5KBbM-GqM1kV8PEDunwsgTX09xxBkUl2M5Nm0XgP1FaMfTKcFNO6FFPLQXu_mkbLxzGIGww1PNAz0TGMKyPaM2QUKu83ituy4wSYYgz9R5pjewdMiSV3tnzjL9vKB9RqhMmNozoiqusCaav1Xg3THeFBXqKKqqLwK71NVEPayqE_OJ6fYR5xowgYmkPG1niBdGOWviYkpOkAAAMN9OyTZqHuvmG4BvfNLQmPhL0muk3qLFcKECNZESLRr-t2HoufTEsfzdZoydZPKqa-M4wmxrvx1AC8PG0p6-oUYL0NxxVT1yb3iK1wp2WxgORxdTDceQ3MSqI4Iy41qT886eKuo4PquoRK6-Rfz0dBFSLYEHOflRD1uorWaq1qcIo8T3DddEaq_ukOwdOvMowoZR_AWYPqwBQVJJ-MNrF_rCH7oWOoZjmR1PyRsCja8KeQyKuWrIIPZdp83KgviOOtkZE2KCzYfrlYuo4hRe2aZD83iT5AGIumJW-HD';

const BASE_URL = 'https://enter.tochka.com/uapi';

// ВАШИ ПРАВИЛЬНЫЕ ДАННЫЕ ИЗ API:
const CUSTOMER_CODE = '305236529';  // Правильный код!
const MERCHANT_ID = '200000000026552';  // Правильный 15-значный ID!

async function makeRequest(method, endpoint, data = null, params = null) {
  try {
    const config = {
      method,
      url: `${BASE_URL}${endpoint}`,
      headers: {
        'Authorization': `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      timeout: 10000
    };
    
    if (data) config.data = data;
    if (params) config.params = params;
    
    console.log(`\n🔄 ${method} ${endpoint}`);
    if (data) {
      console.log('📤 Отправляем:');
      console.log(JSON.stringify(data, null, 2));
    }
    
    const response = await axios(config);
    return { 
      success: true, 
      data: response.data, 
      status: response.status 
    };
  } catch (error) {
    return { 
      success: false, 
      status: error.response?.status,
      error: error.response?.data || error.message
    };
  }
}

async function createRealPayment(amount, orderId) {
  console.log('=====================================');
  console.log('СОЗДАНИЕ РЕАЛЬНОГО ПЛАТЕЖА');
  console.log('=====================================\n');
  console.log(`Customer Code: ${CUSTOMER_CODE}`);
  console.log(`Merchant ID: ${MERCHANT_ID}`);
  console.log(`Сумма: ${amount} руб`);
  console.log(`Заказ: #${orderId}\n`);
  
  const paymentData = {
    Data: {
      // Обязательные поля
      customerCode: CUSTOMER_CODE,
      merchantId: MERCHANT_ID,
      amount: amount.toFixed(2),
      purpose: `Оплата заказа №${orderId}`,
      
      // Способы оплаты
      paymentMode: ["card", "sbp"],
      
      // URL для редиректа
      redirectUrl: `https://app.sevkorzina.ru/#/payment-success?orderId=${orderId}`,
      failRedirectUrl: "https://app.sevkorzina.ru/#/payment-failed",
      
      // Опциональные поля
      ttl: 60,  // срок жизни ссылки 60 минут
      saveCard: false,
      preAuthorization: false
    }
  };
  
  const result = await makeRequest('POST', '/acquiring/v1.0/payments', paymentData);
  
  if (result.success) {
    console.log('\n✅ ПЛАТЕЖНАЯ ССЫЛКА СОЗДАНА!');
    console.log('=====================================');
    
    const responseData = result.data?.Data || result.data;
    
    console.log(`🌐 ССЫЛКА ДЛЯ ОПЛАТЫ:`);
    console.log(`   ${responseData.paymentLink}`);
    console.log('');
    console.log(`📝 ID операции: ${responseData.operationId}`);
    console.log(`📊 Статус: ${responseData.status}`);
    console.log(`💰 Сумма: ${responseData.amount} руб`);
    
    console.log('\n=====================================');
    console.log('ДАННЫЕ ДЛЯ .env:');
    console.log('=====================================');
    console.log('# Точка банк');
    console.log('TOCHKA_API_URL=https://enter.tochka.com/uapi');
    console.log('TOCHKA_JWT_TOKEN=' + JWT_TOKEN.substring(0, 50) + '...');
    console.log(`TOCHKA_CUSTOMER_CODE=${CUSTOMER_CODE}`);
    console.log(`TOCHKA_MERCHANT_ID=${MERCHANT_ID}`);
    console.log('=====================================\n');
    
    return {
      success: true,
      paymentLink: responseData.paymentLink,
      operationId: responseData.operationId
    };
    
  } else {
    console.log('❌ Ошибка создания платежа');
    console.log('Статус:', result.status);
    
    if (result.error?.Errors) {
      console.log('\nОшибки:');
      result.error.Errors.forEach(err => {
        console.log(`- ${err.message}`);
      });
    }
    
    return { success: false };
  }
}

// Главная функция
async function main() {
  // Создаем тестовый платеж на 100 руб
  await createRealPayment(100.00, 'TEST_001');
}

// Запускаем
main();

/*
ИСПОЛЬЗОВАНИЕ:

1. Для тестового платежа:
   node test-tochka-fixed.js

2. Для создания платежа из вашего кода:
   const { createRealPayment } = require('./test-tochka-fixed');
   const result = await createRealPayment(1000.00, 'ORDER_123');
   if (result.success) {
     console.log('Ссылка:', result.paymentLink);
   }
*/
