// src/routes/settings.js - Новый файл для управления настройками
const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// GET /api/settings/checkout-enabled - Получить статус кнопки оформления заказов
router.get('/checkout-enabled', async (req, res) => {
  try {
    // Получаем настройку из БД
    const setting = await prisma.$queryRaw`
      SELECT value FROM app_settings WHERE key = 'checkout_enabled'
    `;
    
    const isEnabled = setting && setting[0] ? setting[0].value === 'true' : true;
    
    res.json({
      success: true,
      checkoutEnabled: isEnabled
    });
  } catch (error) {
    console.error('Ошибка получения настройки:', error);
    // При ошибке разрешаем оформление
    res.json({
      success: true,
      checkoutEnabled: true
    });
  }
});

// PUT /api/settings/checkout-enabled - Изменить статус кнопки (только для админа)
router.put('/checkout-enabled', async (req, res) => {
  try {
    const { enabled } = req.body;
    
    // Обновляем настройку в БД
    await prisma.$executeRaw`
      UPDATE app_settings 
      SET value = ${enabled ? 'true' : 'false'}, 
          updated_at = CURRENT_TIMESTAMP
      WHERE key = 'checkout_enabled'
    `;
    
    console.log(`✅ Оформление заказов ${enabled ? 'включено' : 'выключено'}`);
    
    res.json({
      success: true,
      message: `Оформление заказов ${enabled ? 'включено' : 'выключено'}`,
      checkoutEnabled: enabled
    });
  } catch (error) {
    console.error('Ошибка обновления настройки:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления настройки'
    });
  }
});

module.exports = router;
