// check-order-440.js
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function checkOrder440() {
  console.log('🔍 Проверка заказа #440\n');
  
  try {
    // 1. Получаем заказ
    const order = await prisma.order.findUnique({
      where: { id: 440 },
      include: {
        orderItems: true
      }
    });
    
    if (!order) {
      console.log('❌ Заказ #440 не найден');
      return;
    }
    
    console.log(`✅ Заказ #440 найден:`);
    console.log(`   Статус: ${order.status}`);
    console.log(`   Сумма: ${order.totalAmount}₽`);
    console.log(`   Товаров в заказе: ${order.orderItems.length}\n`);
    
    // 2. Проверяем каждый товар
    for (const item of order.orderItems) {
      console.log(`📦 OrderItem #${item.id}:`);
      console.log(`   productId: ${item.productId}`);
      console.log(`   quantity: ${item.quantity}`);
      console.log(`   price: ${item.price}\n`);
      
      // 3. Проверяем есть ли товар в products
      const product = await prisma.product.findUnique({
        where: { id: item.productId }
      });
      
      if (product) {
        console.log(`   ✅ Товар ЕСТЬ в products: ${product.name}`);
      } else {
        console.log(`   ⚠️ Товар УДАЛЁН из products`);
        
        // 4. Проверяем есть ли в snapshots
        const snapshot = await prisma.$queryRaw`
          SELECT * FROM product_snapshots 
          WHERE product_id = ${item.productId}
          ORDER BY created_at DESC 
          LIMIT 1
        `;
        
        if (snapshot && snapshot.length > 0) {
          console.log(`   ✅ Найден в snapshots:`);
          console.log(`      snapshot id: ${snapshot[0].id}`);
          console.log(`      product_id: ${snapshot[0].product_id}`);
          console.log(`      name: ${snapshot[0].name}`);
          console.log(`      Тип product_id: ${typeof snapshot[0].product_id}`);
        } else {
          console.log(`   ❌ НЕТ в snapshots!`);
        }
      }
      console.log('---');
    }
    
    // 5. Проверяем все снапшоты
    console.log('\n📋 Все снапшоты в базе:');
    const allSnapshots = await prisma.$queryRaw`
      SELECT id, product_id, name, created_at 
      FROM product_snapshots 
      ORDER BY created_at DESC
    `;
    
    allSnapshots.forEach(s => {
      console.log(`  ID: ${s.id}, product_id: ${s.product_id} (${typeof s.product_id}), name: ${s.name}`);
    });
    
  } catch (error) {
    console.error('❌ Ошибка:', error);
  } finally {
    await prisma.$disconnect();
  }
}

checkOrder440();
