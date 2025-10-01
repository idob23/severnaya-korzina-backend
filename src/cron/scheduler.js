// src/cron/scheduler.js
// Планировщик cron задач

const cron = require('node-cron');
const { checkPendingPayments } = require('./checkPendingPayments');

// Хранилище активных задач
const activeTasks = new Map();

/**
 * Инициализация всех cron задач
 */
function initCronJobs() {
  console.log('🕐 ========================================');
  console.log('🕐 ИНИЦИАЛИЗАЦИЯ CRON ЗАДАЧ');
  console.log('🕐 ========================================\n');

  // Задача 1: Проверка зависших платежей каждые 3 минуты
  const paymentCheckTask = cron.schedule('*/3 * * * *', async () => {
    try {
      await checkPendingPayments();
    } catch (error) {
      console.error('❌ Ошибка в cron задаче проверки платежей:', error);
    }
  }, {
    scheduled: false, // Не запускать автоматически
    timezone: 'Asia/Yakutsk' // Якутское время
  });

  activeTasks.set('checkPendingPayments', paymentCheckTask);

  console.log('✅ Cron задача зарегистрирована: checkPendingPayments');
  console.log('   📅 Расписание: каждые 3 минуты');
  console.log('   🌍 Часовой пояс: Asia/Yakutsk\n');

  console.log('🕐 ========================================\n');

  return activeTasks;
}

/**
 * Запуск всех cron задач
 */
function startCronJobs() {
  console.log('▶️  Запуск всех cron задач...\n');
  
  let startedCount = 0;
  
  activeTasks.forEach((task, name) => {
    task.start();
    console.log(`✅ Запущена: ${name}`);
    startedCount++;
  });

  console.log(`\n✅ Запущено задач: ${startedCount}/${activeTasks.size}\n`);
}

/**
 * Остановка всех cron задач
 */
function stopCronJobs() {
  console.log('⏸️  Остановка всех cron задач...\n');
  
  let stoppedCount = 0;
  
  activeTasks.forEach((task, name) => {
    task.stop();
    console.log(`⏸️  Остановлена: ${name}`);
    stoppedCount++;
  });

  console.log(`\n⏸️  Остановлено задач: ${stoppedCount}/${activeTasks.size}\n`);
}

/**
 * Получение статуса всех задач
 */
function getCronStatus() {
  const status = [];
  
  activeTasks.forEach((task, name) => {
    status.push({
      name,
      running: task.running || false
    });
  });

  return status;
}

module.exports = {
  initCronJobs,
  startCronJobs,
  stopCronJobs,
  getCronStatus,
  activeTasks
};
