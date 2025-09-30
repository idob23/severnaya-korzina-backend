// test-get-merchants.js
// Получаем список торговых точек чтобы найти правильный merchantId

const axios = require('axios');

const JWT_TOKEN = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3NWJmNzBiZTIxYmFlNzdlODBmMmYxYjFjNmMwYmViOSIsInN1YiI6ImY1ZjE1NDNjLTU0NjEtNGJkMS1hOTk5LWQ0ZWQxODUxOGZiNiIsImN1c3RvbWVyX2NvZGUiOiIzMDUyNTA2MjYifQ.L3b9c_R6fQh5KBbM-GqM1kV8PEDunwsgTX09xxBkUl2M5Nm0XgP1FaMfTKcFNO6FFPLQXu_mkbLxzGIGww1PNAz0TGMKyPaM2QUKu83ituy4wSYYgz9R5pjewdMiSV3tnzjL9vKB9RqhMmNozoiqusCaav1Xg3THeFBXqKKqqLwK71NVEPayqE_OJ6fYR5xowgYmkPG1niBdGOWviYkpOkAAAMN9OyTZqHuvmG4BvfNLQmPhL0muk3qLFcKECNZESLRr-t2HoufTEsfzdZoydZPKqa-M4wmxrvx1AC8PG0p6-oUYL0NxxVT1yb3iK1wp2WxgORxdTDceQ3MSqI4Iy41qT886eKuo4PquoRK6-Rfz0dBFSLYEHOflRD1uorWaq1qcIo8T3DddEaq_ukOwdOvMowoZR_AWYPqwBQVJJ-MNrF_rCH7oWOoZjmR1PyRsCja8KeQyKuWrIIPZdp83KgviOOtkZE2KCzYfrlYuo4hRe2aZD83iT5AGIumJW-HD';

const BASE_URL = 'https://enter.tochka.com/uapi';
const CUSTOMER_CODE = '305250626';
const CLIENT_ID = '75bf70be21bae77e80f2f1b1c6c0beb9'; // Из вашего токена

async function makeRequest(method, endpoint, params = null) {
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
    
    if (params) {
      config.params = params;
    }
    
    console.log(`\n🔄 ${method} ${endpoint}`);
    if (params) {
      console.log('📋 Параметры:', params);
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

async function main() {
  console.log('=====================================');
  console.log('ПОИСК ПРАВИЛЬНОГО MERCHANT ID');
  console.log('=====================================\n');
  console.log(`Client ID: ${CLIENT_ID}`);
  console.log(`Customer Code: ${CUSTOMER_CODE}\n`);
  
  console.log('Пробуем разные методы получения торговых точек...');
  console.log('----------------------------------------');
  
  // Список endpoints для проверки
  const endpoints = [
    {
      name: 'Get Retailers v1.0',
      endpoint: '/acquiring/v1.0/retailers',
      params: { customerCode: CUSTOMER_CODE }
    },
    {
      name: 'Get Retailers v2.0', 
      endpoint: '/acquiring/v2.0/retailers',
      params: { customerCode: CUSTOMER_CODE }
    },
    {
      name: 'Get Merchant List',
      endpoint: '/acquiring/v1.0/merchant/list',
      params: { customerCode: CUSTOMER_CODE }
    },
    {
      name: 'Get Retailers (with clientId)',
      endpoint: '/acquiring/v1.0/retailers',
      params: { 
        customerCode: CUSTOMER_CODE,
        clientId: CLIENT_ID 
      }
    },
    {
      name: 'Get Payment Operation List',
      endpoint: '/acquiring/v1.0/payments',
      params: { customerCode: CUSTOMER_CODE }
    }
  ];
  
  for (const test of endpoints) {
    console.log(`\n📍 ${test.name}`);
    
    const result = await makeRequest('GET', test.endpoint, test.params);
    
    if (result.success) {
      console.log('✅ УСПЕХ! Получен ответ:');
      console.log(JSON.stringify(result.data, null, 2));
      
      // Пытаемся найти merchantId в ответе
      const data = result.data?.Data || result.data;
      
      if (data) {
        // Ищем в разных местах
        const merchants = data.retailers || data.merchants || data.merchantList || data;
        
        if (Array.isArray(merchants)) {
          console.log('\n🎯 Найдены торговые точки:');
          merchants.forEach(m => {
            console.log(`- ID: ${m.id || m.merchantId || m.retailerId}`);
            console.log(`  Название: ${m.name || m.merchantName || 'не указано'}`);
            
            // Проверяем все поля на наличие длинного ID
            Object.keys(m).forEach(key => {
              const value = m[key];
              if (typeof value === 'string' && value.length >= 15 && /^\d+$/.test(value)) {
                console.log(`  🔑 Возможный merchantId: ${key} = ${value}`);
              }
            });
          });
        } else if (typeof data === 'object') {
          // Ищем любые длинные числовые ID
          console.log('\n🔍 Ищем длинные ID в ответе...');
          
          function findLongIds(obj, prefix = '') {
            Object.keys(obj).forEach(key => {
              const value = obj[key];
              if (typeof value === 'string' && value.length >= 15 && /^\d+$/.test(value)) {
                console.log(`  🔑 Найден длинный ID: ${prefix}${key} = ${value}`);
              } else if (typeof value === 'object' && value !== null) {
                findLongIds(value, `${prefix}${key}.`);
              }
            });
          }
          
          findLongIds(data);
        }
      }
    } else {
      console.log(`❌ Ошибка: ${result.status}`);
      if (result.error?.message) {
        console.log(`   ${result.error.message}`);
      }
    }
  }
  
  console.log('\n=====================================');
  console.log('РЕЗУЛЬТАТЫ:');
  console.log('=====================================');
  console.log('Если merchantId не найден автоматически:');
  console.log('\n📞 ОБРАТИТЕСЬ В ПОДДЕРЖКУ ТОЧКА БАНКА:');
  console.log('Телефон: 8 (800) 333-00-20');
  console.log('Email: help@tochka.com');
  console.log('\n📝 ТЕКСТ ЗАПРОСА:');
  console.log('"Здравствуйте! У меня подключен интернет-эквайринг');
  console.log('для торговой точки СЕВЕРНАЯ КОРЗИНА.');
  console.log('Мне нужен 15-значный merchantId для интеграции через API.');
  console.log('В личном кабинете вижу только короткий ID: 25552');
  console.log('Client ID: 75bf70be21bae77e80f2f1b1c6c0beb9');
  console.log('Customer Code: 305250626"');
  console.log('=====================================\n');
}

main();

/*
ЗАПУСК:
node test-get-merchants.js
*/

