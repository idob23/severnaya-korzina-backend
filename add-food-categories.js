const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const newCategories = [
  { name: 'Сухофрукты и орехи', description: 'Сухофрукты, орехи, семена' },
  { name: 'Мёд', description: 'Мёд и продукты пчеловодства' },
  { name: 'Соль, сахар, мука', description: 'Основные продукты для готовки' },
  { name: 'Приправы и быстрое питание', description: 'Приправы, супы, лапша быстрого приготовления' },
  { name: 'Сосиски и сардельки', description: 'Сосиски, сардельки замороженные' },
  { name: 'Овощи и грибы замороженные', description: 'Овощи и грибы фасованные замороженные' },
  { name: 'Ягоды и фрукты замороженные', description: 'Ягоды и фрукты весовые и фасованные замороженные' },
];

async function addCategories() {
  console.log('🏷️ Добавление пищевых категорий...\n');
  
  const createdIds = {};
  
  for (const cat of newCategories) {
    try {
      const existing = await prisma.category.findFirst({
        where: { name: cat.name }
      });
      
      if (existing) {
        console.log(`⏭️ Пропущена: "${cat.name}" (ID: ${existing.id})`);
        createdIds[cat.name] = existing.id;
        continue;
      }
      
      const created = await prisma.category.create({
        data: cat
      });
      
      console.log(`✅ Создана: "${cat.name}" (ID: ${created.id})`);
      createdIds[cat.name] = created.id;
    } catch (e) {
      console.error(`❌ Ошибка: ${cat.name} - ${e.message}`);
    }
  }
  
  console.log('\n📋 ID созданных категорий:');
  console.log(JSON.stringify(createdIds, null, 2));
  
  await prisma.$disconnect();
  console.log('\n✅ Готово! Скопируй ID для следующего шага.');
}

addCategories();
