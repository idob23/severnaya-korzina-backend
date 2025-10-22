require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function check() {
  const order = await prisma.order.findUnique({
    where: { id: 386 },
    include: {
      user: { select: { phone: true, firstName: true } },
      payments: true,
      orderItems: {
        include: { product: { select: { name: true } } }
      }
    }
  });
  
  if (!order) {
    console.log('❌ Заказ #386 НЕ НАЙДЕН в БД (был удален?)');
  } else {
    console.log('✅ Заказ #386 НАЙДЕН:');
    console.log(`   User: ${order.user.firstName} (${order.user.phone})`);
    console.log(`   Status: ${order.status}`);
    console.log(`   Amount: ${order.totalAmount}₽`);
    console.log(`   Created: ${order.createdAt}`);
    console.log(`   Payments: ${order.payments.length}`);
    if (order.payments[0]) {
      console.log(`   Payment ID: ${order.payments[0].paymentId}`);
      console.log(`   Payment Status: ${order.payments[0].status}`);
    }
  }
  
  await prisma.$disconnect();
}
check();
