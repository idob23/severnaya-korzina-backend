// scripts/test-sms.js - Тестовый скрипт для проверки SMS
const axios = require('axios');
require('dotenv').config();

const API_BASE = 'http://localhost:3000/api';

async function testSMS() {
  console.log('🧪 Тестируем SMS сервис...\n');

  try {
    // 1. Проверяем статус сервиса
    console.log('1️⃣ Проверяем статус SMS сервиса...');
    const statusResponse = await axios.get(`${API_BASE}/sms/status`);
    console.log('✅ Статус:', statusResponse.data);
    console.log('');

    // 2. Отправляем тестовое SMS
    const testPhone = '+79142667582'; // Замените на свой номер
    console.log(`2️⃣ Отправляем тестовое SMS на ${testPhone}...`);
    
    const sendResponse = await axios.post(`${API_BASE}/sms/send`, {
      phone: testPhone
    });
    
    console.log('✅ Отправка:', sendResponse.data);
    console.log('');

    // 3. Ждем ввода кода
    const readline = require('readline');
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });

    rl.question('🔍 Введите код из SMS: ', async (code) => {
      try {
        console.log(`3️⃣ Проверяем код ${code}...`);
        
        const verifyResponse = await axios.post(`${API_BASE}/sms/verify`, {
          phone: testPhone,
          code: code
        });
        
        console.log('✅ Проверка:', verifyResponse.data);
        
      } catch (error) {
        console.error('❌ Ошибка проверки:', error.response?.data || error.message);
      } finally {
        rl.close();
      }
    });

  } catch (error) {
    console.error('❌ Ошибка тестирования:', error.response?.data || error.message);
  }
}

// Запускаем тест
testSMS();
