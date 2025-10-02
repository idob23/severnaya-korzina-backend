// check-webhook-status.js - Проверка конфигурации webhook
// Запуск: node check-webhook-status.js

require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const axios = require('axios');

const TOCHKA_API_URL = process.env.TOCHKA_API_URL || 'https://enter.tochka.com/uapi';
const JWT_TOKEN = process.env.TOCHKA_JWT_TOKEN;

async function checkWebhookStatus() {
  console.log('🔍 ========================================');
  console.log('🔍 ДИАГНОСТИКА WEBHOOK');
  console.log('🔍 ========================================\n');

  // 1. Проверяем webhook в Точка Банк
  console.log('📋 Шаг 1: Проверяем webhook в Точка Банк...\n');
  
  try {
    const response = await axios.get(`${TOCHKA_API_URL}/webhook/v1.0/list`, {
      headers: {
        'Authorization': `Bearer ${JWT_TOKEN}`,
        'Content-Type': 'application/json'
      }
    });

    console.log('✅ Список webhooks получен:');
    console.log(JSON.stringify(response.data, null, 2));
    console.log('');

    const webhooks = response.data.Data?.webhooks || [];
    const paymentWebhook = webhooks.find(w => 
      w.events.includes('acquiringInternetPayment')
    );

    if (paymentWebhook) {
      console.log('✅ Webhook для платежей найден:');
      console.log(`   URL: ${paymentWebhook.url}`);
      console.log(`   Events: ${paymentWebhook.events.join(', ')}`);
      console.log(`   Status: ${paymentWebhook.status || 'ACTIVE'}`);
      console.log('');
    } else {
      console.log('❌ Webhook для платежей НЕ НАЙДЕН!');
      console.log('   Необходимо настроить webhook командой:');
      console.log('   node setup-tochka-webhook.js');
      console.log('');
    }
  } catch (error) {
    console.error('❌ Ошибка получения списка webhooks:');
    console.error(error.response?.data || error.message);
    console.log('');
  }

  // 2. Проверяем последние платежи в БД
  console.log('📋 Шаг 2: Проверяем последние платежи в БД...\n');

  try {
    const payments = await prisma.payment.findMany({
      take: 5,
      orderBy: { createdAt: 'desc' },
      include: {
        order: {
          select: {
            id: true,
            status: true,
            totalAmount: true,
            userId: true
          }
        }
      }
    });

    if (payments.length === 0) {
      console.log('⚠️ Платежей в БД не найдено');
      console.log('');
    } else {
      console.log(`✅ Найдено платежей: ${payments.length}\n`);
      
      payments.forEach((payment, index) => {
        console.log(`${index + 1}. Payment ID: ${payment.paymentId}`);
        console.log(`   Order ID: ${payment.orderId}`);
        console.log(`   Payment Status: ${payment.status}`);
        console.log(`   Order Status: ${payment.order.status}`);
        console.log(`   Amount: ${payment.amount} ₽`);
        console.log(`   Created: ${payment.createdAt.toISOString()}`);
        console.log(`   Paid At: ${payment.paidAt ? payment.paidAt.toISOString() : 'NOT PAID'}`);
        
        // Проверяем несоответствие статусов
        if (payment.status === 'APPROVED' && payment.order.status !== 'paid') {
          console.log(`   ⚠️ НЕСООТВЕТСТВИЕ: Платеж APPROVED, но заказ ${payment.order.status}`);
        }
        
        console.log('');
      });
    }
  } catch (error) {
    console.error('❌ Ошибка получения платежей из БД:');
    console.error(error.message);
    console.log('');
  }

  // 3. Проверяем заказы в статусе pending с платежами
  console.log('📋 Шаг 3: Ищем зависшие заказы...\n');

  try {
    const pendingOrders = await prisma.order.findMany({
      where: {
        status: 'pending',
        createdAt: {
          lt: new Date(Date.now() - 5 * 60 * 1000) // старше 5 минут
        }
      },
      take: 10,
      orderBy: { createdAt: 'desc' },
      include: {
        payments: true,
        user: {
          select: {
            id: true,
            phone: true,
            firstName: true
          }
        }
      }
    });

    if (pendingOrders.length === 0) {
      console.log('✅ Зависших заказов не найдено');
      console.log('');
    } else {
      console.log(`⚠️ Найдено зависших заказов: ${pendingOrders.length}\n`);
      
      for (const order of pendingOrders) {
        console.log(`Order #${order.id}:`);
        console.log(`   Status: ${order.status}`);
        console.log(`   User: ${order.user.firstName} (${order.user.phone})`);
        console.log(`   Amount: ${order.totalAmount} ₽`);
        console.log(`   Created: ${order.createdAt.toISOString()}`);
        console.log(`   Age: ${Math.round((Date.now() - order.createdAt.getTime()) / 60000)} минут`);
        
        if (order.payments.length > 0) {
          const payment = order.payments[0];
          console.log(`   Payment ID: ${payment.paymentId}`);
          console.log(`   Payment Status: ${payment.status}`);
          
          // Проверяем реальный статус в Точка Банк
          console.log(`   🔍 Проверяем статус в Точка Банк...`);
          
          try {
            const statusResponse = await axios.get(
              `${TOCHKA_API_URL}/acquiring/v1.0/payments/${payment.paymentId}`,
              {
                headers: {
                  'Authorization': `Bearer ${JWT_TOKEN}`,
                  'Content-Type': 'application/json'
                },
                params: {
                  customerCode: process.env.TOCHKA_CUSTOMER_CODE
                }
              }
            );

            const operation = statusResponse.data.Data?.Operation?.[0];
            if (operation) {
              const actualStatus = operation.status;
              console.log(`   ✅ Реальный статус в банке: ${actualStatus}`);
              
              if (actualStatus === 'APPROVED' && payment.status !== 'APPROVED') {
                console.log(`   🔧 НАЙДЕНА ПРОБЛЕМА: Платеж оплачен в банке, но не обновлен в БД!`);
                console.log(`   💡 Рекомендация: Запустить cron или обновить вручную`);
              }
            }
          } catch (apiError) {
            console.log(`   ❌ Ошибка проверки в банке: ${apiError.message}`);
          }
        } else {
          console.log(`   ⚠️ Платежей не найдено`);
        }
        
        console.log('');
      }
    }
  } catch (error) {
    console.error('❌ Ошибка поиска зависших заказов:');
    console.error(error.message);
    console.log('');
  }

  // 4. Рекомендации
  console.log('📋 Рекомендации:\n');
  
  console.log('1. Проверьте логи backend:');
  console.log('   sudo journalctl -u severnaya-korzina -f\n');
  
  console.log('2. Проверьте что webhook настроен:');
  console.log('   node setup-tochka-webhook.js\n');
  
  console.log('3. Если есть зависшие заказы - запустите cron:');
  console.log('   node src/cron/checkPendingPayments.js\n');
  
  console.log('4. Проверьте доступность webhook URL:');
  console.log('   curl -X POST https://app.sevkorzina.ru/api/payments/webhook \\\n');
  console.log('        -H "Content-Type: application/json" \\\n');
  console.log('        -d \'{"event": "test"}\'');
  console.log('');

  console.log('🔍 ========================================');
  console.log('🔍 ДИАГНОСТИКА ЗАВЕРШЕНА');
  console.log('🔍 ========================================');
}

// Запуск
checkWebhookStatus()
  .then(() => process.exit(0))
  .catch(err => {
    console.error('Критическая ошибка:', err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
