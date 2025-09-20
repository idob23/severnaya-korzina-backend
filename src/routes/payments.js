// src/routes/payments.js
const express = require('express');
const router = express.Router();
const axios = require('axios');
const { authenticateToken } = require('../middleware/auth');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { updateBatchOnOrderChange } = require('../utils/batchCalculations'); // ОДИН РАЗ ЗДЕСЬ

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
    // Возвращаем дефолтные значения если БД недоступна
    return {
      default_margin_percent: '20',
      vat_code: '6',
      payment_mode: 'test',
      enable_test_cards: 'true'
    };
  }
}

const YOOKASSA_API_URL = 'https://api.yookassa.ru/v3';

// src/routes/payments.js
function getReturnUrl(orderId, isWeb = false) {
  if (isWeb) {
    // Для веб-версии - прямой редирект в приложение
    return 'https://app.sevkorzina.ru/#/payment-success?orderId=' + orderId;
  }
  // Для мобильных - простая страница с инструкцией
  return 'https://app.sevkorzina.ru/#/mobile-payment-info';
}

router.post('/create', authenticateToken, async (req, res) => {
  
  try {
    const { 
      amount, 
      orderId, 
      customerPhone, 
      customerName, 
      batchId,
      // Параметры для создания заказа:
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

    // НОВАЯ ЛОГИКА: Создаем настоящий заказ если orderId начинается с ORDER_
    let realOrderId = orderId;
    let orderCreated = false;
    
    if (orderId.startsWith('ORDER_') && items && items.length > 0) {
      console.log('📦 Создаем настоящий заказ перед платежом...');
      
      // Создаем заказ в транзакции
      const order = await prisma.$transaction(async (tx) => {
        // 1. Создаем заказ со статусом pending
        const newOrder = await tx.order.create({
          data: {
            userId: req.user.id,
            batchId: batchId ? parseInt(batchId) : null,
            addressId: addressId || 1,
            status: 'pending', // Важно: статус pending, не paid!
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

      // ДОБАВИТЬ:
// Обновляем статистику партии при создании заказа
if (order.batchId) {
  try {
    await updateBatchOnOrderChange(order.id, 'create');
    console.log(`📊 Статистика партии #${order.batchId} обновлена при создании заказа`);
  } catch (error) {
    console.error(`⚠️ Ошибка обновления статистики: ${error.message}`);
    // Не прерываем процесс - заказ уже создан
  }
}
 
    }

    // Получаем настройки системы
    const settings = await getSystemSettings();
    const vatCode = parseInt(settings.vat_code || '6');
    
    // Получаем маржу из партии или используем дефолтную
    let marginPercent = parseFloat(settings.default_margin_percent || '20');
    
    if (batchId) {
      const batch = await prisma.batch.findUnique({
        where: { id: parseInt(batchId) }
      });
      if (batch && batch.marginPercent) {
        marginPercent = parseFloat(batch.marginPercent);
      }
    }
    
    // Определяем режим оплаты и ключи
    const paymentMode = settings.payment_mode || 'test';
    const YOOKASSA_SHOP_ID = paymentMode === 'production' 
      ? process.env.YOOKASSA_SHOP_ID_PROD 
      : process.env.YOOKASSA_SHOP_ID_TEST || '1148812';
    const YOOKASSA_SECRET_KEY = paymentMode === 'production'
      ? process.env.YOOKASSA_SECRET_KEY_PROD
      : process.env.YOOKASSA_SECRET_KEY_TEST || 'test_jSLEuLPMPW58_iRfez3W_ToHsrMv2XS_cgqIYpNMa5A';
    
    console.log(`💳 Создание платежа для заказа #${realOrderId}, режим: ${paymentMode}, маржа: ${marginPercent}%, НДС код: ${vatCode}`);
    
    const basicAuth = Buffer.from(`${YOOKASSA_SHOP_ID}:${YOOKASSA_SECRET_KEY}`).toString('base64');
    const idempotenceKey = `order_${realOrderId}_${Date.now()}`;
    
    // Рассчитываем суммы для чека
    const totalWithMargin = parseFloat(amount);
    const goodsAmount = (totalWithMargin / (1 + marginPercent / 100)).toFixed(2);
    const serviceAmount = (totalWithMargin - parseFloat(goodsAmount)).toFixed(2);
    
    console.log(`💰 Расчет: Итого=${totalWithMargin}, Товары=${goodsAmount}, Услуга=${serviceAmount}`);

    const requestBody = {
      amount: {
        value: parseFloat(amount).toFixed(2),
        currency: 'RUB',
      },
      confirmation: {
        type: 'redirect',
        return_url: getReturnUrl(),
      },
      capture: true,
      description: `Оплата заказа ${realOrderId}`,
      metadata: {
        order_id: realOrderId, // Теперь это настоящий ID!
        customer_phone: customerPhone || '',
        customer_name: customerName || '',
        app_name: 'severnaya_korzina',
        user_id: req.user?.id || 1,
        batch_id: batchId || null,
        margin_percent: marginPercent,
        order_created: orderCreated // Флаг что заказ создан
      },
      payment_method_data: { type: 'bank_card' },
      receipt: {
        customer: { 
          phone: customerPhone || '79999999999' 
        },
        items: [
          {
            description: `Товары коллективной закупки${batchId ? ` (партия №${batchId})` : ''}`,
            quantity: '1.00',
            amount: {
              value: goodsAmount,
              currency: 'RUB',
            },
            vat_code: vatCode,
            payment_subject: 'commodity', // товар
            payment_mode: 'full_payment'
          },
          {
            description: 'Услуга организации коллективной закупки',
            quantity: '1.00',
            amount: {
              value: serviceAmount,
              currency: 'RUB',
            },
            vat_code: vatCode,
            payment_subject: 'service', // услуга
            payment_mode: 'full_payment'
          }
        ]
      }
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
        message: 'Payment created successfully',
        realOrderId: realOrderId, // Возвращаем настоящий ID заказа
        orderCreated: orderCreated, // Флаг для фронтенда
        breakdown: {
          goods: parseFloat(goodsAmount),
          service: parseFloat(serviceAmount),
          total: parseFloat(amount),
          marginPercent: marginPercent
        }
      });
    } else {
      // Если платеж не создался и мы создали заказ, удаляем его
      if (orderCreated) {
        await prisma.order.delete({
          where: { id: parseInt(realOrderId) }
        });
        console.log(`❌ Платеж не создан, заказ #${realOrderId} удален`);
      }
      throw new Error(`YooKassa API returned status ${response.status}`);
    }

  } catch (error) {
    console.error('❌ Payment creation error:', error.message);

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
    
    // Получаем настройки для определения режима
    const settings = await getSystemSettings();
    const paymentMode = settings.payment_mode || 'test';
    const YOOKASSA_SHOP_ID = paymentMode === 'production' 
      ? process.env.YOOKASSA_SHOP_ID_PROD 
      : process.env.YOOKASSA_SHOP_ID_TEST || '1148812';
    const YOOKASSA_SECRET_KEY = paymentMode === 'production'
      ? process.env.YOOKASSA_SECRET_KEY_PROD
      : process.env.YOOKASSA_SECRET_KEY_TEST || 'test_jSLEuLPMPW58_iRfez3W_ToHsrMv2XS_cgqIYpNMa5A';
    
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

    if (!metadata?.order_id) {
      console.log('⚠️ Нет order_id в metadata');
      return;
    }

    const orderId = parseInt(metadata.order_id);
    if (isNaN(orderId)) {
      console.log('⚠️ Неверный формат order_id:', metadata.order_id);
      return;
    }
    const { PrismaClient } = require('@prisma/client');
    const { updateBatchOnOrderChange } = require('../utils/batchCalculations');
    const prisma = new PrismaClient();

    const existingOrder = await prisma.order.findUnique({
      where: { id: orderId }
    });

    if (!existingOrder || existingOrder.status === 'paid') {
      console.log('⚠️ Заказ не найден или уже оплачен:', orderId);
      return;
    }

    await prisma.order.update({
      where: { id: orderId },
      data: { status: 'paid', updatedAt: new Date() }
    });

    if (existingOrder.batchId) {
      await updateBatchOnOrderChange(orderId, 'update');
    }

    console.log(`✅ Заказ ${orderId} обновлен на статус 'paid'`);

  } catch (error) {
    console.error('❌ Ошибка обработки платежа:', error);
  }
}

module.exports = router;
