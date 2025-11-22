// add-new-categories-and-mappings.js
// Скрипт для создания новых категорий и добавления маппингов

const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

async function main() {
  try {
    console.log('📋 Добавление новых категорий и обновление маппингов...\n');

    // 1. Создаём новые категории (или получаем существующие)
    let hoztovaryCategory = await prisma.category.findFirst({
      where: { name: 'Хоз. товары' }
    });
    
    if (!hoztovaryCategory) {
      hoztovaryCategory = await prisma.category.create({
        data: {
          name: 'Хоз. товары',
          description: 'Хозяйственные товары и бытовая химия',
          isActive: true
        }
      });
      console.log(`✅ Категория "Хоз. товары" создана с ID: ${hoztovaryCategory.id}`);
    } else {
      console.log(`✅ Категория "Хоз. товары" уже существует с ID: ${hoztovaryCategory.id}`);
    }

    let sushiCategory = await prisma.category.findFirst({
      where: { name: 'Для суши' }
    });
    
    if (!sushiCategory) {
      sushiCategory = await prisma.category.create({
        data: {
          name: 'Для суши',
          description: 'Продукты для приготовления суши и роллов',
          isActive: true
        }
      });
      console.log(`✅ Категория "Для суши" создана с ID: ${sushiCategory.id}\n`);
    } else {
      console.log(`✅ Категория "Для суши" уже существует с ID: ${sushiCategory.id}\n`);
    }

    // 2. Определяем новые маппинги
    const newMappings = [
      // Хоз. товары
      {
        supplierCategory: 'БЫТОВАЯ ХИМИЯ И ХОЗ ТОВАРЫ (C)',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Бытовая химия',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Бумага туалетная, салфетки, полотенца бумажные',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Для запекания',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Пакеты',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Перчатки.губки для посуды. халаты. чехлы для обуви',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Упаковка и одноразовая посуда',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Чистящие средства',
        targetCategoryId: hoztovaryCategory.id,
        targetCategoryName: 'Хоз. товары',
        confidence: 'manual'
      },
      // Для суши
      {
        supplierCategory: '- Продукция для приготовления суши и ролл (A)',
        targetCategoryId: sushiCategory.id,
        targetCategoryName: 'Для суши',
        confidence: 'manual'
      },
      {
        supplierCategory: '- Икра замороженная для суши',
        targetCategoryId: sushiCategory.id,
        targetCategoryName: 'Для суши',
        confidence: 'manual'
      }
    ];

    console.log(`📊 Добавление ${newMappings.length} новых маппингов в БД...\n`);

    // 3. Добавляем маппинги в БД
    let added = 0;
    let updated = 0;

    for (const mapping of newMappings) {
      const result = await prisma.supplierCategoryMapping.upsert({
        where: { supplierCategory: mapping.supplierCategory },
        update: {
          targetCategoryId: mapping.targetCategoryId,
          confidence: mapping.confidence
        },
        create: {
          supplierCategory: mapping.supplierCategory,
          targetCategoryId: mapping.targetCategoryId,
          confidence: mapping.confidence
        }
      });

      const isNew = result.createdAt.getTime() === result.updatedAt.getTime();
      if (isNew) {
        added++;
        console.log(`   ✅ Добавлен: "${mapping.supplierCategory}" → ${mapping.targetCategoryName}`);
      } else {
        updated++;
        console.log(`   🔄 Обновлён: "${mapping.supplierCategory}" → ${mapping.targetCategoryName}`);
      }
    }

    console.log(`\n${'='.repeat(70)}`);
    console.log(`✅ Готово!`);
    console.log(`   Создано маппингов: ${added}`);
    console.log(`   Обновлено маппингов: ${updated}`);

    // 4. Обновляем файл category_mapping_final.json
    console.log(`\n📝 Обновление файла category_mapping_final.json...`);
    
    const mappingFilePath = path.join(__dirname, 'category_mapping_final.json');
    
    let existingMappings = [];
    if (fs.existsSync(mappingFilePath)) {
      existingMappings = JSON.parse(fs.readFileSync(mappingFilePath, 'utf-8'));
      console.log(`   Загружено ${existingMappings.length} существующих маппингов`);
    }

    // Удаляем старые записи для этих категорий (если были)
    const categoriesToUpdate = newMappings.map(m => m.supplierCategory);
    existingMappings = existingMappings.filter(
      m => !categoriesToUpdate.includes(m.supplierCategory)
    );

    // Добавляем новые маппинги
    existingMappings.push(...newMappings);

    // Сортируем по supplierCategory для удобства
    existingMappings.sort((a, b) => 
      a.supplierCategory.localeCompare(b.supplierCategory)
    );

    // Сохраняем обновлённый файл
    fs.writeFileSync(
      mappingFilePath,
      JSON.stringify(existingMappings, null, 2),
      'utf-8'
    );

    console.log(`   ✅ Файл обновлён. Всего маппингов: ${existingMappings.length}`);

    // 5. Статистика
    console.log(`\n📊 Финальная статистика:`);
    
    const allMappings = await prisma.supplierCategoryMapping.findMany({
      include: {
        targetCategory: {
          select: { name: true }
        }
      }
    });

    const byCategory = {};
    for (const mapping of allMappings) {
      const catName = mapping.targetCategory.name;
      byCategory[catName] = (byCategory[catName] || 0) + 1;
    }

    console.log(`\nРаспределение по категориям:`);
    Object.entries(byCategory)
      .sort((a, b) => b[1] - a[1])
      .forEach(([cat, count]) => {
        const marker = (cat === 'Хоз. товары' || cat === 'Для суши') ? ' ⭐' : '';
        console.log(`   ${cat}: ${count}${marker}`);
      });

    console.log(`\n✅ Всё готово! Новые категории добавлены в маппинг.`);

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
