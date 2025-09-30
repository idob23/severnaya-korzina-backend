// test-migration.js - Быстрый тест миграции
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function testMigration() {
  console.log('🧪 Тестирование миграции payments...\n');
  
  try {
    // Тест 1: Подключение к БД
    await prisma.$connect();
    console.log('✅ Подключение к БД успешно');
    
    // Тест 2: Проверка существования таблицы
    const count = await prisma.payment.count();
    console.log(`✅ Таблица payments доступна (записей: ${count})`);
    
    // Тест 3: Найдём первый заказ для теста
    const order = await prisma.order.findFirst();
    if (!order) {
      console.log('⚠️ Нет заказов для тестирования');
      return;
    }
    console.log(`✅ Используем заказ ID: ${order.id}`);
    
    // Тест 4: Создание тестового платежа
    const testPayment = await prisma.payment.create({
      data: {
        paymentId: `TEST_${Date.now()}`,
        orderId: order.id,
        provider: 'tochka',
        status: 'CREATED',
        amount: order.totalAmount
      }
    });
    console.log(`✅ Тестовый платёж создан: ID ${testPayment.id}`);
    
    // Тест 5: Чтение платежа с связью
    const readPayment = await prisma.payment.findUnique({
      where: { id: testPayment.id },
      include: { order: true }
    });
    console.log(`✅ Платёж прочитан, связь с заказом работает`);
    
    // Тест 6: Обновление статуса
    await prisma.payment.update({
      where: { id: testPayment.id },
      data: { status: 'APPROVED', paidAt: new Date() }
    });
    console.log(`✅ Статус платежа обновлён на APPROVED`);
    
    // Тест 7: Удаление тестового платежа
    await prisma.payment.delete({
      where: { id: testPayment.id }
    });
    console.log(`✅ Тестовый платёж удалён`);
    
    console.log('\n🎉 ВСЕ ТЕСТЫ ПРОЙДЕНЫ УСПЕШНО!');
    console.log('✅ Миграция работает корректно!');
    
  } catch (error) {
    console.error('\n❌ ОШИБКА:', error.message);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

testMigration();
