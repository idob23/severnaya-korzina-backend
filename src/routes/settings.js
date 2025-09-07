// src/routes/settings.js - Новый файл для управления настройками
const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// GET /api/settings/checkout-enabled - Получить статус кнопки оформления заказов
router.get('/checkout-enabled', async (req, res) => {
  try {
    // Получаем настройку из таблицы system_settings
    const setting = await prisma.systemSettings.findUnique({
      where: { key: 'checkout_enabled' }
    });
    
    const isEnabled = setting ? setting.value === 'true' : true;
    
    res.json({
      success: true,
      checkoutEnabled: isEnabled
    });
  } catch (error) {
    console.error('Ошибка получения настройки checkout_enabled:', error);
    // При ошибке разрешаем оформление по умолчанию
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
    
    // Создаем или обновляем настройку в system_settings
    await prisma.systemSettings.upsert({
      where: { key: 'checkout_enabled' },
      update: { 
        value: enabled ? 'true' : 'false',
        updatedAt: new Date()
      },
      create: { 
        key: 'checkout_enabled',
        value: enabled ? 'true' : 'false',
        description: 'Разрешить пользователям оформлять заказы'
      }
    });
    
    console.log(`✅ Оформление заказов ${enabled ? 'включено' : 'выключено'}`);
    
    res.json({
      success: true,
      message: `Оформление заказов ${enabled ? 'включено' : 'выключено'}`,
      checkoutEnabled: enabled
    });
  } catch (error) {
    console.error('Ошибка обновления настройки checkout_enabled:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления настройки'
    });
  }
});

module.exports = router;
