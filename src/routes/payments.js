// src/routes/payments.js - ПОЛНОСТЬЮ ПЕРЕПИСАННЫЙ ПОД ТОЧКА БАНК
const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const { updateBatchStatistics } = require('../utils/batchCalculations');

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
 let realOrderId = null;
  let orderCreated = false;
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

        // 2. Добавляем товары
        for (const item of items) {
          await tx.orderItem.create({
            data: {
              orderId: newOrder.id,
              productId: parseInt(item.productId),
              quantity: parseInt(item.quantity),
              price: parseFloat(item.price)
            }
          });
        }

        return newOrder;
      });

      realOrderId = order.id.toString();
      orderCreated = true;
      console.log(`✅ Заказ #${realOrderId} создан`);
    }

    // Получаем настройки
    const settings = await getSystemSettings();
    const defaultMargin = parseFloat(settings.default_margin_percent || '20');
    const vatCode = parseInt(settings.vat_code || '6');

    // Проверяем маржу партии
    let marginPercent = defaultMargin;
    if (batchId) {
      const batch = await prisma.batch.findUnique({
        where: { id: parseInt(batchId) },
        select: { marginPercent: true }
      });
      if (batch && batch.marginPercent) {
        marginPercent = parseFloat(batch.marginPercent);
      }
    }

    console.log('=== СОЗДАЕМ ПЛАТЕЖ ЧЕРЕЗ ТОЧКА БАНК ===');
    console.log('🏦 Создаем платеж через Точка Банк');
    
    // СОЗДАЁМ ПЛАТЁЖ В ТОЧКА БАНК
    const result = await tochkaService.createPayment({
      amount: amount,
      orderId: realOrderId,
      userId: req.user.id,
      batchId: batchId,
      marginPercent: marginPercent,
      vatCode: vatCode,
      customerPhone: customerPhone || '79999999999',
 customerEmail: 'customer@sevkorzina.ru',  // <-- ДОБАВИТЬ ЭТУ СТРОКУ      
items: items || [] // ✅ НОВОЕ: Передаем массив товаров с именами
    });

 // ✅ НОВОЕ: СОХРАНЯЕМ ЗАПИСЬ В ТАБЛИЦЕ PAYMENTS
console.log('💾 Сохраняем платёж в БД...');

try {
  // Только если это реальный заказ (не TEST_)
  const orderIdNum = parseInt(realOrderId);
  
  if (!isNaN(orderIdNum)) {
    await prisma.payment.create({
      data: {
        paymentId: result.paymentId,
        orderId: orderIdNum,
        provider: 'tochka',
        status: result.status || 'CREATED',
        amount: parseFloat(amount),
        metadata: JSON.stringify({
          breakdown: result.breakdown,
          confirmationUrl: result.confirmationUrl,
          userId: req.user.id,
          batchId: batchId,
          customerPhone: customerPhone
        })
      }
    });
    
    console.log(`✅ Платёж ${result.paymentId} сохранён в БД`);
  } else {
    console.log(`⚠️ Тестовый платёж, пропускаем сохранение в БД`);
  }
} catch (dbError) {
  console.error('⚠️ Ошибка сохранения платежа в БД:', dbError.message);
}
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
    console.log('🔔 ========================================');
    console.log('🔔 WEBHOOK ОТ ТОЧКА БАНК ПОЛУЧЕН');
    console.log('🔔 ========================================');
    console.log('📦 Данные вебхука:', JSON.stringify(req.body, null, 2));

    const webhookData = req.body;
    
    // Проверяем тип события
    if (webhookData.event === 'acquiringInternetPayment') {
      const { operationId, status, amount } = webhookData.data;
      
      console.log(`💳 Payment ID: ${operationId}`);
      console.log(`📊 Status: ${status}`);
      console.log(`💰 Amount: ${amount}`);

      // ✅ ШАГ 1: НАХОДИМ ПЛАТЁЖ В БД
      const payment = await prisma.payment.findUnique({
        where: { paymentId: operationId },
        include: {
          order: {
            include: {
              batch: true
            }
          }
        }
      });

      if (!payment) {
        console.error(`❌ Платёж ${operationId} не найден в БД!`);
        // Всё равно отвечаем 200
        return res.status(200).json({ success: true });
      }

      console.log(`✅ Платёж найден: Order #${payment.orderId}`);

      // ✅ ШАГ 2: ОБНОВЛЯЕМ ЗАПИСЬ В PAYMENTS
      await prisma.payment.update({
        where: { paymentId: operationId },
        data: {
          status: status,
          paidAt: status === 'APPROVED' ? new Date() : null,
          metadata: JSON.stringify({
            ...JSON.parse(payment.metadata || '{}'),
            webhookData: webhookData.data,
            updatedAt: new Date().toISOString()
          })
        }
      });

      console.log(`✅ Статус платежа обновлён: ${status}`);

      // ✅ ШАГ 3: ОБРАБОТКА УСПЕШНОГО ПЛАТЕЖА
      if (status === 'APPROVED') {
        console.log('🎉 Платёж успешен! Обновляем заказ...');
        
        // Обновляем статус заказа
        await prisma.order.update({
          where: { id: payment.orderId },
          data: { 
            status: 'paid',
            updatedAt: new Date()
          }
        });

        console.log(`✅ Заказ #${payment.orderId} обновлён → status: paid`);

        // Обновляем статистику партии
        if (payment.order.batchId) {
          console.log(`📊 Обновляем статистику партии #${payment.order.batchId}...`);
          
          try {
            await updateBatchStatistics(payment.order.batchId);
            console.log(`✅ Статистика партии #${payment.order.batchId} обновлена`);
          } catch (batchError) {
            console.error(`⚠️ Ошибка обновления партии:`, batchError.message);
          }
        }

        // TODO: Отправить уведомление пользователю
        console.log('📧 TODO: Отправить уведомление пользователю');
      }

      // ✅ ШАГ 4: ОБРАБОТКА ОТКЛОНЁННОГО ПЛАТЕЖА
      if (status === 'FAILED' || status === 'REJECTED') {
        console.log('❌ Платёж отклонён! Отменяем заказ...');
        
        // Отменяем заказ
        await prisma.order.update({
          where: { id: payment.orderId },
          data: { 
            status: 'cancelled',
            updatedAt: new Date()
          }
        });

        console.log(`✅ Заказ #${payment.orderId} отменён`);

        // Обновляем статистику партии (уменьшаем сумму)
        if (payment.order.batchId) {
          console.log(`📊 Обновляем статистику партии #${payment.order.batchId}...`);
          
          try {
            await updateBatchStatistics(payment.order.batchId);
            console.log(`✅ Статистика партии обновлена`);
          } catch (batchError) {
            console.error(`⚠️ Ошибка обновления партии:`, batchError.message);
          }
        }

        // TODO: Отправить уведомление об отмене
        console.log('📧 TODO: Отправить уведомление об отмене');
      }

      console.log('🔔 ========================================');
      console.log('🔔 WEBHOOK ОБРАБОТАН УСПЕШНО');
      console.log('🔔 ========================================');
    }

    // ВСЕГДА отвечаем 200 OK
    res.status(200).json({ success: true });

  } catch (error) {
    console.error('❌ Webhook processing error:', error);
    console.error('❌ Stack:', error.stack);
    
    // ВСЁ РАВНО отвечаем 200, чтобы банк не повторял запрос
    res.status(200).json({ success: true });
  }
});

// Обработчик редиректа после оплаты
router.get('/redirect/:status', async (req, res) => {
  const { orderId } = req.query;
  const status = req.params.status;
  
  console.log(`🔄 Redirect: status=${status}, orderId=${orderId}`);
  
  try {
    // Получаем последний платеж для этого заказа
    const payment = await prisma.payment.findFirst({
      where: { orderId: parseInt(orderId) },
      orderBy: { createdAt: 'desc' }
    });
    
    const paymentId = payment ? payment.paymentId : '';
    
// Формируем конечный URL (ваши правильные URL)
    let finalUrl;
    if (status === 'success') {
      finalUrl = `https://app.sevkorzina.ru/#/payment-checking?paymentId=${paymentId}&orderId=${orderId}`;
    } else {
      finalUrl = `https://app.sevkorzina.ru/#/payment-failed?orderId=${orderId}`;
    }
    
    // Отправляем HTML страницу с автоматическим редиректом
    res.send(`
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Автоматический редирект через 0 секунд -->
    <meta http-equiv="refresh" content="0;url=${finalUrl}">
    <title>Перенаправление...</title>
    <script>
        // Мгновенный редирект через JavaScript
        window.location.replace('${finalUrl}');
    </script>
</head>
<body style="margin: 0; padding: 0; background: ${status === 'success' ? '#43e97b' : '#f5576c'};">
    <!-- Если JavaScript отключен, сработает meta refresh -->
    <!-- Если и он не сработает, есть ссылка -->
    <div style="display: flex; align-items: center; justify-content: center; height: 100vh; font-family: sans-serif;">
        <div style="text-align: center; color: white;">
            <h2>Перенаправление...</h2>
            <p>Если вы не были перенаправлены автоматически:</p>
            <a href="${finalUrl}" style="color: white; font-size: 18px;">Нажмите здесь</a>
        </div>
    </div>
</body>
</html>
    `);
  } catch (error) {
    console.error('Redirect error:', error);
    // При ошибке делаем простой редирект как запасной вариант
    if (status === 'success') {
      res.redirect(`https://app.sevkorzina.ru/#/payment-checking?orderId=${orderId}`);
    } else {
      res.redirect(`https://app.sevkorzina.ru/#/payment-failed?orderId=${orderId}`);
    }
  }
});
module.exports = router;
