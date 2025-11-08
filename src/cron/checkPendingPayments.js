// src/cron/checkPendingPayments.js
// Cron для проверки "зависших" платежей

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const TochkaPaymentService = require('../services/tochkaPaymentService');
const { updateBatchStatistics } = require('../utils/batchCalculations');

const tochkaService = new TochkaPaymentService();

/**
 * Проверяет платежи старше N минут в статусе CREATED/PENDING
 * и обновляет их статус через API Точка Банк
 */
async function checkPendingPayments() {
  const startTime = Date.now();
  console.log('\n🔍 ========================================');
  console.log('🔍 CRON: Проверка зависших платежей');
  console.log('🔍 ========================================');
  console.log(`🕐 Время запуска: ${new Date().toLocaleString('ru-RU')}`);

  try {
    // Находим платежи старше 1 минут в статусах CREATED или PENDING
    const fiveMinutesAgo = new Date(Date.now() - 1 * 60 * 1000);
    
    const pendingPayments = await prisma.payment.findMany({
      where: {
        status: {
          in: ['CREATED', 'PENDING']
        },
        createdAt: {
          lt: fiveMinutesAgo
        }
      },
      include: {
        order: {
          include: {
            batch: true
          }
        }
      },
      orderBy: {
        createdAt: 'asc'
      }
    });

    console.log(`📊 Найдено платежей для проверки: ${pendingPayments.length}`);

    if (pendingPayments.length === 0) {
      console.log('✅ Все платежи актуальны, проверка не требуется');
      console.log(`⏱️  Время выполнения: ${Date.now() - startTime}ms`);
      console.log('🔍 ========================================\n');
      return {
        success: true,
        checked: 0,
        updated: 0,
        failed: 0
      };
    }

    let updatedCount = 0;
    let failedCount = 0;

    // Проверяем каждый платёж
    for (const payment of pendingPayments) {
      try {
        console.log(`\n💳 Проверка платежа: ${payment.paymentId}`);
        console.log(`   Заказ: #${payment.orderId}`);
        console.log(`   Текущий статус: ${payment.status}`);
        console.log(`   Создан: ${payment.createdAt.toLocaleString('ru-RU')}`);

        // Запрашиваем актуальный статус у Точка Банк
        const actualStatus = await tochkaService.checkPaymentStatus(payment.paymentId);
        
        console.log(`   Актуальный статус: ${actualStatus.status}`);

        // Если статус изменился - обновляем
        if (actualStatus.status !== payment.status) {
          console.log(`   🔄 Статус изменился: ${payment.status} → ${actualStatus.status}`);

          // Обновляем запись платежа
          await prisma.payment.update({
            where: { paymentId: payment.paymentId },
            data: {
              status: actualStatus.status,
              paidAt: actualStatus.isPaid ? new Date() : null,
              metadata: JSON.stringify({
                ...JSON.parse(payment.metadata || '{}'),
                cronUpdatedAt: new Date().toISOString(),
                previousStatus: payment.status
              })
            }
          });

          console.log(`   ✅ Платёж обновлён в БД`);

          // Если платёж успешен - обновляем заказ
          if (actualStatus.isPaid) {
            console.log(`   💰 Платёж успешен! Обновляем заказ...`);
            
            await prisma.order.update({
              where: { id: payment.orderId },
              data: { 
                status: 'paid',
                updatedAt: new Date()
              }
            });

            console.log(`   ✅ Заказ #${payment.orderId} обновлён → status: paid`);

            // Обновляем статистику партии
            if (payment.order.batchId) {
              console.log(`   📊 Обновляем статистику партии #${payment.order.batchId}...`);
              
              try {
                await updateBatchStatistics(payment.order.batchId);
                console.log(`   ✅ Статистика партии обновлена`);
              } catch (batchError) {
                console.error(`   ⚠️ Ошибка обновления партии:`, batchError.message);
              }
            }
          }

          // Если платёж отклонён - отменяем заказ
          if (actualStatus.status === 'FAILED' || actualStatus.status === 'REJECTED') {
            console.log(`   ❌ Платёж отклонён! Отменяем заказ...`);
            
            await prisma.order.update({
              where: { id: payment.orderId },
              data: { 
                status: 'cancelled',
                updatedAt: new Date()
              }
            });

            console.log(`   ✅ Заказ #${payment.orderId} отменён`);

            // Обновляем статистику партии (уменьшаем сумму)
            if (payment.order.batchId) {
              console.log(`   📊 Обновляем статистику партии #${payment.order.batchId}...`);
              
              try {
                await updateBatchStatistics(payment.order.batchId);
                console.log(`   ✅ Статистика партии обновлена`);
              } catch (batchError) {
                console.error(`   ⚠️ Ошибка обновления партии:`, batchError.message);
              }
            }
          }

          updatedCount++;
        } else {
          console.log(`   ⏸️  Статус не изменился, пропускаем`);
        }

      } catch (error) {
        console.error(`   ❌ Ошибка проверки платежа ${payment.paymentId}:`, error.message);
        failedCount++;
      }
    }

    const duration = Date.now() - startTime;
    
    console.log('\n📊 ========================================');
    console.log('📊 ИТОГИ ПРОВЕРКИ:');
    console.log('📊 ========================================');
    console.log(`✅ Проверено: ${pendingPayments.length}`);
    console.log(`🔄 Обновлено: ${updatedCount}`);
    console.log(`❌ Ошибок: ${failedCount}`);
    console.log(`⏱️  Время выполнения: ${duration}ms`);
    console.log('🔍 ========================================\n');

// ШАГ: Удаляем заказы в статусе pending старше 10 минут БЕЗ успешных платежей
console.log('\n🗑️ Проверка просроченных заказов...');
const tenMinutesAgo = new Date(Date.now() - 10 * 60 * 1000);

const expiredOrders = await prisma.order.findMany({
  where: {
    status: 'pending',
    createdAt: {
      lt: tenMinutesAgo
    }
  },
  include: {
    payments: true
  }
});

console.log(`📊 Найдено заказов в pending старше 10 минут: ${expiredOrders.length}`);

let deletedCount = 0;
for (const order of expiredOrders) {
  try {
    // ✅ КЛЮЧЕВАЯ ЛОГИКА: Проверяем, нет ли УСПЕШНОГО платежа
    const hasSuccessfulPayment = order.payments.some(p => 
      p.status === 'APPROVED' // Только если платёж успешен - не трогаем
    );
    
    if (hasSuccessfulPayment) {
      console.log(`   ⏭️ Заказ #${order.id} ПРОПУСКАЕМ - платёж успешен (но заказ почему-то pending)`);
      // Это аномалия - успешный платёж должен был перевести заказ в 'paid'
      // Но для безопасности НЕ удаляем такие заказы
      continue;
    }

    // Если есть платежи в CREATED/PENDING - это значит пользователь начал оплату
    // Но прошло 10 минут и ничего не произошло - можно удалять
    const hasPendingPayment = order.payments.some(p => 
      p.status === 'CREATED' || p.status === 'PENDING'
    );
    
    if (hasPendingPayment) {
      console.log(`   🕐 Заказ #${order.id} - платёж завис, удаляем заказ`);
    } else {
      console.log(`   🕐 Заказ #${order.id} - без платежей, удаляем заказ`);
    }

    // Удаляем заказ (payments удалятся автоматически благодаря CASCADE)
    await prisma.$transaction(async (tx) => {
      // OrderItems удаляются автоматически (CASCADE в schema)
      await tx.order.delete({
        where: { id: order.id }
      });
    });

    console.log(`   ✅ Заказ #${order.id} удалён (просрочен)`);
    deletedCount++;
    
  } catch (error) {
    console.error(`   ❌ Ошибка удаления заказа #${order.id}:`, error.message);
  }
}

console.log(`\n✅ Удалено просроченных заказов: ${deletedCount}`);

    return {
      success: true,
      checked: pendingPayments.length,
      updated: updatedCount,
      failed: failedCount,
      duration
    };

  } catch (error) {
    console.error('❌ Критическая ошибка в cron:', error);
    console.error('Stack:', error.stack);
    
    return {
      success: false,
      error: error.message
    };
  }
}

// Если запускается напрямую
if (require.main === module) {
  console.log('🚀 Запуск cron задачи вручную...\n');
  
  checkPendingPayments()
    .then((result) => {
      console.log('\n✅ Задача выполнена:', result);
      process.exit(0);
    })
    .catch((error) => {
      console.error('\n❌ Ошибка выполнения:', error);
      process.exit(1);
    });
}

module.exports = { checkPendingPayments };
