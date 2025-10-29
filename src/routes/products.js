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
    return setting ? parseFloat(setting.value) : 25.0;
  } catch (error) {
    console.error('⚠️ Ошибка получения маржи:', error);
    return 25.0;
  }
}

// GET /api/products - Получить все товары
router.get('/', async (req, res) => {
  try {
    const { categoryId, search, page = 1, limit = 20 } = req.query;
    
    const where = {
      isActive: true,
      ...(categoryId && { categoryId: parseInt(categoryId) }),
      ...(search && {
        OR: [
          { name: { contains: search, mode: 'insensitive' } },
          { description: { contains: search, mode: 'insensitive' } }
        ]
      })
    };

    const products = await prisma.product.findMany({
      where,
      include: {
        category: true
      },
      orderBy: {
        name: 'asc'
      },
      skip: (parseInt(page) - 1) * parseInt(limit),
      take: parseInt(limit)
    });

    const total = await prisma.product.count({ where });

    // Получаем маржу и добавляем finalPrice
    const marginPercent = await getCurrentMargin();
    const productsWithFinalPrice = products.map(product => ({
      ...product,
      price: parseFloat(product.price) * (1 + marginPercent / 100)
    }));

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

    res.json({ categories });

  } catch (error) {
    console.error('Ошибка получения категорий:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;
