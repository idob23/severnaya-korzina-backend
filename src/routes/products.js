// src/routes/products.js
const express = require('express');
const { PrismaClient } = require('@prisma/client');

const router = express.Router();
const prisma = new PrismaClient();

async function getCurrentMargin() {
  try {
    const activeBatch = await prisma.batch.findFirst({
      where: { status: { in: ['active', 'collecting', 'ready'] } },
      select: { marginPercent: true }
    });
    if (activeBatch && activeBatch.marginPercent) {
      return parseFloat(activeBatch.marginPercent);
    }
    const setting = await prisma.systemSettings.findUnique({
      where: { key: 'default_margin_percent' }
    });
    return setting ? parseFloat(setting.value) : 15.0;
  } catch (error) {
    console.error('⚠️ Ошибка получения маржи:', error);
    return 15.0;
  }
}

// GET /api/products - Получить все товары
router.get('/', async (req, res) => {
  try {
    const { categoryId, search, page = 1, limit = 20 } = req.query;
    
    const where = {
      isActive: true,
      ...(categoryId && { categoryId: parseInt(categoryId) }),
    };

    // ✅ УЛУЧШЕННАЯ ЛОГИКА ПОИСКА
    if (search && search.trim().length > 0) {
      const searchTerm = search.trim();
      
      where.OR = [
        { name: { equals: searchTerm, mode: 'insensitive' } },
        { name: { startsWith: searchTerm, mode: 'insensitive' } },
        { name: { contains: searchTerm, mode: 'insensitive' } },
        { description: { contains: searchTerm, mode: 'insensitive' } },
        { 
          category: { 
            name: { contains: searchTerm, mode: 'insensitive' } 
          } 
        },
      ];
    }


    // ✅ КЛЮЧЕВОЕ ИЗМЕНЕНИЕ: При поиске берём ВСЕ результаты (или больше)
    const isSearch = search && search.trim().length > 0;
    const fetchLimit = isSearch ? 250 : parseInt(limit); // При поиске берём 250 товаров
    const fetchSkip = isSearch ? 0 : (parseInt(page) - 1) * parseInt(limit);

    // Получаем товары
    const products = await prisma.product.findMany({
      where,
      include: { category: true },
      orderBy: { name: 'asc' },
      skip: fetchSkip,
      take: fetchLimit
    });

    const total = await prisma.product.count({ where });

    // ✅ ДОБАВИТЬ ЭТО:
if (search && search.trim().toLowerCase() === 'шоколад') {
  console.log('📊 Всего найдено:', total);
  console.log('🗄️ Первые 5 товаров ИЗ БД (до sortByRelevance):');
  products.slice(0, 5).forEach((p, i) => {
    console.log(`  ${i+1}. ${p.name}`);
  });
}

    // Получаем маржу и добавляем finalPrice
    const marginPercent = await getCurrentMargin();
    let productsWithFinalPrice = products.map(product => ({
      ...product,
      price: parseFloat(product.price) * (1 + marginPercent / 100)
    }));

    // ✅ Применяем сортировку по релевантности
    if (isSearch) {
      productsWithFinalPrice = sortByRelevance(productsWithFinalPrice, search.trim());
      
      // ✅ ПАГИНАЦИЯ ПОСЛЕ СОРТИРОВКИ
      const startIndex = (parseInt(page) - 1) * parseInt(limit);
      const endIndex = startIndex + parseInt(limit);
      productsWithFinalPrice = productsWithFinalPrice.slice(startIndex, endIndex);
    }

    res.json({
      products: productsWithFinalPrice,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('Ошибка получения товаров:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// ✅ НОВАЯ ФУНКЦИЯ: Сортировка по релевантности

function sortByRelevance(products, query) {
  const lowerQuery = query.toLowerCase().trim();
  const queryWords = lowerQuery.split(/\s+/);

  console.log('🔍 Поиск:', lowerQuery);

  const productsWithScore = products.map(product => {
    const name = product.name.toLowerCase();
    const nameWords = name.split(/\s+/);
    const description = (product.description || '').toLowerCase();
    let score = 0;

    // 🔥 СУПЕРПРИОРИТЕТ: Первое слово названия = запросу (ТОЧНОЕ совпадение!)
    if (nameWords[0] === lowerQuery) {
      score += 100000;
      console.log('✅ 100k (первое слово точно):', product.name);
    }
    else if (queryWords.length > 0 && nameWords[0] === queryWords[0]) {
      score += 90000;
      console.log('✅ 90k (первое слово = первое слово запроса):', product.name);
    }
    // ❌ УБРАЛИ: else if (nameWords[0].startsWith(lowerQuery)) - это давало баллы "Шоколадница"
    else if (name.startsWith(lowerQuery + ' ')) {
      // Название начинается с запроса + пробел (точное начало)
      score += 80000;
      console.log('✅ 80k (начинается с запроса):', product.name);
    }
    else if (name === lowerQuery) {
      score += 70000;
    }
    else {
      // Ищем позицию ТОЧНОГО совпадения слова (не startsWith!)
      let earliestPosition = 999;
      
      for (const word of queryWords) {
        const position = nameWords.findIndex(w => w === word); // ← УБРАЛИ startsWith!
        if (position !== -1 && position < earliestPosition) {
          earliestPosition = position;
        }
      }
      
      if (earliestPosition === 1) score += 10000;
      else if (earliestPosition === 2) score += 8000;
      else if (earliestPosition === 3) score += 6000;
      else if (earliestPosition === 4) score += 4000;
      else if (earliestPosition < 10) score += 2000;
      else if (earliestPosition < 999) score += 1000;
      
      // Если точного совпадения нет, ищем вхождение через startsWith (но с меньшим приоритетом)
      if (earliestPosition === 999) {
        for (const word of queryWords) {
          const position = nameWords.findIndex(w => w.startsWith(word));
          if (position !== -1) {
            if (position === 0) score += 500; // Первое слово начинается
            else if (position === 1) score += 400;
            else score += 300;
            break;
          }
        }
      }
    }
    
    const matchedWordsCount = queryWords.filter(word => 
      nameWords.some(nameWord => nameWord.includes(word))
    ).length;
    
    if (matchedWordsCount === queryWords.length) score += 500;
    else if (matchedWordsCount > 0) score += matchedWordsCount * 100;
    
    if (name.includes(lowerQuery)) score += 200;
    if (description.includes(lowerQuery)) score += 50;

    return { product, score };
  });

  const sorted = productsWithScore
    .sort((a, b) => {
      if (b.score !== a.score) return b.score - a.score;
      return a.product.name.localeCompare(b.product.name, 'ru');
    });
  
  console.log('📊 Топ-5 результатов:');
  sorted.slice(0, 5).forEach((item, i) => {
    console.log(`${i+1}. [${item.score}] ${item.product.name}`);
  });

  return sorted.map(item => item.product);
}

// GET /api/products/:id - Получить товар по ID
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    const product = await prisma.product.findUnique({
      where: { id: parseInt(id) },
      include: {
        category: true
      }
    });

if (!product) {
      return res.status(404).json({
        error: 'Товар не найден'
      });
    }

    // Добавляем finalPrice
    const marginPercent = await getCurrentMargin();
    const productWithFinalPrice = {
      ...product,
      price: parseFloat(product.price) * (1 + marginPercent / 100)
  };

    res.json({ product: productWithFinalPrice });

  } catch (error) {
    console.error('Ошибка получения товара:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/products/categories/all - Получить все категории
router.get('/categories/all', async (req, res) => {
  try {
    const categories = await prisma.category.findMany({
      where: { isActive: true },
      include: {
        _count: {
          select: {
            products: {
              where: { isActive: true }
            }
          }
        }
      },
      orderBy: {
        name: 'asc'
      }
    });

    res.json({ 
      success: true,
      categories 
    });

  } catch (error) {
    console.error('Ошибка получения категорий:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;
