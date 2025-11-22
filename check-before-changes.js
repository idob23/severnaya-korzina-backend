// check-before-changes.js
// БЕЗОПАСНЫЙ скрипт - только ЧИТАЕТ данные, ничего не меняет

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  try {
    console.log('🔍 ПРОВЕРКА ТЕКУЩЕГО СОСТОЯНИЯ БД (только чтение, ничего не меняем)\n');
    console.log('='.repeat(70));

    // 1. Проверяем существующие категории
    console.log('\n📋 Существующие категории:');
    const categories = await prisma.category.findMany({
      orderBy: { id: 'desc' },
      take: 10
    });
    
    categories.forEach(cat => {
      console.log(`   ID ${cat.id}: "${cat.name}"`);
    });

    // 2. Проверяем, есть ли уже нужные категории
    console.log('\n🔍 Проверка наличия новых категорий:');
    
    const hoztovary = await prisma.category.findFirst({
      where: { name: 'Хоз. товары' }
    });
    console.log(`   "Хоз. товары": ${hoztovary ? `✅ СУЩЕСТВУЕТ (ID: ${hoztovary.id})` : '❌ НЕ НАЙДЕНА - нужно создать'}`);
    
    const sushi = await prisma.category.findFirst({
      where: { name: 'Для суши' }
    });
    console.log(`   "Для суши": ${sushi ? `✅ СУЩЕСТВУЕТ (ID: ${sushi.id})` : '❌ НЕ НАЙДЕНА - нужно создать'}`);

    // 3. Проверяем существующие маппинги для категорий из прайса
    console.log('\n📊 Текущие маппинги для категорий поставщика:');
    
    const categoriesToCheck = [
      'БЫТОВАЯ ХИМИЯ И ХОЗ ТОВАРЫ (C)',
      '- Продукция для приготовления суши и ролл (A)',
      '- Икра замороженная для суши'
    ];
    
    for (const cat of categoriesToCheck) {
      const mapping = await prisma.supplierCategoryMapping.findUnique({
        where: { supplierCategory: cat },
        include: {
          targetCategory: {
            select: { id: true, name: true }
          }
        }
      });
      
      if (mapping) {
        console.log(`   "${cat}"`);
        console.log(`      → ID ${mapping.targetCategoryId}: "${mapping.targetCategory.name}"`);
      } else {
        console.log(`   "${cat}"`);
        console.log(`      → ❌ НЕТ МАППИНГА`);
      }
    }

    // 4. Считаем товары которые затронуты
    console.log('\n📦 Товары с категориями поставщика (которые будут затронуты):');
    
    const products = await prisma.product.findMany({
      where: {
        supplierCategory: {
          in: categoriesToCheck
        },
        isActive: true
      },
      select: {
        id: true,
        name: true,
        supplierCategory: true,
        categoryId: true
      }
    });
    
    console.log(`   Найдено товаров: ${products.length}`);
    if (products.length > 0 && products.length <= 10) {
      products.forEach(p => {
        console.log(`      - ${p.name} (ID: ${p.id}, текущая категория: ${p.categoryId})`);
      });
    }

    // 5. Итоговая сводка
    console.log('\n' + '='.repeat(70));
    console.log('📝 ИТОГОВАЯ СВОДКА:');
    console.log('');
    console.log('Что НУЖНО сделать:');
    
    if (!hoztovary) {
      console.log('   ✅ Создать категорию "Хоз. товары"');
    }
    if (!sushi) {
      console.log('   ✅ Создать категорию "Для суши"');
    }
    
    const hozMapping = await prisma.supplierCategoryMapping.findUnique({
      where: { supplierCategory: 'БЫТОВАЯ ХИМИЯ И ХОЗ ТОВАРЫ (C)' }
    });
    if (!hozMapping) {
      console.log('   ✅ Добавить маппинг: "БЫТОВАЯ ХИМИЯ И ХОЗ ТОВАРЫ (C)" → "Хоз. товары"');
    }
    
    const ikraMapping = await prisma.supplierCategoryMapping.findUnique({
      where: { supplierCategory: '- Икра замороженная для суши' }
    });
    if (!ikraMapping) {
      console.log('   ✅ Добавить маппинг: "- Икра замороженная для суши" → "Для суши"');
    }
    
    const sushiMapping = await prisma.supplierCategoryMapping.findUnique({
      where: { supplierCategory: '- Продукция для приготовления суши и ролл (A)' }
    });
    if (sushiMapping) {
      console.log(`   ✅ Обновить маппинг: "- Продукция для приготовления суши и ролл (A)" с ID ${sushiMapping.targetCategoryId} → "Для суши"`);
    }

    console.log('\n⚠️  ВАЖНО: Это только ПРОВЕРКА. Никакие данные НЕ изменены!');
    console.log('');

  } catch (error) {
    console.error('\n❌ Ошибка:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
