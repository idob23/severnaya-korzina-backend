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
      notes,
      platform
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
items: items || [],
platform: platform || 'web'
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
    
if (status === 'success') {
  res.send(`
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Оплата успешна</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            background: linear-gradient(135deg, #43e97b 0%, #38d375 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 16px;
        }
        .container {
            background: white;
            border-radius: 16px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            animation: slideIn 0.4s ease-out;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .icon {
            width: 80px;
            height: 80px;
            background: #43e97b;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }
        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }
        .checkmark {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: block;
            stroke-width: 3;
            stroke: #fff;
            stroke-miterlimit: 10;
            box-shadow: inset 0px 0px 0px #43e97b;
            animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s both;
            position: relative;
        }
        .checkmark:after {
            content: '';
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%) rotate(45deg);
            width: 12px;
            height: 24px;
            border: solid white;
            border-width: 0 4px 4px 0;
        }
        h1 {
            color: #43e97b;
            font-size: clamp(24px, 5vw, 28px);
            margin-bottom: 12px;
            font-weight: 700;
        }
        p {
            color: #718096;
            font-size: clamp(15px, 3vw, 17px);
            line-height: 1.5;
            margin-bottom: 10px;
        }
        .order-info {
            background: #f7fafc;
            border-radius: 12px;
            padding: 20px;
            margin: 24px 0;
        }
        .order-info p {
            margin: 0;
            color: #2d3748;
        }
        .order-number {
            font-weight: 700;
            color: #43e97b;
            font-size: clamp(18px, 4vw, 22px);
        }
        .back-btn {
            display: inline-block;
            background: #43e97b;
            color: white;
            padding: 16px 40px;
            border-radius: 12px;
            font-size: clamp(16px, 3.5vw, 18px);
            font-weight: 600;
            border: none;
            cursor: pointer;
            margin-top: 24px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .back-btn:hover {
            background: #38d375;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 233, 123, 0.4);
        }
        .back-btn:active {
            transform: translateY(0);
        }
        .instruction {
            margin-top: 20px;
            padding: 16px;
            background: #fff3cd;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
        }
        .instruction p {
            color: #856404;
            font-size: 14px;
            margin: 0;
        }
        @media (max-width: 400px) {
            .container {
                padding: 30px 20px;
            }
            .icon {
                width: 70px;
                height: 70px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">
            <div class="checkmark"></div>
        </div>
        <h1>Оплата успешна!</h1>
        <p>Ваш платёж успешно обработан</p>
        
        <div class="order-info">
            <p>Заказ <span class="order-number">#${orderId}</span></p>
            <p>принят в обработку</p>
        </div>
        
        <p>Вы получите уведомление о готовности заказа</p>
        
        <div class="instruction">
            <p>📱 <strong>Вернитесь в приложение</strong> - статус заказа обновится автоматически</p>
        </div>
    </div>
</body>
</html>
  `);
}

 else {
      // Для failed показываем адаптивную страницу с кнопкой
      res.send(`
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ошибка оплаты</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            background: linear-gradient(135deg, #f5576c 0%, #e53e3e 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 16px;
        }
        .container {
            background: white;
            border-radius: 16px;
            padding: 32px 24px;
            text-align: center;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            animation: slideIn 0.4s ease-out;
        }
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .icon {
            width: 80px;
            height: 80px;
            background: #f5576c;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            color: white;
            font-size: 50px;
            font-weight: bold;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }
        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }
        h1 {
            color: #2d3748;
            font-size: clamp(24px, 5vw, 28px);
            margin-bottom: 12px;
            font-weight: 700;
        }
        p {
            color: #718096;
            font-size: clamp(15px, 3vw, 17px);
            line-height: 1.5;
            margin-bottom: 10px;
        }
        .close-btn {
            display: inline-block;
            background: #f5576c;
            color: white;
            padding: 14px 32px;
            border-radius: 10px;
            font-size: clamp(16px, 3.5vw, 18px);
            font-weight: 600;
            border: none;
            cursor: pointer;
            margin-top: 24px;
            transition: all 0.3s ease;
        }
        .close-btn:hover {
            background: #e53e3e;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 87, 108, 0.4);
        }
        .close-btn:active {
            transform: translateY(0);
        }
        
        /* Адаптив для маленьких экранов */
        @media (max-width: 400px) {
            .container {
                padding: 24px 16px;
            }
            .icon {
                width: 70px;
                height: 70px;
                font-size: 45px;
            }
            .close-btn {
                padding: 12px 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">✕</div>
        <h1>Ошибка оплаты</h1>
        <p>Платёж не был завершён</p>
        <p>Попробуйте оформить заказ заново</p>
        
        <button class="close-btn" onclick="closeWindow()">Закрыть окно</button>
    </div>
    
    <script>
        function closeWindow() {
            try {
                window.close();
            } catch(e) {
                console.log('Не удалось закрыть окно через JS');
            }
            
            setTimeout(() => {
                if (!window.closed) {
                    window.open('', '_self').close();
                }
            }, 100);
            
            setTimeout(() => {
                if (!window.closed) {
                    alert('Пожалуйста, закройте это окно вручную (Alt+F4 или крестик)');
                }
            }, 500);
        }
        
        setTimeout(() => {
            closeWindow();
        }, 5000);
    </script>
</body>
</html>
      `);
    }
  } catch (error) {
    console.error('Redirect error:', error);
    res.send(`
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ошибка</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 20px;
            text-align: center;
            background: #f7fafc;
        }
        .container {
            max-width: 400px;
        }
        h1 {
            color: #2d3748;
            font-size: clamp(20px, 4vw, 24px);
            margin-bottom: 12px;
        }
        p {
            color: #718096;
            font-size: clamp(14px, 3vw, 16px);
            margin-bottom: 20px;
        }
        button {
            background: #4299e1;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Произошла ошибка</h1>
        <p>Пожалуйста, закройте это окно и проверьте статус заказа в приложении</p>
        <button onclick="window.close()">Закрыть окно</button>
    </div>
</body>
</html>
    `);
  }
});

module.exports = router;
