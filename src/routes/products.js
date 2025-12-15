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

// ✅ УМНАЯ ЛОГИКА ПОИСКА
if (search && search.trim().length > 0) {
  const searchTerm = search.trim();
  const searchWords = searchTerm.toLowerCase().split(/\s+/); // Разбиваем на слова
  
  where.OR = [
    // Приоритет 1: Точное совпадение
    { name: { equals: searchTerm, mode: 'insensitive' } },
    
    // Приоритет 2: Название начинается с запроса
    { name: { startsWith: searchTerm, mode: 'insensitive' } },
    
    // Приоритет 3: Содержит запрос целиком
    { name: { contains: searchTerm, mode: 'insensitive' } },
  ];

  // ✅ НОВОЕ: Если больше одного слова - ищем все слова по отдельности
  if (searchWords.length > 1) {
    where.OR.push({
      AND: searchWords.map(word => ({
        name: { contains: word, mode: 'insensitive' }
      }))
    });
  }

  // Поиск в описании и категории (низкий приоритет)
  where.OR.push(
    { description: { contains: searchTerm, mode: 'insensitive' } },
    { category: { name: { contains: searchTerm, mode: 'insensitive' } } }
  );
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

  const productsWithScore = products.map(product => {
    const name = product.name.toLowerCase();
    const nameWords = name.split(/\s+/);
    const description = (product.description || '').toLowerCase();
    let score = 0;

    // 🔥 СУПЕРПРИОРИТЕТ: Первое слово названия = первому слову запроса
    if (nameWords[0] === queryWords[0]) {
      score += 100000;
    }
    else if (nameWords[0] === lowerQuery) {
      score += 90000;
    }
    else if (nameWords[0].startsWith(queryWords[0])) {
      score += 80000;
    }
    else if (name.startsWith(lowerQuery + ' ')) {
      score += 70000;
    }
    else if (name === lowerQuery) {
      score += 60000;
    }
    else {
      // Ищем позицию ТОЧНОГО совпадения первого слова запроса
      let earliestPosition = 999;
      
      const position = nameWords.findIndex(w => w === queryWords[0]);
      if (position !== -1) {
        earliestPosition = position;
      }
      
      if (earliestPosition === 1) score += 10000;
      else if (earliestPosition === 2) score += 8000;
      else if (earliestPosition === 3) score += 6000;
      else if (earliestPosition === 4) score += 4000;
      else if (earliestPosition < 10) score += 2000;
      else if (earliestPosition < 999) score += 1000;
      
      // Если точного совпадения нет, ищем через startsWith
      if (earliestPosition === 999) {
        const partialPosition = nameWords.findIndex(w => w.startsWith(queryWords[0]));
        if (partialPosition === 0) score += 500;
        else if (partialPosition === 1) score += 400;
        else if (partialPosition > 1) score += 300;
      }
    }
    
    // ✅ НОВОЕ: Бонус за наличие ВСЕХ слов запроса
    const allWordsPresent = queryWords.every(word => 
      nameWords.some(nameWord => nameWord.includes(word))
    );
    
    if (allWordsPresent) {
      score += 5000; // Большой бонус!
      
      // Дополнительный бонус за порядок слов
      let lastFoundIndex = -1;
      let inOrder = true;
      
      for (const word of queryWords) {
        const index = nameWords.findIndex((w, i) => i > lastFoundIndex && w.includes(word));
        if (index === -1) {
          inOrder = false;
          break;
        }
        lastFoundIndex = index;
      }
      
      if (inOrder) {
        score += 2000; // Бонус за правильный порядок слов
      }
    }
    
    // Бонус за количество совпадающих слов
    const matchedWordsCount = queryWords.filter(word => 
      nameWords.some(nameWord => nameWord.includes(word))
    ).length;
    
    if (matchedWordsCount > 0) {
      score += matchedWordsCount * 500;
    }
    
    // Бонус за вхождение полного запроса
    if (name.includes(lowerQuery)) {
      score += 1000;
    }
    
    // Минимальный бонус за описание
    if (description.includes(lowerQuery)) {
      score += 50;
    }

    return { product, score };
  });

  const sorted = productsWithScore
    .sort((a, b) => {
      if (b.score !== a.score) return b.score - a.score;
      return a.product.name.localeCompare(b.product.name, 'ru');
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

// POST /api/products/validate - Проверка товаров в корзине
router.post('/validate', async (req, res) => {
  try {
    const { productIds } = req.body;
    
    if (!productIds || !Array.isArray(productIds) || productIds.length === 0) {
      return res.json({ success: true, valid: [], invalid: [] });
    }

    const ids = productIds.map(id => parseInt(id)).filter(id => !isNaN(id));
    
    const existingProducts = await prisma.product.findMany({
      where: { id: { in: ids } },
      select: { id: true, name: true, isActive: true }
    });

    const existingMap = new Map(existingProducts.map(p => [p.id, p]));
    
    const valid = [];
    const invalid = [];

    for (const id of ids) {
      const product = existingMap.get(id);
      if (!product) {
        invalid.push({ id, name: null, reason: 'Товар удалён' });
      } else if (!product.isActive) {
        invalid.push({ id, name: product.name, reason: 'Товар недоступен' });
      } else {
        valid.push(id);
      }
    }

    if (invalid.length > 0) {
      console.log(`🛒 Валидация корзины: ${valid.length} ок, ${invalid.length} удалено`);
    }

    res.json({ success: true, valid, invalid });
  } catch (error) {
    console.error('❌ Ошибка валидации корзины:', error);
    res.status(500).json({ success: false, error: 'Ошибка проверки' });
  }
});

module.exports = router;
