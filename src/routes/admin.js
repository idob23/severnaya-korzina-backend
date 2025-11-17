// src/routes/admin.js - НОВЫЙ ФАЙЛ ДЛЯ АДМИНСКИХ МАРШРУТОВ
const express = require('express');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const router = express.Router();
const prisma = new PrismaClient();
const multer = require('multer');
const csv = require('csv-parser');
const fs = require('fs');
const { Readable } = require('stream');
const { authenticateToken } = require('../middleware/auth');

// Настройка multer для загрузки файлов в память
const upload = multer({ 
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB максимум
});

// Middleware для проверки админских прав
const adminAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ') 
      ? authHeader.slice(7) 
      : null;

    if (!token) {
      return res.status(401).json({
        success: false,
        error: 'Токен не предоставлен'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Недостаточно прав'
      });
    }

    req.admin = decoded;
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: 'Недействительный токен'
      });
    }
    
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
};

// Получение всех настроек системы
router.get('/settings', authenticateToken, async (req, res) => {
  try {
    const settings = await prisma.systemSettings.findMany();
    
    // Преобразуем в объект для удобства
    const settingsObj = {};
    settings.forEach(s => {
      settingsObj[s.key] = {
        value: s.value,
        description: s.description
      };
    });
    
    res.json({
      success: true,
      settings: settingsObj
    });
  } catch (error) {
    console.error('Ошибка получения настроек:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения настроек'
    });
  }
});

// Обновление настройки
router.put('/settings/:key', authenticateToken, async (req, res) => {
  try {
    const { key } = req.params;
    const { value } = req.body;
    
    // Валидация для определенных настроек
    if (key === 'default_margin_percent') {
      const margin = parseFloat(value);
      if (isNaN(margin) || margin < 0 || margin > 100) {
        return res.status(400).json({
          success: false,
          error: 'Маржа должна быть от 0 до 100%'
        });
      }
    }
    
    if (key === 'vat_code') {
      const validCodes = ['1', '2', '3', '4', '5', '6'];
      if (!validCodes.includes(value)) {
        return res.status(400).json({
          success: false,
          error: 'Недопустимый код НДС'
        });
      }
    }
    
    const setting = await prisma.systemSettings.upsert({
      where: { key },
      update: { value, updatedAt: new Date() },
      create: { key, value }
    });
    
    res.json({
      success: true,
      setting,
      message: `Настройка ${key} обновлена`
    });
    
  } catch (error) {
    console.error('Ошибка обновления настройки:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления настройки'
    });
  }
});

// GET /api/admin/orders - Получить все заказы
router.get('/orders', adminAuth, async (req, res) => {
  try {
    const { page = 1, limit = 20, status } = req.query;
    const skip = (page - 1) * limit;

    const where = status ? { status } : {};

    const orders = await prisma.order.findMany({
      where,
      skip,
      take: parseInt(limit),
      include: {
        user: {
          select: {
            id: true,
            phone: true,
            firstName: true,
            lastName: true
          }
        },
        items: {
          include: {
            product: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    const total = await prisma.order.count({ where });

    res.json({
      success: true,
      orders: orders.map(order => ({
        id: order.id,
        orderNumber: order.orderNumber,
        status: order.status,
        totalAmount: order.totalAmount,
        prepaymentAmount: order.prepaymentAmount,
        deliveryDate: order.deliveryDate,
        createdAt: order.createdAt,
        user: {
          id: order.user.id,
          phone: order.user.phone,
          name: `${order.user.firstName} ${order.user.lastName || ''}`.trim()
        },
        itemsCount: order.items.length,
        items: order.items.map(item => ({
          id: item.id,
          productName: item.product.name,
          quantity: item.quantity,
          price: item.price
        }))
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения заказов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения заказов'
    });
  }
});

// DELETE /api/admin/orders/:id - Удалить заказ (для админа, любой статус)
router.delete('/orders/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const orderId = parseInt(id);
    
    // Проверяем, существует ли заказ
    const order = await prisma.order.findUnique({
      where: { id: orderId },
      include: {
        user: {
          select: { phone: true, firstName: true }
        },
        batch: {
          select: { id: true, title: true }
        }
      }
    });
    
    if (!order) {
      return res.status(404).json({
        success: false,
        error: 'Заказ не найден'
      });
    }
    
    const batchId = order.batchId;
    
    // Удаляем заказ в транзакции
    await prisma.$transaction(async (tx) => {
      // Удаляем позиции заказа (CASCADE удалит автоматически, но для явности)
      await tx.orderItem.deleteMany({
        where: { orderId: orderId }
      });
      
      // Удаляем связанные платежи (CASCADE)
      await tx.payment.deleteMany({
        where: { orderId: orderId }
      });

      // Удаляем сам заказ
      await tx.order.delete({
        where: { id: orderId }
      });
    });
    
    // Обновляем статистику партии, если заказ был в партии
    if (batchId) {
      try {
        const { updateBatchStatistics } = require('./batches');
        await updateBatchStatistics(batchId);
        console.log(`📊 Статистика партии #${batchId} обновлена после удаления заказа`);
      } catch (batchError) {
        console.error(`⚠️ Ошибка обновления статистики партии:`, batchError.message);
      }
    }

    console.log(`✅ Заказ #${orderId} удален администратором (пользователь: ${order.user.phone})`);

    res.json({
      success: true,
      message: 'Заказ успешно удален'
    });
  } catch (error) {
    console.error('❌ Ошибка удаления заказа:', error);
    
    // Обработка ошибки внешнего ключа
    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Невозможно удалить заказ из-за связанных данных'
      });
    }
    
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления заказа'
    });
  }
});

// GET /api/admin/batches - Получить все партии
router.get('/batches', adminAuth, async (req, res) => {
  try {
    const { page = 1, limit = 20, status } = req.query;
    const skip = (page - 1) * limit;

    const where = status ? { status } : {};

    const batches = await prisma.batch.findMany({
      where,
      skip,
      take: parseInt(limit),
      include: {
        _count: {
          select: {
            orders: true,
            products: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    const total = await prisma.batch.count({ where });

    res.json({
      success: true,
      batches: batches.map(batch => ({
        id: batch.id,
        name: batch.name,
        status: batch.status,
        startDate: batch.startDate,
        endDate: batch.endDate,
        deliveryDate: batch.deliveryDate,
        minAmount: batch.minAmount,
        currentAmount: batch.currentAmount,
        createdAt: batch.createdAt,
        ordersCount: batch._count.orders,
        productsCount: batch._count.products
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения партий:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения партий'
    });
  }
});

// POST /api/admin/batches - Создать новую партию
router.post('/batches', adminAuth, async (req, res) => {
  try {
    const { name, startDate, endDate, deliveryDate, minAmount } = req.body;

    const batch = await prisma.batch.create({
      data: {
        name,
        status: 'ACTIVE',
        startDate: new Date(startDate),
        endDate: new Date(endDate),
        deliveryDate: new Date(deliveryDate),
        minAmount: parseFloat(minAmount),
        currentAmount: 0
      }
    });

    res.json({
      success: true,
      message: 'Партия создана успешно',
      batch
    });
  } catch (error) {
    console.error('❌ Ошибка создания партии:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка создания партии'
    });
  }
});

// PUT /api/admin/batches/:id/status - Обновить статус партии
router.put('/batches/:id/status', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const batch = await prisma.batch.update({
      where: { id: parseInt(id) },
      data: { status }
    });

    res.json({
      success: true,
      message: 'Статус партии обновлен',
      batch
    });
  } catch (error) {
    console.error('❌ Ошибка обновления статуса партии:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления статуса партии'
    });
  }
});

// DELETE /api/admin/batches/:id - Удалить партию
router.delete('/batches/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);
    
    // Проверяем, существует ли партия
    const batch = await prisma.batch.findUnique({
      where: { id: batchId },
      include: {
        _count: {
          select: {
            orders: true
          }
        }
      }
    });
    
    if (!batch) {
      return res.status(404).json({
        success: false,
        error: 'Партия не найдена'
      });
    }
    
    // Проверяем статус партии
    if (batch.status === 'active' || batch.status === 'collecting') {
      return res.status(400).json({
        success: false,
        error: 'Невозможно удалить активную партию. Сначала завершите или отмените её.'
      });
    }
    
    // Проверяем наличие оплаченных заказов
    const paidOrders = await prisma.order.count({
      where: {
        batchId: batchId,
        status: { in: ['paid', 'shipped'] }
      }
    });
    
    if (paidOrders > 0) {
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить партию с оплаченными заказами (${paidOrders} заказов)`
      });
    }
    
    // Удаляем партию (связанные batch_items удалятся автоматически через CASCADE)
    // Заказы останутся, но поле batchId станет NULL (SET NULL в схеме)
    await prisma.batch.delete({
      where: { id: batchId }
    });
    
    console.log(`✅ Партия #${batchId} успешно удалена`);
    
    res.json({
      success: true,
      message: 'Партия успешно удалена'
    });
    
  } catch (error) {
    console.error('❌ Ошибка удаления партии:', error);
    
    // Обработка ошибки внешнего ключа
    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Невозможно удалить партию из-за связанных данных'
      });
    }
    
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления партии'
    });
  }
});

// GET /api/admin/products - Получить все товары для админа
router.get('/products', adminAuth, async (req, res) => {
  try {
    const { page = 1, limit = 20, search } = req.query;
    const skip = (page - 1) * limit;

    const where = search ? {
      OR: [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } }
      ]
    } : {};

    const products = await prisma.product.findMany({
      where,
      skip,
      take: parseInt(limit),
      include: {
        category: true,
        _count: {
          select: {
            orderItems: true
          }
        }
      },
      orderBy: {
        createdAt: 'desc'
      }
    });

    const total = await prisma.product.count({ where });

    res.json({
      success: true,
      products: products.map(product => ({
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        unit: product.unit,
        minQuantity: product.minQuantity,
        available: product.available,
        imageUrl: product.imageUrl,
        category: product.category ? {
          id: product.category.id,
          name: product.category.name
        } : null,
        ordersCount: product._count.orderItems,
        createdAt: product.createdAt
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения товаров:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения товаров'
    });
  }
});

// POST /api/admin/products - Создать новый товар (с поддержкой maxQuantity)
router.post('/products', adminAuth, async (req, res) => {
  try {
    const { 
      name, 
      description, 
      price, 
      unit, 
      minQuantity, 
      maxQuantity,  // НОВОЕ ПОЛЕ
      categoryId,
      imageUrl 
    } = req.body;

    // Проверяем обязательные поля
    if (!name || !price || !unit || !categoryId) {
      return res.status(400).json({
        success: false,
        error: 'Обязательные поля: name, price, unit, categoryId'
      });
    }

    // Проверяем существует ли категория
    const category = await prisma.category.findUnique({
      where: { id: parseInt(categoryId) }
    });
    
    if (!category) {
      return res.status(400).json({
        success: false,
        error: 'Категория не найдена'
      });
    }

    const product = await prisma.product.create({
      data: {
        name,
        description: description || null,
        price: parseFloat(price),
        unit,
        minQuantity: minQuantity ? parseInt(minQuantity) : 1,
        maxQuantity: maxQuantity ? parseInt(maxQuantity) : null,  // НОВОЕ
        categoryId: parseInt(categoryId),
        imageUrl: imageUrl || null,
        isActive: true
      },
      include: {
        category: true
      }
    });

    console.log(`✅ Создан товар "${name}" с остатком: ${maxQuantity || 'неограничено'}`);

    res.json({
      success: true,
      message: 'Товар создан успешно',
      product
    });
  } catch (error) {
    console.error('❌ Ошибка создания товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка создания товара'
    });
  }
});

// POST /api/admin/products/bulk - Массовое создание товаров
router.post('/products/bulk', adminAuth, async (req, res) => {
  try {
    const { products } = req.body;
    
    if (!products || !Array.isArray(products) || products.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Ожидается непустой массив products'
      });
    }

    console.log(`📦 Массовое создание ${products.length} товаров...`);
    const startTime = Date.now();
    
    const created = [];
    const errors = [];
    const skipped = []; // ← ДОБАВЛЕНО: пропущенные дубликаты

    // ✨ ШАГ 1: Получаем все существующие названия товаров из БД
    const existingProducts = await prisma.product.findMany({
      where: { isActive: true },
      select: { name: true }
    });
    
    // Создаём Set для быстрой проверки (O(1) вместо O(n))
    const existingNames = new Set(
      existingProducts.map(p => p.name.toLowerCase().trim())
    );
    
    console.log(`   📋 В БД уже есть ${existingNames.size} товаров`);

    // ✨ ШАГ 2: Создаём товары в цикле с проверкой на дубликаты
    for (const productData of products) {
      try {
        // Валидация обязательных полей
        if (!productData.name || !productData.price || !productData.unit) {
          errors.push({
            name: productData.name || 'Без названия',
            error: 'Отсутствуют обязательные поля'
          });
          continue;
        }

        // ✨ НОВОЕ: Проверка на дубликат по названию
        const normalizedName = productData.name.toLowerCase().trim();
        if (existingNames.has(normalizedName)) {
          skipped.push({
            name: productData.name,
            reason: 'Товар с таким названием уже существует'
          });
          console.log(`   ⏭️ Пропущен дубликат: "${productData.name}"`);
          continue; // Пропускаем этот товар
        }

        const product = await prisma.product.create({
          data: {
            name: productData.name,
            description: productData.description || null,
            price: parseFloat(productData.price),
            unit: productData.unit,
            minQuantity: productData.minQuantity ? parseInt(productData.minQuantity) : 1,
            maxQuantity: productData.maxQuantity ? parseInt(productData.maxQuantity) : null,
            categoryId: productData.categoryId ? parseInt(productData.categoryId) : null,
            imageUrl: productData.imageUrl || null,
            isActive: true,
	    // ✅ ДОБАВИТЬ ЭТИ 3 СТРОКИ:
    basePrice: productData.basePrice ? parseFloat(productData.basePrice) : null,
    baseUnit: productData.baseUnit || null,
    inPackage: productData.inPackage ? parseInt(productData.inPackage) : null,
          },
          include: { category: true }
        });
        
created.push({
  ...product,
  basePrice: productData.basePrice,   // передаём обратно
  baseUnit: productData.baseUnit,     // передаём обратно
  inPackage: productData.inPackage    // передаём обратно
});

// ОТЛАДКА
console.log('📦 Product created with basePrice:', {
  name: productData.name,
  basePrice: productData.basePrice,
  baseUnit: productData.baseUnit,
  inPackage: productData.inPackage
});
        
        // ✨ ДОБАВЛЯЕМ в Set чтобы не создать дубликат в этой же пачке
        existingNames.add(normalizedName);
        
      } catch (error) {
        errors.push({
          name: productData.name || 'Без названия',
          error: error.message
        });
      }
    }

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log(`✅ Создано: ${created.length}, Пропущено: ${skipped.length}, Ошибок: ${errors.length}, Время: ${duration}с`);

    res.json({
      success: true,
      created: created.length,
      skipped: skipped.length,  // ← ДОБАВЛЕНО
      errors: errors.length,
      skippedItems: skipped,    // ← ДОБАВЛЕНО: детали пропущенных
      errorItems: errors,
      duration: `${duration}s`,
      products: created
    });
  } catch (error) {
    console.error('❌ Ошибка массового создания:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка массового создания товаров: ' + error.message
    });
  }
});

// PUT /api/admin/products/:id - Обновить товар (с поддержкой maxQuantity)
router.put('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Преобразуем числовые поля
    if (updateData.price !== undefined) {
      updateData.price = parseFloat(updateData.price);
    }
    if (updateData.minQuantity !== undefined) {
      updateData.minQuantity = parseInt(updateData.minQuantity);
    }
    if (updateData.categoryId !== undefined) {
      updateData.categoryId = parseInt(updateData.categoryId);
    }
    
    // НОВОЕ: Обработка maxQuantity
    if ('maxQuantity' in updateData) {
      // Если пустая строка, null или undefined - снимаем ограничение
      if (updateData.maxQuantity === '' || updateData.maxQuantity === null || updateData.maxQuantity === undefined) {
        updateData.maxQuantity = null;
      } else {
        updateData.maxQuantity = parseInt(updateData.maxQuantity);
      }
    }

    const product = await prisma.product.update({
      where: { id: parseInt(id) },
      data: updateData,
      include: {
        category: true
      }
    });

    console.log(`✅ Товар #${id} обновлен. MaxQuantity: ${product.maxQuantity}`);

    res.json({
      success: true,
      message: 'Товар обновлен успешно',
      product
    });
  } catch (error) {
    console.error('❌ Ошибка обновления товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обновления товара'
    });
  }
});

// DELETE /api/admin/products/delete-all - БЕЗОПАСНОЕ удаление со снэпшотами
router.delete('/products/delete-all', adminAuth, async (req, res) => {
  try {
    console.log('🗑️ Запрос на удаление ВСЕХ товаров (с безопасностью)');

    // ============================================
    // ШАГ 1: ПРОВЕРЯЕМ АКТИВНЫЕ ЗАКАЗЫ (КРИТИЧНО!)
    // ============================================
    const activeOrders = await prisma.order.count({
      where: {
        status: {
          notIn: ['delivered', 'shipped', 'cancelled']
        }
      }
    });

    if (activeOrders > 0) {
      console.log(`❌ Блокировка: Есть ${activeOrders} активных заказов`);
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить товары. Есть ${activeOrders} активных заказов.`,
        hint: 'Сначала завершите или отмените все заказы со статусами: pending, paid',
        activeOrders: activeOrders
      });
    }

    // ============================================
    // ШАГ 2: ПРОВЕРЯЕМ АКТИВНЫЕ ПАРТИИ (КРИТИЧНО!)
    // ============================================
    const activeBatches = await prisma.batch.count({
      where: {
        status: {
          notIn: ['completed', 'cancelled']
        }
      }
    });

    if (activeBatches > 0) {
      console.log(`❌ Блокировка: Есть ${activeBatches} активных партий`);
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить товары. Есть ${activeBatches} активных партий.`,
        hint: 'Сначала завершите или отмените все партии',
        activeBatches: activeBatches
      });
    }

    // ============================================
    // ШАГ 3: ПОЛУЧАЕМ ВСЕ ТОВАРЫ
    // ============================================
    const allProducts = await prisma.product.findMany({
      where: { isActive: true },
      select: {
        id: true,
        name: true,
        unit: true,
        price: true
      }
    });

    if (allProducts.length === 0) {
      console.log('ℹ️ Нет товаров для удаления');
      return res.json({
        success: true,
        message: 'Нет товаров для удаления',
        deleted: 0
      });
    }

    console.log(`📦 Найдено товаров для удаления: ${allProducts.length}`);

    // ============================================
    // ШАГ 4: СОХРАНЯЕМ СНЭПШОТЫ (НОВОЕ!)
    // ============================================
    console.log('💾 Определяем товары, которые используются в заказах...');

// Получаем уникальные ID товаров из всех order_items
const productsInOrders = await prisma.orderItem.findMany({
  select: { productId: true },
  distinct: ['productId']
});

const productIdsInOrders = productsInOrders.map(item => item.productId);
console.log(`📦 Найдено товаров в заказах: ${productIdsInOrders.length}`);

// Получаем полные данные только для товаров, которые есть в заказах
const productsToSnapshot = allProducts.filter(p => productIdsInOrders.includes(p.id));
console.log(`💾 Будет сохранено снэпшотов: ${productsToSnapshot.length}/${allProducts.length}`);

let snapshotsSaved = 0;
for (const product of productsToSnapshot) {  // ✅ ПРАВИЛЬНО: только товары из заказов
  try {
    await prisma.$executeRaw`
      INSERT INTO product_snapshots (product_id, name, unit, price, created_at)
      VALUES (${product.id}, ${product.name}, ${product.unit}, ${product.price}, NOW())
      ON CONFLICT (product_id) DO NOTHING
    `;
    snapshotsSaved++;
  } catch (error) {
    console.error(`⚠️ Ошибка сохранения снэпшота для товара ${product.id}:`, error.message);
  }
}

console.log(`✅ Снэпшоты сохранены: ${snapshotsSaved}/${productsToSnapshot.length}`);
    // ============================================
    // ШАГ 5: УДАЛЯЕМ В ТРАНЗАКЦИИ
    // ============================================
    console.log('🗑️ Начинаем удаление в транзакции...');

    await prisma.$transaction(async (tx) => {
      // 5.1. Удаляем все batch_items (связи товаров с партиями)
      const deletedBatchItems = await tx.batchItem.deleteMany({});
      console.log(`   ✅ Удалено batch_items: ${deletedBatchItems.count}`);

      // 5.2. Удаляем order_items только для ЗАВЕРШЕННЫХ заказов
      // (для pending/paid заказов их не должно быть, т.к. мы проверили выше)
//      const deletedOrderItems = await tx.orderItem.deleteMany({
  //      where: {
    //      order: {
      //      status: {
        //      in: ['delivered', 'shipped', 'cancelled']
          //  }
          //}
      //  }
      //});
     // console.log(`   ✅ Удалено order_items (для завершенных заказов): ${deletedOrderItems.count}`);
console.log(`   ✅ order_items сохранены для истории заказов`);
      // 5.3. Теперь можем удалить товары
const deletedProducts = await tx.product.deleteMany({
  where: { isActive: true }  // ← ДОБАВЬ ФИЛЬТР!
})
      console.log(`   ✅ Удалено products: ${deletedProducts.count}`);
    });

    console.log(`✅ УСПЕШНО: Удалено ${allProducts.length} товаров, снэпшоты сохранены`);

    res.json({
      success: true,
      message: `Успешно удалено ${allProducts.length} товаров`,
      deleted: allProducts.length,
      snapshotsSaved: snapshotsSaved,
      details: {
        deletedProducts: allProducts.length,
        snapshotsSaved: snapshotsSaved,
        warning: 'Товары удалены из БД, но данные сохранены в product_snapshots для истории заказов'
      }
    });

  } catch (error) {
    console.error('❌ КРИТИЧЕСКАЯ ОШИБКА удаления товаров:', error);
    
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления товаров',
      details: error.message
    });
  }
});

// GET /api/admin/dashboard/stats - Статистика для dashboard
router.get('/dashboard/stats', adminAuth, async (req, res) => {
  try {
    const [
      totalUsers,
      totalOrders,
      totalProducts,
      activeBatches,
      todayOrders,
      totalRevenue
    ] = await Promise.all([
      prisma.user.count(),
      prisma.order.count(),
      prisma.product.count({ where: { available: true } }),
      prisma.batch.count({ where: { status: 'ACTIVE' } }),
      prisma.order.count({
        where: {
          createdAt: {
            gte: new Date(new Date().setHours(0, 0, 0, 0))
          }
        }
      }),
      prisma.order.aggregate({
        _sum: {
          totalAmount: true
        }
      })
    ]);

    res.json({
      success: true,
      stats: {
        totalUsers,
        totalOrders,
        totalProducts,
        activeBatches,
        todayOrders,
        totalRevenue: totalRevenue._sum.totalAmount || 0
      }
    });
  } catch (error) {
    console.error('❌ Ошибка получения статистики:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения статистики'
    });
  }
});

// POST /api/admin/products/parse - Парсинг файла и возврат данных
router.post('/products/parse', adminAuth, upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Файл не загружен'
      });
    }

    const { originalname, buffer, mimetype } = req.file;
    const fileName = originalname.toLowerCase();
    
    let parsedItems = [];

    // Парсинг CSV файлов
    if (fileName.endsWith('.csv') || mimetype === 'text/csv') {
      parsedItems = await parseCSV(buffer);
    } 
    // Парсинг текстовых файлов
    else if (fileName.endsWith('.txt') || mimetype === 'text/plain') {
      parsedItems = parseTextFile(buffer);
    } 
    else {
      return res.status(400).json({
        success: false,
        error: 'Формат файла не поддерживается. Используйте CSV или TXT'
      });
    }

    // Обогащаем данные категориями
    const enrichedItems = await enrichWithCategories(parsedItems);

    res.json({
      success: true,
      fileName: originalname,
      itemsCount: enrichedItems.length,
      items: enrichedItems
    });

  } catch (error) {
    console.error('❌ Ошибка парсинга файла:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка обработки файла: ' + error.message
    });
  }
});

// Функция парсинга CSV - ИСПРАВЛЕННАЯ ВЕРСИЯ
async function parseCSV(buffer) {
  return new Promise((resolve, reject) => {
    const results = [];
    const content = buffer.toString('utf-8');
    const lines = content.split('\n').filter(line => line.trim());
    
    if (lines.length < 2) {
      return resolve([]);
    }
    
    // Определяем разделитель
    const delimiter = detectDelimiter(lines[0]);
    console.log('Обнаружен разделитель:', delimiter === '\t' ? 'TAB' : `"${delimiter}"`);
    
    // Парсим заголовки
    const headers = lines[0].split(delimiter).map(h => h.trim().toLowerCase());
    console.log('Заголовки:', headers);
    
    // Парсим данные
    for (let i = 1; i < lines.length; i++) {
      const values = lines[i].split(delimiter);
      const row = {};
      
      headers.forEach((header, index) => {
        row[header] = values[index] ? values[index].trim() : '';
      });
      
      const item = parseRowToItem(row);
      if (item) {
        results.push(item);
      }
    }
    
    console.log(`Распарсено ${results.length} товаров`);
    resolve(results);
  });
}

// Определение разделителя
function detectDelimiter(content) {
  const firstLine = content.split('\n')[0];
  if (firstLine.includes(';')) return ';';
  if (firstLine.includes('\t')) return '\t';
  return ',';
}

// Парсинг строки в товар
function parseRowToItem(row) {
  // Ищем название товара в разных возможных колонках
  const name = row['название'] || row['товар'] || row['наименование'] || 
               row['name'] || row['product'] || row['Name'] || 
               Object.values(row)[0]; // Берем первую колонку если не нашли

  if (!name || name.trim() === '') return null;

  // Ищем цену
  const priceStr = row['цена'] || row['стоимость'] || row['price'] || 
                   row['cost'] || Object.values(row)[1] || '0';
  const price = parseFloat(priceStr.toString().replace(/[^\d.,]/g, '').replace(',', '.')) || 0;

  // Ищем единицу измерения
  const unit = row['единица'] || row['ед'] || row['unit'] || 
               row['ед.изм'] || row['measure'] || 'шт';

  return {
    name: name.trim(),
    price: price,
    unit: unit.trim(),
    description: row['описание'] || row['description'] || '',
    originalData: row // Сохраняем оригинальные данные
  };
}

// Парсинг текстового файла
function parseTextFile(buffer) {
  const content = buffer.toString('utf-8');
  const lines = content.split('\n');
  const items = [];

  for (const line of lines) {
    if (line.trim() === '') continue;
    
    // Простой паттерн: "Название - цена"
    const match = line.match(/^(.+?)\s*[-–]\s*(\d+(?:[.,]\d+)?)\s*(руб|р|₽)?/i);
    if (match) {
      items.push({
        name: match[1].trim(),
        price: parseFloat(match[2].replace(',', '.')),
        unit: 'шт',
        description: '',
        originalData: { line }
      });
    }
  }

  return items;
}

// Обогащение категориями
async function enrichWithCategories(items) {
  // Получаем все категории из БД
  const categories = await prisma.category.findMany();
  
  return items.map(item => {
    // Пытаемся определить категорию по ключевым словам
    const suggestedCategory = suggestCategory(item.name, categories);
    
    return {
      ...item,
      suggestedCategoryId: suggestedCategory?.id || null,
      suggestedCategoryName: suggestedCategory?.name || 'Без категории',
      isNew: true, // Помечаем как новый товар
      isDuplicate: false // Позже добавим проверку дубликатов
    };
  });
}

// Предложение категории по названию
function suggestCategory(productName, categories) {
  const nameLower = productName.toLowerCase();
  
  // Словарь ключевых слов для категорий
  const keywords = {
    'Молочные продукты': ['молоко', 'кефир', 'творог', 'сметана', 'йогурт', 'ряженка'],
    'Мясо и птица': ['говядина', 'свинина', 'курица', 'мясо', 'фарш', 'котлеты'],
    'Овощи и фрукты': ['картофель', 'морковь', 'яблоки', 'бананы', 'помидоры', 'огурцы'],
    'Хлебобулочные изделия': ['хлеб', 'батон', 'булка', 'лаваш', 'багет'],
    'Напитки': ['вода', 'сок', 'напиток', 'чай', 'кофе'],
    'Бакалея': ['крупа', 'мука', 'сахар', 'соль', 'макароны', 'рис', 'гречка']
  };

  for (const category of categories) {
    const categoryKeywords = keywords[category.name] || [];
    for (const keyword of categoryKeywords) {
      if (nameLower.includes(keyword)) {
        return category;
      }
    }
  }

  return null;
}

// DELETE /api/admin/products/bulk-delete - Массовое удаление (С ПРОВЕРКАМИ!)
router.delete('/products/bulk-delete', adminAuth, async (req, res) => {
  try {
    const { productIds } = req.body;
    
    if (!productIds || !Array.isArray(productIds) || productIds.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Необходимо указать массив ID товаров для удаления'
      });
    }
    
    console.log(`🗑️ Запрос на удаление ${productIds.length} товаров`);
    
    const numericIds = productIds.map(id => parseInt(id)).filter(id => !isNaN(id));
    
    if (numericIds.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Не найдено корректных ID товаров'
      });
    }
// ✅ ДОБАВЬ ЭТУ ПРОВЕРКУ:
const inactiveProducts = await prisma.product.count({
  where: {
    id: { in: numericIds },
    isActive: false
  }
});

if (inactiveProducts > 0) {
  return res.status(400).json({
    success: false,
    error: `Нельзя удалять неактивные товары (найдено ${inactiveProducts})`,
    hint: 'Неактивные товары нужны для истории заказов'
  });
}
    // ============================================
    // ПРОВЕРКА: Есть ли активные заказы с этими товарами?
    // ============================================
    const activeOrdersWithProducts = await prisma.orderItem.count({
      where: {
        productId: { in: numericIds },
        order: {
          status: {
            notIn: ['delivered', 'shipped', 'cancelled']
          }
        }
      }
    });

    if (activeOrdersWithProducts > 0) {
      console.log(`❌ Блокировка: Есть ${activeOrdersWithProducts} активных заказов с этими товарами`);
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить товары. Они используются в ${activeOrdersWithProducts} активных заказах.`,
        hint: 'Дождитесь завершения всех заказов',
        activeOrders: activeOrdersWithProducts
      });
    }

    // ============================================
    // ПРОВЕРКА: Есть ли активные партии с этими товарами?
    // ============================================
    const activeBatchesWithProducts = await prisma.batchItem.count({
      where: {
        productId: { in: numericIds },
        batch: {
          status: {
            notIn: ['completed', 'cancelled']
          }
        }
      }
    });

    if (activeBatchesWithProducts > 0) {
      console.log(`❌ Блокировка: Есть ${activeBatchesWithProducts} активных партий с этими товарами`);
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить товары. Они используются в ${activeBatchesWithProducts} активных партиях.`,
        hint: 'Дождитесь завершения партий',
        activeBatches: activeBatchesWithProducts
      });
    }

    // ============================================
    // ВСЁ OK - УДАЛЯЕМ
    // ============================================

// Получаем только те товары, которые используются в заказах
const productsInOrders = await prisma.orderItem.findMany({
  where: { productId: { in: numericIds } },
  select: { productId: true },
  distinct: ['productId']
});

const productIdsInOrders = productsInOrders.map(item => item.productId);
console.log(`📦 Из ${numericIds.length} товаров в заказах используется: ${productIdsInOrders.length}`);

// Получаем данные только для товаров из заказов
const products = await prisma.product.findMany({
  where: { id: { in: productIdsInOrders } },  // ✅ ПРАВИЛЬНО: только товары из заказов
  select: { id: true, name: true, unit: true, price: true }
});

// Сохраняем снэпшоты
let snapshotsSaved = 0;
for (const product of products) {
  try {
    await prisma.$executeRaw`
      INSERT INTO product_snapshots (product_id, name, unit, price, created_at)
      VALUES (${product.id}, ${product.name}, ${product.unit}, ${product.price}, NOW())
      ON CONFLICT (product_id) DO NOTHING
    `;
    snapshotsSaved++;
  } catch (error) {
    console.error(`⚠️ Ошибка снэпшота ${product.id}:`, error.message);
  }
}

console.log(`✅ Снэпшоты сохранены: ${snapshotsSaved}/${products.length}`);

    // Мягкое удаление
    const updateResult = await prisma.product.updateMany({
      where: { id: { in: numericIds } },
      data: { isActive: false }
    });
    
    console.log(`✅ Деактивировано ${updateResult.count} товаров, снэпшоты: ${snapshotsSaved}`);
    
    res.json({
      success: true,
      message: `Успешно удалено товаров: ${updateResult.count}`,
      deleted: updateResult.count,
      snapshotsSaved: snapshotsSaved
    });
    
  } catch (error) {
    console.error('❌ Ошибка удаления товаров:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления товаров',
      details: error.message
    });
  }
});

// DELETE /api/admin/products/:id - Удаление одного товара (С ПРОВЕРКАМИ!)
router.delete('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const productId = parseInt(id);
    
    // Проверяем, существует ли товар
    const product = await prisma.product.findUnique({
      where: { id: productId }
    });
    
    if (!product) {
      return res.status(404).json({
        success: false,
        error: 'Товар не найден'
      });
    }
// ✅ ДОБАВЬ ЭТУ ПРОВЕРКУ:
if (!product.isActive) {
  return res.status(400).json({
    success: false,
    error: 'Нельзя удалять неактивные товары',
    hint: 'Неактивные товары нужны для истории заказов'
  });
}
    // ============================================
    // ПРОВЕРКА: Есть ли активные заказы с этим товаром?
    // ============================================
    const activeOrdersWithProduct = await prisma.orderItem.count({
      where: {
        productId: productId,
        order: {
          status: {
            notIn: ['delivered', 'shipped', 'cancelled']
          }
        }
      }
    });

    if (activeOrdersWithProduct > 0) {
      console.log(`❌ Блокировка удаления товара ${productId}: Есть ${activeOrdersWithProduct} активных заказов`);
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить товар. Он используется в ${activeOrdersWithProduct} активных заказах.`,
        hint: 'Дождитесь завершения заказов или отмените их',
        activeOrders: activeOrdersWithProduct
      });
    }

    // ============================================
    // ПРОВЕРКА: Есть ли активные партии с этим товаром?
    // ============================================
    const activeBatchesWithProduct = await prisma.batchItem.count({
      where: {
        productId: productId,
        batch: {
          status: {
            notIn: ['completed', 'cancelled']
          }
        }
      }
    });

    if (activeBatchesWithProduct > 0) {
      console.log(`❌ Блокировка удаления товара ${productId}: Есть ${activeBatchesWithProduct} активных партий`);
      return res.status(400).json({
        success: false,
        error: `Невозможно удалить товар. Он используется в ${activeBatchesWithProduct} активных партиях.`,
        hint: 'Дождитесь завершения партий',
        activeBatches: activeBatchesWithProduct
      });
    }

    // ============================================
    // ВСЁ OK - УДАЛЯЕМ
    // ============================================
    
// ВСЁ OK - УДАЛЯЕМ

// Проверяем, используется ли товар в ЛЮБЫХ заказах (включая завершённые)
const isUsedInOrders = await prisma.orderItem.count({
  where: { productId: productId }
});

// Сохраняем снэпшот ТОЛЬКО если товар есть в заказах
if (isUsedInOrders > 0) {
  try {
    await prisma.$executeRaw`
      INSERT INTO product_snapshots (product_id, name, unit, price, created_at)
      VALUES (${productId}, ${product.name}, ${product.unit}, ${product.price}, NOW())
      ON CONFLICT (product_id) DO NOTHING
    `;
    console.log(`💾 Снэпшот товара ${productId} сохранен (используется в ${isUsedInOrders} заказах)`);
  } catch (error) {
    console.error(`⚠️ Ошибка сохранения снэпшота:`, error.message);
  }
} else {
  console.log(`ℹ️ Снэпшот товара ${productId} НЕ создан (не используется в заказах)`);
}

    // Удаляем товар (физически или мягко - выбери сам)
    // Вариант 1: Мягкое удаление
    await prisma.product.update({
      where: { id: productId },
      data: { isActive: false }
    });

    console.log(`✅ Товар #${id} (${product.name}) деактивирован`);

    res.json({
      success: true,
      message: 'Товар успешно удален',
      product: {
        id: product.id,
        name: product.name
      }
    });

  } catch (error) {
    console.error('❌ Ошибка удаления товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления товара',
      details: error.message
    });
  }
});

// POST /api/admin/batches/:id/ship-orders - Машина уехала (paid → shipped)
router.post('/batches/:id/ship-orders', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);

    // Находим все оплаченные заказы ТОЛЬКО в этой конкретной партии
    const ordersToShip = await prisma.order.findMany({
      where: {
        batchId: batchId,  // Только заказы из текущей партии
        status: 'paid'     // Только оплаченные заказы
      },
      include: {
        user: {
          select: { phone: true, firstName: true }
        }
      }
    });

    if (ordersToShip.length === 0) {
      return res.json({
        success: false,
        message: 'Нет оплаченных заказов в этой партии для отправки'
      });
    }

    // Массово обновляем статусы на 'shipped' только для заказов этой партии
    await prisma.order.updateMany({
      where: {
        batchId: batchId,
        status: 'paid'
      },
      data: {
        status: 'shipped',
        updatedAt: new Date()
      }
    });

    // Группируем заказы по номерам телефонов (один SMS на номер)
    const uniqueUsers = new Map();
    ordersToShip.forEach(order => {
      const phone = order.user.phone;
      if (!uniqueUsers.has(phone)) {
        uniqueUsers.set(phone, {
          phone: phone,
          firstName: order.user.firstName,
          ordersCount: 1
        });
      } else {
        uniqueUsers.get(phone).ordersCount++;
      }
    });

    // Отправляем одно SMS на каждый уникальный номер
    const smsPromises = Array.from(uniqueUsers.values()).map(user => {
      const message = user.ordersCount === 1 
        ? `Машина уехала за вашим заказом. Ожидайте доставку.`
        : `Машина уехала за вашими заказами (${user.ordersCount} шт). Ожидайте доставку.`;
      
      return sendSMS(user.phone, message);
    });

    await Promise.all(smsPromises);

    console.log(`✅ Отправлено SMS на ${uniqueUsers.size} уникальных номеров`);;

    console.log(`✅ Партия ${batchId}: обновлено ${ordersToShip.length} заказов на 'shipped'`);

    res.json({
      success: true,
      message: `${ordersToShip.length} заказов отправлены. SMS уведомления отправлены.`,
      ordersShipped: ordersToShip.length
    });

  } catch (error) {
    console.error('❌ Ошибка отправки заказов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка отправки заказов'
    });
  }
});

// Функция отправки SMS (использует существующий SMS сервис)
async function sendSMS(phone, text) {
  try {
    const axios = require('axios');
    
    const response = await axios.post('https://gate.smsaero.ru/v2/sms/send', {
      number: phone,
      text: text,
      sign: 'SMS Aero'
    }, {
      headers: {
        'Authorization': `Basic ${Buffer.from(`${process.env.SMS_AERO_EMAIL}:${process.env.SMS_AERO_API_KEY}`).toString('base64')}`,
        'Content-Type': 'application/json'
      }
    });
    
    console.log(`✅ SMS отправлено на ${phone}: ${response.data.success ? 'успешно' : 'ошибка'}`);
    return response.data.success;
  } catch (error) {
    console.error(`❌ Ошибка отправки SMS на ${phone}:`, error.message);
    return false;
  }
}

// POST /api/admin/batches/:id/deliver-orders - Машина приехала (shipped → delivered)
router.post('/batches/:id/deliver-orders', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);

    // Находим все отправленные заказы ТОЛЬКО в этой конкретной партии
    const ordersToDeliver = await prisma.order.findMany({
      where: {
        batchId: batchId,  // Только заказы из текущей партии
        status: 'shipped'  // Только отправленные заказы
      },
      include: {
        user: {
          select: { phone: true, firstName: true }
        }
      }
    });

    if (ordersToDeliver.length === 0) {
      return res.json({
        success: false,
        message: 'Нет отправленных заказов в этой партии для доставки'
      });
    }

    // Массово обновляем статусы на 'delivered' только для заказов этой партии
    await prisma.order.updateMany({
      where: {
        batchId: batchId,
        status: 'shipped'
      },
      data: {
        status: 'delivered',
        updatedAt: new Date()
      }
    });

    // Группируем заказы по номерам телефонов (один SMS на номер)
    const uniqueUsers = new Map();
    ordersToDeliver.forEach(order => {
      const phone = order.user.phone;
      if (!uniqueUsers.has(phone)) {
        uniqueUsers.set(phone, {
          phone: phone,
          firstName: order.user.firstName,
          ordersCount: 1
        });
      } else {
        uniqueUsers.get(phone).ordersCount++;
      }
    });

    // Отправляем одно SMS на каждый уникальный номер
    const smsPromises = Array.from(uniqueUsers.values()).map(user => {
      const message = user.ordersCount === 1 
        ? `Машина прибыла с вашим заказом. Ожидайте доставку.`
        : `Машина прибыла с вашими заказами (${user.ordersCount} шт). Ожидайте доставку.`;
      
      return sendSMS(user.phone, message);
    });

    await Promise.all(smsPromises);

    console.log(`✅ Отправлено SMS на ${uniqueUsers.size} уникальных номеров`);

    console.log(`✅ Партия ${batchId}: обновлено ${ordersToDeliver.length} заказов на 'delivered'`);

    res.json({
      success: true,
      message: `${ordersToDeliver.length} заказов доставлены. SMS уведомления отправлены.`,
      ordersDelivered: ordersToDeliver.length
    });

  } catch (error) {
    console.error('❌ Ошибка доставки заказов:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка доставки заказов'
    });
  }
});

// Добавить этот endpoint в файл src/routes/admin.js после существующих batch endpoints

// GET /api/admin/batches/:id/total-order - Получить общий заказ по партии
router.get('/batches/:id/total-order', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);
    
    // Получаем все заказы партии с деталями
    const orders = await prisma.order.findMany({
      where: { 
        batchId: batchId 
      },
      include: {
        orderItems: {
          include: {
            product: {
              include: {
                category: true
              }
            }
          }
        }
      }
    });
    
    if (orders.length === 0) {
      return res.json({
        success: true,
        totalOrder: {
          items: [],
          totalAmount: 0,
          ordersCount: 0,
          uniqueUsersCount: 0
        }
      });
    }
    
    // Агрегируем все товары из всех заказов
    const aggregatedItems = {};
    let totalAmount = 0;
    const uniqueUsers = new Set();
    
    orders.forEach(order => {
      uniqueUsers.add(order.userId);
      
      order.orderItems.forEach(item => {
        const key = `product_${item.productId}`;
        
        if (!aggregatedItems[key]) {
          aggregatedItems[key] = {
            productId: item.productId,
            productName: item.product.name,
            category: item.product.category?.name || 'Без категории',
            unit: item.product.unit,
            price: parseFloat(item.price),
            quantity: 0,
            totalSum: 0
          };
        }
        
        aggregatedItems[key].quantity += item.quantity;
        const itemTotal = item.quantity * parseFloat(item.price);
        aggregatedItems[key].totalSum += itemTotal;
        totalAmount += itemTotal;
      });
    });
    
    // Преобразуем объект в массив и сортируем
    const items = Object.values(aggregatedItems).sort((a, b) => {
      // Сначала по категории, потом по имени
      if (a.category !== b.category) {
        return a.category.localeCompare(b.category);
      }
      return a.productName.localeCompare(b.productName);
    });
    
    res.json({
      success: true,
      totalOrder: {
        items: items,
        totalAmount: totalAmount,
        ordersCount: orders.length,
        uniqueUsersCount: uniqueUsers.size,
        // Группировка по категориям для удобства
        byCategory: items.reduce((acc, item) => {
          if (!acc[item.category]) {
            acc[item.category] = {
              items: [],
              totalSum: 0
            };
          }
          acc[item.category].items.push(item);
          acc[item.category].totalSum += item.totalSum;
          return acc;
        }, {})
      }
    });
    
  } catch (error) {
    console.error('❌ Ошибка получения общего заказа:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения общего заказа'
    });
  }
});

// Добавить этот endpoint в файл src/routes/admin.js после endpoint /batches/:id/total-order

// GET /api/admin/batches/:id/orders-by-users - Получить заказы сгруппированные по пользователям
router.get('/batches/:id/orders-by-users', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const batchId = parseInt(id);
    
    // Получаем все заказы партии с деталями
    const orders = await prisma.order.findMany({
      where: { 
        batchId: batchId 
      },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            phone: true,
            email: true
          }
        },
        address: {
          select: {
            address: true,
            title: true
          }
        },
        orderItems: {
          include: {
            product: {
              include: {
                category: true
              }
            }
          }
        }
      }
    });
    
    if (orders.length === 0) {
      return res.json({
        success: true,
        userOrders: [],
        totalUsers: 0,
        totalAmount: 0
      });
    }
    
    // Группируем заказы по пользователям
    const userOrdersMap = {};
    let grandTotal = 0;
    
    orders.forEach(order => {
      const userId = order.user.id;
      const userKey = `user_${userId}`;
      
      if (!userOrdersMap[userKey]) {
        userOrdersMap[userKey] = {
          userId: userId,
          userName: `${order.user.firstName} ${order.user.lastName || ''}`.trim(),
          phone: order.user.phone,
          email: order.user.email || null,
          // Берем адрес из последнего заказа
          address: order.address?.address || 'Не указан',
          orders: [],
          items: {},
          totalAmount: 0,
          ordersCount: 0
        };
      }
      
      // Добавляем информацию о заказе
      userOrdersMap[userKey].orders.push({
        orderId: order.id,
        status: order.status,
        amount: parseFloat(order.totalAmount),
        createdAt: order.createdAt
      });
      
      userOrdersMap[userKey].ordersCount++;
      const orderTotal = parseFloat(order.totalAmount);
      userOrdersMap[userKey].totalAmount += orderTotal;
      grandTotal += orderTotal;
      
      // Агрегируем товары пользователя
      order.orderItems.forEach(item => {
        const productKey = `product_${item.productId}`;
        
        if (!userOrdersMap[userKey].items[productKey]) {
          userOrdersMap[userKey].items[productKey] = {
            productId: item.productId,
            productName: item.product.name,
            category: item.product.category?.name || 'Без категории',
            unit: item.product.unit,
            price: parseFloat(item.price),
            quantity: 0,
            totalSum: 0
          };
        }
        
        userOrdersMap[userKey].items[productKey].quantity += item.quantity;
        userOrdersMap[userKey].items[productKey].totalSum += item.quantity * parseFloat(item.price);
      });
    });
    
    // Преобразуем в массив и сортируем
    const userOrders = Object.values(userOrdersMap).map(user => ({
      ...user,
      // Преобразуем объект items в массив
      items: Object.values(user.items).sort((a, b) => 
        a.productName.localeCompare(b.productName)
      )
    })).sort((a, b) => a.userName.localeCompare(b.userName));
    
    res.json({
      success: true,
      userOrders: userOrders,
      totalUsers: userOrders.length,
      totalAmount: grandTotal,
      summary: {
        totalOrders: orders.length,
        averageOrderAmount: grandTotal / orders.length,
        averagePerUser: grandTotal / userOrders.length
      }
    });
    
  } catch (error) {
    console.error('❌ Ошибка получения заказов по пользователям:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения заказов по пользователям'
    });
  }
});

// Добавить этот код в файл src/routes/admin.js после существующих endpoints

// DELETE /api/admin/users/:id - Удалить пользователя
router.delete('/users/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id);
    
    // Защита от удаления самого себя
    if (req.user && req.user.id === userId) {
      return res.status(400).json({
        success: false,
        error: 'Невозможно удалить свой собственный аккаунт'
      });
    }
    
    // Проверяем, существует ли пользователь
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        _count: {
          select: {
            orders: true
          }
        }
      }
    });
    
    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'Пользователь не найден'
      });
    }
    
    // Проверяем наличие заказов
    if (user._count.orders > 0) {
      // Проверяем статусы заказов подробнее
      const activeOrders = await prisma.order.count({
        where: {
          userId: userId,
          status: {
            notIn: ['cancelled', 'delivered', 'completed']
          }
        }
      });
      
      if (activeOrders > 0) {
        return res.status(400).json({
          success: false,
          error: `Невозможно удалить пользователя с активными заказами (${activeOrders} активных заказов). Сначала завершите или отмените их.`
        });
      }
      
      // Если есть только завершенные заказы, предлагаем деактивировать
      return res.status(400).json({
        success: false,
        error: `У пользователя есть ${user._count.orders} заказов в истории. Рекомендуется деактивировать пользователя вместо удаления.`,
        suggestion: 'deactivate'
      });
    }
    
    // Транзакция для безопасного удаления
    await prisma.$transaction(async (tx) => {
      // Удаляем адреса (хотя CASCADE сделает это автоматически, но для явности)
      await tx.address.deleteMany({
        where: { userId: userId }
      });
      
      // Удаляем пользователя
      await tx.user.delete({
        where: { id: userId }
      });
    });
    
    console.log(`✅ Пользователь #${userId} (${user.phone}) удален администратором`);
    
    res.json({
      success: true,
      message: 'Пользователь успешно удален'
    });
    
  } catch (error) {
    console.error('❌ Ошибка удаления пользователя:', error);
    
    // Обработка ошибки внешнего ключа
    if (error.code === 'P2003') {
      return res.status(400).json({
        success: false,
        error: 'Невозможно удалить пользователя из-за связанных данных в системе'
      });
    }
    
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления пользователя'
    });
  }
});

// PUT /api/admin/users/:id/deactivate - Деактивировать пользователя (альтернатива удалению)
router.put('/users/:id/deactivate', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id);
    
    const user = await prisma.user.update({
      where: { id: userId },
      data: {
        isActive: false,
        updatedAt: new Date()
      }
    });
    
    console.log(`⛔ Пользователь #${userId} (${user.phone}) деактивирован`);
    
    res.json({
      success: true,
      message: 'Пользователь деактивирован',
      user: {
        id: user.id,
        phone: user.phone,
        firstName: user.firstName,
        isActive: user.isActive
      }
    });
    
  } catch (error) {
    console.error('❌ Ошибка деактивации пользователя:', error);
    
    if (error.code === 'P2025') {
      return res.status(404).json({
        success: false,
        error: 'Пользователь не найден'
      });
    }
    
    res.status(500).json({
      success: false,
      error: 'Ошибка деактивации пользователя'
    });
  }
});


// GET /api/admin/products/low-stock - Получить товары с низкими остатками
router.get('/products/low-stock', adminAuth, async (req, res) => {
  try {
    const threshold = parseInt(req.query.threshold) || 10;
    
    const products = await prisma.product.findMany({
      where: {
        maxQuantity: {
          not: null,
          lte: threshold
        },
        isActive: true
      },
      include: {
        category: true
      },
      orderBy: {
        maxQuantity: 'asc'
      }
    });
    
    res.json({
      success: true,
      products: products.map(p => ({
        id: p.id,
        name: p.name,
        category: p.category?.name,
        price: p.price,
        unit: p.unit,
        maxQuantity: p.maxQuantity,
        isLowStock: p.maxQuantity <= 5,
        isOutOfStock: p.maxQuantity === 0
      })),
      count: products.length,
      threshold
    });
    
  } catch (error) {
    console.error('❌ Ошибка получения товаров с низкими остатками:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения данных'
    });
  }
});

// POST /api/admin/products/:id/add-stock - Быстрое добавление остатков
router.post('/products/:id/add-stock', adminAuth, async (req, res) => {
  try {
    const productId = parseInt(req.params.id);
    const { amount } = req.body;
    
    if (!amount || amount <= 0) {
      return res.status(400).json({
        success: false,
        error: 'Количество должно быть больше 0'
      });
    }
    
    const product = await prisma.product.findUnique({
      where: { id: productId }
    });
    
    if (!product) {
      return res.status(404).json({
        success: false,
        error: 'Товар не найден'
      });
    }
    
    const currentQuantity = product.maxQuantity || 0;
    const newQuantity = currentQuantity + parseInt(amount);
    
    const updatedProduct = await prisma.product.update({
      where: { id: productId },
      data: { maxQuantity: newQuantity },
      include: { category: true }
    });
    
    console.log(`✅ Остаток товара "${product.name}" увеличен на ${amount}: ${currentQuantity} → ${newQuantity}`);
    
    res.json({
      success: true,
      product: updatedProduct,
      added: amount,
      previousQuantity: currentQuantity,
      newQuantity
    });
    
  } catch (error) {
    console.error('❌ Ошибка добавления остатков:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка добавления остатков'
    });
  }
});

// ==========================================
// УПРАВЛЕНИЕ РЕЖИМОМ ОБСЛУЖИВАНИЯ
// ==========================================

// GET /api/admin/maintenance - Получить текущий статус режима обслуживания
router.get('/maintenance', authenticateToken, async (req, res) => {
  try {
    const settings = await prisma.systemSettings.findMany({
      where: {
        key: {
          in: [
            'maintenance_mode',
            'maintenance_message',
            'maintenance_end_time', 
            'allowed_phones'
          ]
        }
      }
    });
    
    // Преобразуем в объект
    const maintenanceConfig = {
      enabled: false,
      message: 'Проводятся технические работы',
      end_time: null,
      allowed_phones: []
    };
    
    settings.forEach(s => {
      switch(s.key) {
        case 'maintenance_mode':
          maintenanceConfig.enabled = s.value === 'true';
          break;
        case 'maintenance_message':
          maintenanceConfig.message = s.value;
          break;
        case 'maintenance_end_time':
          maintenanceConfig.end_time = s.value;
          break;
        case 'allowed_phones':
          try {
            maintenanceConfig.allowed_phones = JSON.parse(s.value);
          } catch {
            maintenanceConfig.allowed_phones = s.value ? s.value.split(',').map(p => p.trim()) : [];
          }
          break;
      }
    });
    
    res.json({
      success: true,
      maintenance: maintenanceConfig
    });
    
  } catch (error) {
    console.error('Ошибка получения статуса обслуживания:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка получения статуса'
    });
  }
});

// PUT /api/admin/maintenance - Включить/выключить режим обслуживания
router.put('/maintenance', authenticateToken, async (req, res) => {
  try {
    const { 
      enabled, 
      message, 
      end_time,
      allowed_phones 
    } = req.body;
    
    // Обновляем режим обслуживания
    if (typeof enabled !== 'undefined') {
      await prisma.systemSettings.upsert({
        where: { key: 'maintenance_mode' },
        update: { 
          value: enabled ? 'true' : 'false',
          updatedAt: new Date()
        },
        create: {
          key: 'maintenance_mode',
          value: enabled ? 'true' : 'false',
          description: 'Режим технического обслуживания'
        }
      });
      
      console.log(`🔧 Режим обслуживания ${enabled ? 'ВКЛЮЧЕН' : 'ВЫКЛЮЧЕН'}`);
    }
    
    // Обновляем сообщение
    if (message) {
      await prisma.systemSettings.upsert({
        where: { key: 'maintenance_message' },
        update: { 
          value: message,
          updatedAt: new Date()
        },
        create: {
          key: 'maintenance_message',
          value: message,
          description: 'Сообщение при техническом обслуживании'
        }
      });
    }
    
    // Обновляем время окончания
    if (end_time !== undefined) {
      await prisma.systemSettings.upsert({
        where: { key: 'maintenance_end_time' },
        update: { 
          value: end_time || '',
          updatedAt: new Date()
        },
        create: {
          key: 'maintenance_end_time',
          value: end_time || '',
          description: 'Планируемое время окончания обслуживания'
        }
      });
    }
    
    // Обновляем список разрешенных телефонов
    if (allowed_phones) {
      const phonesStr = Array.isArray(allowed_phones) 
        ? JSON.stringify(allowed_phones)
        : allowed_phones;
        
      await prisma.systemSettings.upsert({
        where: { key: 'allowed_phones' },
        update: { 
          value: phonesStr,
          updatedAt: new Date()
        },
        create: {
          key: 'allowed_phones',
          value: phonesStr,
          description: 'Телефоны с доступом во время обслуживания'
        }
      });
    }
    
    res.json({
      success: true,
      message: `Режим обслуживания ${enabled ? 'включен' : 'выключен'}`,
      maintenance: {
        enabled: enabled,
        message: message,
        end_time: end_time,
        allowed_phones: allowed_phones
      }
    });
    
  } catch (error) {
    console.error('Ошибка изменения режима обслуживания:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка изменения настроек'
    });
  }
});

// POST /api/admin/maintenance/allow-phone - Добавить телефон в белый список
router.post('/maintenance/allow-phone', authenticateToken, async (req, res) => {
  try {
    const { phone } = req.body;
    
    if (!phone) {
      return res.status(400).json({
        success: false,
        error: 'Телефон не указан'
      });
    }
    
    // Получаем текущий список
    const setting = await prisma.systemSettings.findUnique({
      where: { key: 'allowed_phones' }
    });
    
    let phones = [];
    if (setting) {
      try {
        phones = JSON.parse(setting.value);
      } catch {
        phones = setting.value ? setting.value.split(',').map(p => p.trim()) : [];
      }
    }
    
    // Добавляем новый телефон если его нет
    if (!phones.includes(phone)) {
      phones.push(phone);
      
      await prisma.systemSettings.upsert({
        where: { key: 'allowed_phones' },
        update: {
          value: JSON.stringify(phones),
          updatedAt: new Date()
        },
        create: {
          key: 'allowed_phones',
          value: JSON.stringify(phones),
          description: 'Телефоны с доступом во время обслуживания'
        }
      });
      
      console.log(`✅ Телефон ${phone} добавлен в белый список`);
      
      res.json({
        success: true,
        message: 'Телефон добавлен в белый список',
        allowed_phones: phones
      });
    } else {
      res.json({
        success: true,
        message: 'Телефон уже в белом списке',
        allowed_phones: phones
      });
    }
    
  } catch (error) {
    console.error('Ошибка добавления телефона:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка добавления телефона'
    });
  }
});

// DELETE /api/admin/maintenance/allow-phone - Удалить телефон из белого списка
router.delete('/maintenance/allow-phone/:phone', authenticateToken, async (req, res) => {
  try {
    const { phone } = req.params;
    
    // Получаем текущий список
    const setting = await prisma.systemSettings.findUnique({
      where: { key: 'allowed_phones' }
    });
    
    let phones = [];
    if (setting) {
      try {
        phones = JSON.parse(setting.value);
      } catch {
        phones = setting.value ? setting.value.split(',').map(p => p.trim()) : [];
      }
    }
    
    // Удаляем телефон
    phones = phones.filter(p => p !== phone);
    
    await prisma.systemSettings.upsert({
      where: { key: 'allowed_phones' },
      update: {
        value: JSON.stringify(phones),
        updatedAt: new Date()
      },
      create: {
        key: 'allowed_phones',
        value: JSON.stringify(phones),
        description: 'Телефоны с доступом во время обслуживания'
      }
    });
    
    console.log(`❌ Телефон ${phone} удален из белого списка`);
    
    res.json({
      success: true,
      message: 'Телефон удален из белого списка',
      allowed_phones: phones
    });
    
  } catch (error) {
    console.error('Ошибка удаления телефона:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления телефона'
    });
  }
});

module.exports = router;
