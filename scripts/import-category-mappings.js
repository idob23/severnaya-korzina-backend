// scripts/import-category-mappings.js
// Импортирует первичный маппинг категорий в БД

const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

async function importMappings() {
  try {
    console.log('📊 Импорт маппинга категорий...\n');

    // Загружаем JSON с маппингом
    const mappingPath = path.join(__dirname, '../category_mapping_final.json');
    
    if (!fs.existsSync(mappingPath)) {
      console.error('❌ Файл category_mapping_final.json не найден!');
      console.log('   Путь:', mappingPath);
      process.exit(1);
    }

    const mappings = JSON.parse(fs.readFileSync(mappingPath, 'utf-8'));
    console.log(`📋 Загружено ${mappings.length} маппингов из файла\n`);

    const stats = {
      created: 0,
      updated: 0,
      skipped: 0,
      errors: []
    };

    // Импортируем каждый маппинг
    for (const mapping of mappings) {
      try {
        // Используем upsert для создания или обновления
        const result = await prisma.supplierCategoryMapping.upsert({
          where: { supplierCategory: mapping.supplierCategory },
          create: {
            supplierCategory: mapping.supplierCategory,
            targetCategoryId: mapping.targetCategoryId,
            confidence: mapping.confidence || 'manual'
          },
          update: {
            targetCategoryId: mapping.targetCategoryId,
            confidence: mapping.confidence || 'manual'
          }
        });

        // Проверяем, был ли это create или update
        const isNew = result.createdAt.getTime() === result.updatedAt.getTime();
        if (isNew) {
          stats.created++;
        } else {
          stats.updated++;
        }

        // Прогресс каждые 20 записей
        if ((stats.created + stats.updated) % 20 === 0) {
          console.log(`   Обработано: ${stats.created + stats.updated}/${mappings.length}`);
        }

      } catch (error) {
        stats.errors.push({
          supplierCategory: mapping.supplierCategory,
          error: error.message
        });
        stats.skipped++;
      }
    }

    // Итоговая статистика
    console.log('\n' + '='.repeat(60));
    console.log('✅ Импорт завершён!\n');
    console.log(`📊 Статистика:`);
    console.log(`   Создано новых:  ${stats.created}`);
    console.log(`   Обновлено:      ${stats.updated}`);
    console.log(`   Пропущено:      ${stats.skipped}`);
    console.log(`   Ошибок:         ${stats.errors.length}`);

    if (stats.errors.length > 0) {
      console.log('\n⚠️  Ошибки:');
      stats.errors.forEach(err => {
        console.log(`   - ${err.supplierCategory}: ${err.error}`);
      });
    }

    // Проверяем итоговое количество в БД
    const totalInDb = await prisma.supplierCategoryMapping.count();
    console.log(`\n📦 Всего маппингов в БД: ${totalInDb}`);

    // Статистика по целевым категориям
    const byCategory = await prisma.supplierCategoryMapping.groupBy({
      by: ['targetCategoryId'],
      _count: true
    });

    console.log('\n📋 Распределение по категориям:');
    for (const stat of byCategory) {
      const category = await prisma.category.findUnique({
        where: { id: stat.targetCategoryId },
        select: { name: true }
      });
      console.log(`   ${category?.name || 'Unknown'}: ${stat._count}`);
    }

    await prisma.$disconnect();
    console.log('\n✅ Готово!');

  } catch (error) {
    console.error('❌ Критическая ошибка импорта:', error);
    await prisma.$disconnect();
    process.exit(1);
  }
}

// Запускаем импорт
importMappings();
