// src/routes/category-mapping.js
// API для управления маппингом категорий поставщика

const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const { requireAdmin } = require('../middleware/auth');

const prisma = new PrismaClient();

// Применяем middleware для всех маршрутов
//router.use(requireAdmin);

/**
 * GET /api/admin/category-mappings
 * Получить все маппинги
 */
router.get('/', async (req, res) => {
  try {
    const mappings = await prisma.supplierCategoryMapping.findMany({
      include: {
        targetCategory: {
          select: {
            id: true,
            name: true
          }
        }
      },
      orderBy: {
        supplierCategory: 'asc'
      }
    });

    res.json({
      success: true,
      count: mappings.length,
      mappings: mappings
    });
  } catch (error) {
    console.error('❌ Ошибка получения маппингов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения маппингов: ' + error.message
    });
  }
});

/**
 * GET /api/admin/category-mappings/stats
 * Статистика по маппингам
 */
router.get('/stats', async (req, res) => {
  try {
    const totalMappings = await prisma.supplierCategoryMapping.count();
    
    // Группировка по целевым категориям
    const byCategory = await prisma.supplierCategoryMapping.groupBy({
      by: ['targetCategoryId'],
      _count: true
    });

    // Обогащаем названиями категорий
    const enrichedStats = await Promise.all(
      byCategory.map(async (stat) => {
        const category = await prisma.category.findUnique({
          where: { id: stat.targetCategoryId },
          select: { name: true }
        });
        return {
          categoryId: stat.targetCategoryId,
          categoryName: category?.name || 'Unknown',
          mappingsCount: stat._count
        };
      })
    );

    res.json({
      success: true,
      totalMappings,
      byCategory: enrichedStats.sort((a, b) => b.mappingsCount - a.mappingsCount)
    });
  } catch (error) {
    console.error('❌ Ошибка получения статистики:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения статистики: ' + error.message
    });
  }
});

/**
 * POST /api/admin/category-mappings
 * Создать новый маппинг
 */
router.post('/', async (req, res) => {
  try {
    const { supplierCategory, targetCategoryId, confidence } = req.body;

    // Валидация
    if (!supplierCategory || !targetCategoryId) {
      return res.status(400).json({
        success: false,
        error: 'Необходимо указать supplierCategory и targetCategoryId'
      });
    }

    // Проверяем существование целевой категории
    const targetCategory = await prisma.category.findUnique({
      where: { id: parseInt(targetCategoryId) }
    });

    if (!targetCategory) {
      return res.status(404).json({
        success: false,
        error: 'Целевая категория не найдена'
      });
    }

    // Создаём маппинг
    const mapping = await prisma.supplierCategoryMapping.create({
      data: {
        supplierCategory: supplierCategory.trim(),
        targetCategoryId: parseInt(targetCategoryId),
        confidence: confidence || 'manual'
      },
      include: {
        targetCategory: {
          select: { id: true, name: true }
        }
      }
    });

    res.status(201).json({
      success: true,
      mapping: mapping
    });
  } catch (error) {
    console.error('❌ Ошибка создания маппинга:', error);
    
    // Обработка ошибки уникальности
    if (error.code === 'P2002') {
      return res.status(409).json({
        success: false,
        error: 'Маппинг для этой категории поставщика уже существует'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Ошибка создания маппинга: ' + error.message
    });
  }
});

/**
 * PUT /api/admin/category-mappings/:id
 * Обновить существующий маппинг
 */
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { targetCategoryId, confidence } = req.body;

    // Проверяем существование маппинга
    const existing = await prisma.supplierCategoryMapping.findUnique({
      where: { id: parseInt(id) }
    });

    if (!existing) {
      return res.status(404).json({
        success: false,
        error: 'Маппинг не найден'
      });
    }

    // Если меняется targetCategoryId, проверяем его существование
    if (targetCategoryId) {
      const targetCategory = await prisma.category.findUnique({
        where: { id: parseInt(targetCategoryId) }
      });

      if (!targetCategory) {
        return res.status(404).json({
          success: false,
          error: 'Целевая категория не найдена'
        });
      }
    }

    // Обновляем маппинг
    const updated = await prisma.supplierCategoryMapping.update({
      where: { id: parseInt(id) },
      data: {
        ...(targetCategoryId && { targetCategoryId: parseInt(targetCategoryId) }),
        ...(confidence && { confidence })
      },
      include: {
        targetCategory: {
          select: { id: true, name: true }
        }
      }
    });

    res.json({
      success: true,
      mapping: updated
    });
  } catch (error) {
    console.error('❌ Ошибка обновления маппинга:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления маппинга: ' + error.message
    });
  }
});

/**
 * DELETE /api/admin/category-mappings/:id
 * Удалить маппинг
 */
router.delete('/:id', async (req, res) => {
  try {
    const { id } = req.params;

    // Проверяем существование
    const existing = await prisma.supplierCategoryMapping.findUnique({
      where: { id: parseInt(id) }
    });

    if (!existing) {
      return res.status(404).json({
        success: false,
        error: 'Маппинг не найден'
      });
    }

    // Удаляем
    await prisma.supplierCategoryMapping.delete({
      where: { id: parseInt(id) }
    });

    res.json({
      success: true,
      message: 'Маппинг удалён'
    });
  } catch (error) {
    console.error('❌ Ошибка удаления маппинга:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления маппинга: ' + error.message
    });
  }
});

/**
 * POST /api/admin/category-mappings/bulk
 * Массовое создание маппингов (для импорта)
 */
router.post('/bulk', async (req, res) => {
  try {
    const { mappings } = req.body;

    if (!Array.isArray(mappings) || mappings.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Необходимо передать массив маппингов'
      });
    }

    const results = {
      created: 0,
      skipped: 0,
      errors: []
    };

    for (const mapping of mappings) {
      try {
        await prisma.supplierCategoryMapping.upsert({
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
        results.created++;
      } catch (error) {
        results.errors.push({
          supplierCategory: mapping.supplierCategory,
          error: error.message
        });
        results.skipped++;
      }
    }

    res.json({
      success: true,
      results: results
    });
  } catch (error) {
    console.error('❌ Ошибка массового создания:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка массового создания: ' + error.message
    });
  }
});

/**
 * POST /api/admin/category-mappings/increment-usage/:id
 * Увеличить счётчик использования маппинга
 */
router.post('/increment-usage/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const updated = await prisma.supplierCategoryMapping.update({
      where: { id: parseInt(id) },
      data: {
        timesUsed: { increment: 1 }
      }
    });

    res.json({
      success: true,
      mapping: updated
    });
  } catch (error) {
    console.error('❌ Ошибка обновления счётчика:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления счётчика: ' + error.message
    });
  }
});

module.exports = router;
