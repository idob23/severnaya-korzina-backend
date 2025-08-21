// src/routes/payments.js
const express = require('express');
const router = express.Router();
const axios = require('axios');
const { authenticateToken } = require('../middleware/auth');

const YOOKASSA_SHOP_ID = '1148812';
const YOOKASSA_SECRET_KEY = 'test_jSLEuLPMPW58_iRfez3W_ToHsrMv2XS_cgqIYpNMa5A';
const YOOKASSA_API_URL = 'https://api.yookassa.ru/v3';

router.post('/create', authenticateToken, async (req, res) => {
  try {
    const { amount, orderId, customerPhone, customerName } = req.body;

    if (!amount || !orderId) {
      return res.status(400).json({
        success: false,
        error: 'Amount or order ID not specified'
      });
    }

    const basicAuth = Buffer.from(`${YOOKASSA_SHOP_ID}:${YOOKASSA_SECRET_KEY}`).toString('base64');
    const idempotenceKey = `order_${orderId}_${Date.now()}`;

    const requestBody = {
      amount: {
        value: parseFloat(amount).toFixed(2),
        currency: 'RUB',
      },
      confirmation: {
        type: 'redirect',
        return_url: 'https://sevkorzina.ru/payment-success?status=success',
      },
      capture: true,
      description: `Payment for order ${orderId}`,
      metadata: {
        order_id: orderId,
        customer_phone: customerPhone || '',
        customer_name: customerName || '',
        app_name: 'severnaya_korzina',
        user_id: req.user?.id || 1,
        // ДОБАВИТЬ данные заказа:
        order_data: JSON.stringify({
          addressId: req.body.addressId || 1,
          items: req.body.items || [],
          notes: req.body.notes || null
        })
      },
      payment_method_data: { type: 'bank_card' },
      receipt: {
        customer: { phone: customerPhone || '1234567890' },
        items: [{
          description: 'Payment for goods',
          quantity: '1.00',
          amount: {
            value: parseFloat(amount).toFixed(2),
            currency: 'RUB',
          },
          vat_code: 1
        }],
      },
    };

    const response = await axios.post(`${YOOKASSA_API_URL}/payments`, requestBody, {
      headers: {
        'Authorization': `Basic ${basicAuth}`,
        'Content-Type': 'application/json',
        'Idempotence-Key': idempotenceKey,
      },
      timeout: 30000
    });

    if (response.status === 200 || response.status === 201) {
      const paymentData = response.data;
      
      res.json({
        success: true,
        paymentId: paymentData.id,
        status: paymentData.status,
        confirmationUrl: paymentData.confirmation.confirmation_url,
        message: 'Payment created successfully'
      });
    } else {
      throw new Error(`YooKassa API returned status ${response.status}`);
    }

  } catch (error) {
    console.error('Payment creation error:', error.message);

    if (error.response?.data) {
      res.status(400).json({
        success: false,
        error: error.response.data.description || 'Payment system error'
      });
    } else {
      res.status(500).json({
        success: false,
        error: 'Connection error to payment system'
      });
    }
  }
});

router.get('/status/:paymentId', authenticateToken, async (req, res) => {
  try {
    const { paymentId } = req.params;
    const basicAuth = Buffer.from(`${YOOKASSA_SHOP_ID}:${YOOKASSA_SECRET_KEY}`).toString('base64');

    const response = await axios.get(`${YOOKASSA_API_URL}/payments/${paymentId}`, {
      headers: {
        'Authorization': `Basic ${basicAuth}`,
        'Content-Type': 'application/json',
      },
      timeout: 10000
    });

    if (response.status === 200) {
      const paymentData = response.data;
      
      res.json({
        success: true,
        paymentId: paymentData.id,
        status: paymentData.status,
        isPaid: paymentData.status === 'succeeded',
        isCanceled: paymentData.status === 'canceled',
        isPending: paymentData.status === 'pending',
        amount: parseFloat(paymentData.amount.value),
        createdAt: paymentData.created_at,
        paidAt: paymentData.paid_at || null
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Error checking payment status'
    });
  }
});

// В src/routes/payments.js добавить webhook endpoint в конец файла (перед module.exports):

// POST /api/payments/webhook - Webhook для уведомлений от ЮKassa
router.post('/webhook', async (req, res) => {
  try {
    const { event, object } = req.body;

    console.log('🔔 Webhook от ЮKassa:', { event, paymentId: object?.id });

    // Обрабатываем только успешные платежи
    if (event === 'payment.succeeded' && object?.status === 'succeeded') {
      await handleSuccessfulPayment(object);
    }

    // Всегда отвечаем 200, чтобы ЮKassa не повторяла запрос
    res.status(200).json({ success: true });

  } catch (error) {
    console.error('❌ Ошибка обработки webhook:', error);
    res.status(200).json({ success: true }); // Все равно отвечаем 200
  }
});

// Функция обработки успешного платежа
async function handleSuccessfulPayment(paymentObject) {
  try {
    const { id: paymentId, metadata } = paymentObject;
    
    console.log('✅ Обработка успешного платежа:', paymentId);
    console.log('📦 Metadata:', metadata);

    // Извлекаем данные заказа из metadata
    if (!metadata?.order_data) {
      console.log('⚠️ Нет данных заказа в metadata');
      return;
    }

    const orderData = JSON.parse(metadata.order_data);
    const userId = parseInt(metadata.user_id || 1);

    console.log('📋 Создаем заказ:', { userId, orderData });

    // Создаем заказ в базе данных
    const { PrismaClient } = require('@prisma/client');
    const prisma = new PrismaClient();

    const result = await prisma.$transaction(async (tx) => {
      // 1. Создаем заказ
      const newOrder = await tx.order.create({
        data: {
          userId: userId,
          addressId: parseInt(orderData.addressId || 1),
          batchId: orderData.batchId ? parseInt(orderData.batchId) : null,
          totalAmount: parseFloat(paymentObject.amount.value),
          notes: orderData.notes || `Автоматически создан после платежа ${paymentId}`,
          status: 'paid' // Сразу помечаем как оплаченный
        }
      });

      // 2. Создаем позиции заказа
      if (orderData.items && orderData.items.length > 0) {
        await tx.orderItem.createMany({
          data: orderData.items.map(item => ({
            orderId: newOrder.id,
            productId: parseInt(item.productId),
            quantity: parseInt(item.quantity),
            price: parseFloat(item.price)
          }))
        });
      }

      return newOrder;
    });

    console.log(`✅ Заказ создан автоматически: ${result.id} после платежа ${paymentId}`);

  } catch (error) {
    console.error('❌ Ошибка создания заказа после платежа:', error);
  }
}

module.exports = router;
