// src/routes/payments.js - ПОЛНОСТЬЮ ПЕРЕПИСАННЫЙ ПОД ТОЧКА БАНК
const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { updateBatchOnOrderChange } = require('../utils/batchCalculations');

// === ИМПОРТ ТОЧКА БАНК ===
const TochkaPaymentService = require('../services/tochkaPaymentService');
const tochkaService = new TochkaPaymentService();

// Функция получения настроек системы
async function getSystemSettings() {
  try {
    const settings = await prisma.systemSettings.findMany();
    const result = {};
    settings.forEach(s => {
      result[s.key] = s.value;
    });
    return result;
  } catch (error) {
    console.error('Ошибка получения настроек:', error);
    return {
      default_margin_percent: '20',
      vat_code: '6'
    };
  }
}

// POST /api/payments/create - Создание платежа через Точка Банк
router.post('/create', authenticateToken, async (req, res) => {
  try {
    const { 
      amount, 
      orderId, 
      customerPhone, 
      customerName, 
      batchId,
      addressId,
      items,
      notes
    } = req.body;

    if (!amount || !orderId) {
      return res.status(400).json({
        success: false,
        error: 'Amount or order ID not specified'
      });
    }

    // Создаем настоящий заказ если orderId начинается с ORDER_
    let realOrderId = orderId;
    let orderCreated = false;
    
    if (orderId.startsWith('ORDER_') && items && items.length > 0) {
      console.log('📦 Создаем настоящий заказ перед платежом...');
      
      const order = await prisma.$transaction(async (tx) => {
        // 1. Создаем заказ со статусом pending
        const newOrder = await tx.order.create({
          data: {
            userId: req.user.id,
            batchId: batchId ? parseInt(batchId) : null,
            addressId: addressId || 1,
            status: 'pending',
            totalAmount: parseFloat(amount),
            notes: notes || null,
          }
        });

        // 2. Создаем позиции заказа
        for (const item of items) {
          await tx.orderItem.create({
            data: {
              orderId: newOrder.id,
              productId: item.productId,
              quantity: item.quantity,
              price: parseFloat(item.price)
            }
          });
        }

        return newOrder;
      });

      realOrderId = order.id.toString();
      orderCreated = true;
      console.log(`✅ Создан заказ #${realOrderId} со статусом pending`);

      // Обновляем статистику партии
      if (order.batchId) {
        try {
          await updateBatchOnOrderChange(order.id, 'create');
          console.log(`📊 Статистика партии #${order.batchId} обновлена`);
        } catch (error) {
          console.error(`⚠️ Ошибка обновления статистики: ${error.message}`);
        }
      }
    }

    // Получаем настройки системы
    const settings = await getSystemSettings();
    const vatCode = parseInt(settings.vat_code || '6');
    
    // Получаем маржу
    let marginPercent = parseFloat(settings.default_margin_percent || '20');
    
    if (batchId) {
      const batch = await prisma.batch.findUnique({
        where: { id: parseInt(batchId) }
      });
      if (batch && batch.marginPercent) {
        marginPercent = parseFloat(batch.marginPercent);
      }
    }

    // === СОЗДАЕМ ПЛАТЕЖ ЧЕРЕЗ ТОЧКА БАНК ===
    console.log('🏦 Создаем платеж через Точка Банк');
    
    const result = await tochkaService.createPayment({
      amount: amount,
      orderId: realOrderId,
      userId: req.user.id,
      batchId: batchId,
      marginPercent: marginPercent,
      vatCode: vatCode,
      customerPhone: customerPhone || '79999999999'
    });

    res.json(result);

  } catch (error) {
    console.error('❌ Payment creation error:', error.message);

    // Если ошибка и заказ был создан - удаляем его
    if (orderCreated && realOrderId) {
      try {
        await prisma.order.delete({
          where: { id: parseInt(realOrderId) }
        });
        console.log(`🗑️ Заказ #${realOrderId} удален из-за ошибки платежа`);
      } catch (deleteError) {
        console.error('Ошибка удаления заказа:', deleteError);
      }
    }

    res.status(500).json({
      success: false,
      error: error.response?.data?.message || 'Ошибка создания платежа'
    });
  }
});

// GET /api/payments/status/:paymentId - Проверка статуса платежа
router.get('/status/:paymentId', authenticateToken, async (req, res) => {
  try {
    const { paymentId } = req.params;
    
    console.log(`🔍 Проверка статуса платежа: ${paymentId}`);
    
    const status = await tochkaService.checkPaymentStatus(paymentId);
    
    res.json({
      success: true,
      ...status
    });

  } catch (error) {
    console.error('❌ Payment status check error:', error.message);
    res.status(500).json({
      success: false,
      error: 'Ошибка проверки статуса платежа'
    });
  }
});

// POST /api/payments/webhook - Webhook от Точка Банк
router.post('/webhook', async (req, res) => {
  try {
    console.log('🔔 Webhook от Точка Банк получен');
    console.log('📦 Данные:', JSON.stringify(req.body, null, 2));

    const webhookData = req.body;
    
    // Обрабатываем webhook
    await tochkaService.handleWebhook(webhookData);

    // Если платеж успешен - обновляем заказ
    if (webhookData.event === 'acquiringInternetPayment' && 
        webhookData.data?.status === 'APPROVED') {
      
      const paymentId = webhookData.data.operationId;
      
      // Находим заказ по metadata (нужно будет сохранять связь)
      // Пока просто логируем
      console.log(`✅ Платеж ${paymentId} успешно оплачен`);
      
      // TODO: Обновить статус заказа в БД
    }

    // Всегда отвечаем 200
    res.status(200).json({ success: true });

  } catch (error) {
    console.error('❌ Webhook processing error:', error);
    // Все равно отвечаем 200, чтобы банк не повторял запрос
    res.status(200).json({ success: true });
  }
});

module.exports = router;
