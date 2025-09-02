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

// POST /api/admin/products - Создать новый товар
router.post('/products', adminAuth, async (req, res) => {
  try {
    const { 
      name, 
      description, 
      price, 
      unit, 
      minQuantity, 
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
        categoryId: parseInt(categoryId),
        imageUrl: imageUrl || null,
        isActive: true  // Используем isActive вместо available
      },
      include: {
        category: true
      }
    });

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


// PUT /api/admin/products/:id - Обновить товар
router.put('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    const updateData = req.body;

    // Преобразуем числовые поля
    if (updateData.price) updateData.price = parseFloat(updateData.price);
    if (updateData.minQuantity) updateData.minQuantity = parseFloat(updateData.minQuantity);
    if (updateData.categoryId) updateData.categoryId = parseInt(updateData.categoryId);

    const product = await prisma.product.update({
      where: { id: parseInt(id) },
      data: updateData,
      include: {
        category: true
      }
    });

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

// DELETE /api/admin/products/:id - Удалить товар
router.delete('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;

    await prisma.product.delete({
      where: { id: parseInt(id) }
    });

    res.json({
      success: true,
      message: 'Товар удален успешно'
    });
  } catch (error) {
    console.error('❌ Ошибка удаления товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления товара'
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

// DELETE /api/admin/products/:id - Удалить товар
router.delete('/products/:id', adminAuth, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Проверяем, существует ли товар
    const product = await prisma.product.findUnique({
      where: { id: parseInt(id) }
    });
    
    if (!product) {
      return res.status(404).json({
        success: false,
        error: 'Товар не найден'
      });
    }
    
    // Проверяем, нет ли связанных заказов
    const orderItems = await prisma.orderItem.count({
      where: { productId: parseInt(id) }
    });
    
    if (orderItems > 0) {
      return res.status(400).json({
        success: false,
        error: 'Невозможно удалить товар, так как он используется в заказах'
      });
    }

    // Удаляем товар
    await prisma.product.delete({
      where: { id: parseInt(id) }
    });

    res.json({
      success: true,
      message: 'Товар удален успешно'
    });
  } catch (error) {
    console.error('❌ Ошибка удаления товара:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления товара'
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
        ? `Машина прибыла с вашим заказом. Можете забирать.`
        : `Машина прибыла с вашими заказами (${user.ordersCount} шт). Можете забирать.`;
      
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

module.exports = router;
