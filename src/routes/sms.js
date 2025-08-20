const express = require('express');
const router = express.Router();
const axios = require('axios');

// Настройки SMS Aero
const SMS_AERO_EMAIL = 'idob230491@gmail.com';
const SMS_AERO_API_KEY = 'J1WD5J__f3ztsHpi5sBWrVef5jlVRo9J';
const SMS_AERO_URL = 'https://gate.smsaero.ru/v2';

// Базовая авторизация для SMS Aero
const smsAuth = Buffer.from(`${SMS_AERO_EMAIL}:${SMS_AERO_API_KEY}`).toString('base64');

// POST /api/sms/send
router.post('/send', async (req, res) => {
  try {
    const { phone, code } = req.body;
    
    const response = await axios.post(
      `${SMS_AERO_URL}/sms/send`,
      {
        number: phone,
        text: `Северная Корзина: Ваш код ${code}`,
        sign: 'SMS Aero',
        channel: 'DIRECT'
      },
      {
        headers: {
          'Authorization': `Basic ${smsAuth}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    res.json({ success: true, data: response.data });
  } catch (error) {
    console.error('SMS Error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

module.exports = router;
