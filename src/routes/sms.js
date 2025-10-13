// src/routes/sms.js - SMS маршруты для отправки через SMS Aero
const express = require('express');
const axios = require('axios');
const router = express.Router();

// Создаем axios instance для SMS Aero
const smsAxios = axios.create({
  baseURL: 'https://gate.smsaero.ru/v2',
  timeout: 30000,
  headers: {
    'Authorization': `Basic ${Buffer.from(`${process.env.SMS_AERO_EMAIL}:${process.env.SMS_AERO_API_KEY}`).toString('base64')}`,
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

// Временное хранилище кодов
const tempCodes = new Map();

// Функция генерации 4-значного кода
function generateCode() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// POST /api/sms/send - Отправка SMS через наш сервер (прокси к SMS Aero)
router.post('/send', async (req, res) => {
  try {
    const { phone, code } = req.body;

    console.log('📱 SMS Запрос:', { phone, code: code ? '****' : 'не указан' });

    if (!phone) {
      return res.status(400).json({
        success: false,
        error: 'Номер телефона обязателен'
      });
    }

    // Форматируем номер
    let cleanPhone = phone.replace(/[^\d]/g, '');
    
    // Приводим к формату 7XXXXXXXXXX
    if (cleanPhone.startsWith('8') && cleanPhone.length === 11) {
      cleanPhone = '7' + cleanPhone.substring(1);
    } else if (!cleanPhone.startsWith('7')) {
      cleanPhone = '7' + cleanPhone;
    }

    // Генерируем код если не передан
    const smsCode = code || generateCode();
    
    // Сохраняем код для верификации
    tempCodes.set(phone, smsCode);
    tempCodes.set(cleanPhone, smsCode);
    
    console.log(`🔑 Генерируемый код: ${smsCode} для номера: ${cleanPhone}`);

    try {
      // Сначала проверяем баланс
      console.log('💰 Проверяем баланс SMS Aero...');
      
      const balanceResponse = await smsAxios.get('/balance');
      console.log('💰 Баланс SMS Aero:', balanceResponse.data);

      // Отправляем SMS через SMS Aero
      console.log('📤 Отправляем SMS через SMS Aero...');
      
      const smsData = {
        number: cleanPhone,
	text: `Северная Корзина\nВаш код: ${smsCode}`,
        sign: 'SMS Aero',
        channel: 'DIRECT'
      };

      console.log('📤 Данные для отправки:', smsData);

      const smsResponse = await smsAxios.post('/sms/send', smsData);
      
      console.log('✅ Ответ SMS Aero:', smsResponse.data);

      if (smsResponse.data && smsResponse.data.success) {
        console.log('✅ SMS успешно отправлено через SMS Aero');
        
        return res.json({
          success: true,
          message: 'SMS отправлено',
          data: {
            id: smsResponse.data.data?.id,
            phone: cleanPhone
          }
        });
      } else {
        console.log('❌ SMS Aero вернул ошибку:', smsResponse.data);
        throw new Error(smsResponse.data?.message || 'Ошибка SMS Aero');
      }

    } catch (smsError) {
      console.error('❌ Ошибка отправки через SMS Aero:', smsError.message);
      
      // В случае ошибки SMS Aero, симулируем успешную отправку для разработки
      if (process.env.NODE_ENV !== 'production' || process.env.MOCK_SMS === 'true') {
        console.log('🔧 MOCK SMS: Симулируем успешную отправку для разработки');
        
        return res.json({
          success: true,
          message: 'SMS отправлено (MOCK)',
          data: {
            id: 'mock_' + Date.now(),
            phone: cleanPhone,
            mock: true
          }
        });
      }
      
      throw smsError;
    }

  } catch (error) {
    console.error('❌ Ошибка отправки SMS:', error);
    
    return res.status(500).json({
      success: false,
      error: 'Ошибка отправки SMS: ' + error.message,
      details: process.env.NODE_ENV !== 'production' ? error.stack : undefined
    });
  }
});

// POST /api/sms/verify - Проверка SMS кода
router.post('/verify', async (req, res) => {
  try {
    const { phone, code } = req.body;

    console.log('🔍 Проверка SMS кода:', { phone, code });

    if (!phone || !code) {
      return res.status(400).json({
        success: false,
        error: 'Номер телефона и код обязательны'
      });
    }

    // Форматируем номер так же как при отправке
    let cleanPhone = phone.replace(/[^\d]/g, '');
    if (cleanPhone.startsWith('8') && cleanPhone.length === 11) {
      cleanPhone = '7' + cleanPhone.substring(1);
    } else if (!cleanPhone.startsWith('7')) {
      cleanPhone = '7' + cleanPhone;
    }

    console.log('🔍 Ищем код для номеров:', { original: phone, clean: cleanPhone });
    console.log('🔍 Сохраненные коды:', Array.from(tempCodes.keys()));

    // Проверяем код для всех возможных форматов
    const savedCode = tempCodes.get(phone) || tempCodes.get(cleanPhone);

    if (!savedCode) {
      console.log('❌ Код не найден в хранилище');
      return res.status(400).json({
        success: false,
        error: 'Код не найден или истек'
      });
    }

    if (savedCode === code) {
      console.log('✅ Код верный, удаляем из хранилища');
      
      // Удаляем использованный код
      tempCodes.delete(phone);
      tempCodes.delete(cleanPhone);
      
      return res.json({
        success: true,
        message: 'Код подтвержден'
      });
    } else {
      console.log(`❌ Неверный код. Ожидали: ${savedCode}, получили: ${code}`);
      return res.status(400).json({
        success: false,
        error: 'Неверный код'
      });
    }

  } catch (error) {
    console.error('❌ Ошибка проверки SMS кода:', error);
    
    return res.status(500).json({
      success: false,
      error: 'Ошибка проверки кода: ' + error.message
    });
  }
});

// GET /api/sms/status - Статус SMS сервиса
router.get('/status', async (req, res) => {
  try {
    // Проверяем подключение к SMS Aero
    const balanceResponse = await smsAxios.get('/balance');
    
    res.json({
      success: true,
      service: 'SMS Aero',
      status: 'connected',
      balance: balanceResponse.data?.data?.balance || 'unknown',
      codesInMemory: tempCodes.size
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      service: 'SMS Aero',
      status: 'error',
      error: error.message
    });
  }
});

module.exports = router;
