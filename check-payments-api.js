const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
  try {
    const count = await prisma.payment.count();
    console.log('✅ API может работать с таблицей payments');
    console.log(`📊 Количество платежей в БД: ${count}`);
    
    const orders = await prisma.order.count();
    console.log(`📦 Количество заказов в БД: ${orders}`);
    
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

check();
