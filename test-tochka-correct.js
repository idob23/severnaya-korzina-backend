// test-tochka-correct.js
// Тест с правильным базовым URL из документации

const axios = require('axios');

const JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3NWJmNzBiZTIxYmFlNzdlODBmMmYxYjFjNmMwYmViOSIsInN1YiI6ImY1ZjE1NDNjLTU0NjEtNGJkMS1hOTc5LWQ0ZWQxODUxOGZiNiIsImN1c3RvbWVyX2NvZGUiOiIzMDUyNTA2MjYifQ.L3b9c_R6fQh5KBbM-GqM1kV8PEDunwsgTX09xxBkUl2M5Nm0XgP1FaMfTKcFNO6FFPLQXu_mkbLxzGIGww1PNAz0TGMKyPaM2QUKu83ituy4wSYYgz9R5pjewdMiSV3tnzjL9vKB9RqhMmNozoiqusCaav1Xg3THeFBXqKKqqLwK71NVEPayqE_OJ6fYR5xowgYmkPG1niBdGOWviYkpOkAAAMN9OyTZqHuvmG4BvfNLQmPhL0muk3qLFcKECNZESLRr-t2HoufTEsfzdZoydZPKqa-M4wmxrvx1AC8PG0p6-oUYL0NxxVT1yb3iK1wp2WxgORxdTDceQ3MSqI4Iy41qT886eKuo4PquoRK6-Rfz0dBFSLYEHOflRD1uorWaq1qcIo8T3DddEaq_ukOwdOvMowoZR_AWYPqwBQVJJ-MNrF_rCH7oWOoZjmR1PyRsCja8KeQyKuWrIIPZdp83KgviOOtkZE2KCzYfrlYuo4hRe2aZD83iT5AGIumJW-HD';

// Правильный базовый URL из документации
const BASE_URL = 'https://enter.tochka.com/uapi';

async function makeRequest(method, endpoint, data = null) {
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
    
    if (data) {
      config.data = data;
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
      error: error.response?.data || error.message,
      errorCode: error.response?.data?.errorCode
    };
  }
}

async function main() {
  console.log('=====================================');
  console.log('ТЕСТ API ТОЧКА БАНК');
  console.log('=====================================\n');
  console.log('Базовый URL:', BASE_URL);
  console.log('Токен:', JWT_TOKEN.substring(0, 50) + '...\n');
  
  // 1. Тест получения счетов (чтобы проверить что токен работает)
  console.log('📍 Тест 1: Получение списка счетов');
  console.log('GET /open-banking/v1.0/accounts\n');
  
  let result = await makeRequest('GET', '/open-banking/v1.0/accounts');
  
  if (result.success) {
    console.log('✅ УСПЕХ! Токен работает');
    console.log('Счета:', JSON.stringify(result.data, null, 2).substring(0, 500));
  } else {
    console.log('❌ Ошибка:', result.status);
    console.log('Детали:', result.error);
  }
  
  console.log('\n----------------------------------------\n');
  
  // 2. Тест получения торговых точек для эквайринга
  console.log('📍 Тест 2: Получение торговых точек (retailers)');
  console.log('GET /acquiring/v2.0/retailers\n');
  
  result = await makeRequest('GET', '/acquiring/v2.0/retailers');
  
  if (result.success) {
    console.log('✅ УСПЕХ! Найдены торговые точки');
    console.log('Данные:', JSON.stringify(result.data, null, 2));
    
    if (Array.isArray(result.data) && result.data.length > 0) {
      const merchantId = result.data[0].id || result.data[0].merchantId;
      console.log(`\n🎯 ВАЖНО: merchantId = ${merchantId}`);
      console.log('Используйте этот ID для создания платежей!');
      return merchantId;
    }
  } else {
    console.log('❌ Ошибка:', result.status);
    
    if (result.status === 404) {
      console.log('\nПробуем альтернативные endpoints...');
      
      // Альтернативные варианты
      const alternatives = [
        '/acquiring/v1.0/retailers',
        '/acquiring/api/v2.0/retailers',
        '/merchant/v1.0/list'
      ];
      
      for (const alt of alternatives) {
        console.log(`\nПробуем: GET ${alt}`);
        const altResult = await makeRequest('GET', alt);
        if (altResult.success) {
          console.log('✅ Работает!');
          console.log('Данные:', JSON.stringify(altResult.data, null, 2));
          break;
        } else {
          console.log(`❌ ${altResult.status}`);
        }
      }
    }
  }
  
  console.log('\n----------------------------------------\n');
  
  // 3. Тест создания платежной ссылки (если есть merchantId)
  console.log('📍 Тест 3: Проверка endpoint для создания платежа');
  console.log('POST /acquiring/v2.0/payments\n');
  
  // Минимальные данные для теста
  const paymentData = {
    amount: "100.00",
    currency: "RUB", 
    purpose: "Тестовый платеж",
    merchantId: "test" // Заглушка для теста endpoint
  };
  
  result = await makeRequest('POST', '/acquiring/v2.0/payments', paymentData);
  
  if (result.success) {
    console.log('✅ Endpoint работает!');
    console.log('Ответ:', JSON.stringify(result.data, null, 2));
  } else {
    console.log('Статус:', result.status);
    if (result.errorCode) {
      console.log('Код ошибки:', result.errorCode);
    }
    console.log('Детали:', JSON.stringify(result.error, null, 2));
    
    if (result.status === 400) {
      console.log('\n✅ Хорошие новости! Endpoint существует.');
      console.log('Ошибка 400 означает что нужны корректные данные.');
      console.log('Например, правильный merchantId.');
    }
  }
  
  console.log('\n=====================================');
  console.log('ИТОГИ:');
  console.log('=====================================');
  console.log('1. Базовый URL: https://enter.tochka.com/uapi');
  console.log('2. Токен: ' + (result.status !== 401 ? '✅ Работает' : '❌ Проблема с авторизацией'));
  console.log('3. Следующий шаг: получить merchantId из личного кабинета');
  console.log('=====================================\n');
}

main();

/*
ЗАПУСК:
node test-tochka-correct.js
*/
