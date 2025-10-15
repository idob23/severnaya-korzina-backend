const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function checkData() {
  try {
    const productsCount = await prisma.product.count();
    const categoriesCount = await prisma.category.count();
    const batchesCount = await prisma.batch.count();
    const usersCount = await prisma.user.count();
    const ordersCount = await prisma.order.count();

    console.log('📊 Данные в базе:');
    console.log(`  Товары: ${productsCount}`);
    console.log(`  Категории: ${categoriesCount}`);
    console.log(`  Партии: ${batchesCount}`);
    console.log(`  Пользователи: ${usersCount}`);
    console.log(`  Заказы: ${ordersCount}`);

    if (productsCount > 0) {
      console.log('\n📦 Первые 5 товаров:');
      const products = await prisma.product.findMany({
        take: 5,
        include: { category: true }
      });
      products.forEach(p => {
        console.log(`  - ${p.name} (${p.price}₽) - ${p.category.name}`);
      });
    }

    await prisma.$disconnect();
  } catch (error) {
    console.error('❌ Ошибка:', error.message);
    process.exit(1);
  }
}

checkData();
