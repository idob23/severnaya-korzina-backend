// src/middleware/safety.js - ДОПОЛНИТЕЛЬНЫЕ МЕРЫ БЕЗОПАСНОСТИ
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Middleware для проверки статуса пользователя при каждом запросе
const checkUserStatus = async (req, res, next) => {
  try {
    if (req.user && req.user.id) {
      // Проверяем актуальный статус пользователя из БД
      const currentUser = await prisma.user.findUnique({
        where: { id: req.user.id },
        select: { isActive: true }
      });

      if (!currentUser || !currentUser.isActive) {
        return res.status(403).json({
          error: 'Аккаунт заблокирован администратором',
          code: 'ACCOUNT_BLOCKED'
        });
      }
    }
    next();
  } catch (error) {
    console.error('Ошибка проверки статуса пользователя:', error);
    next();
  }
};

// Middleware для проверки доступности товаров
const checkProductAvailability = async (req, res, next) => {
  try {
    if (req.body.items && Array.isArray(req.body.items)) {
      const productIds = req.body.items.map(item => item.productId);
      
      const products = await prisma.product.findMany({
        where: {
          id: { in: productIds },
          isActive: true
        },
        select: { id: true, price: true, name: true }
      });

      // Проверяем, что все товары доступны
      const unavailableProducts = productIds.filter(
        id => !products.find(p => p.id === id)
      );

      if (unavailableProducts.length > 0) {
        return res.status(400).json({
          error: 'Некоторые товары больше не доступны',
          unavailableProducts,
          code: 'PRODUCTS_UNAVAILABLE'
        });
      }

      // Обновляем цены в заказе до актуальных
      req.body.items = req.body.items.map(item => {
        const product = products.find(p => p.id === item.productId);
        return {
          ...item,
          price: product ? product.price : item.price,
          productName: product ? product.name : item.productName
        };
      });
    }
    next();
  } catch (error) {
    console.error('Ошибка проверки доступности товаров:', error);
    next();
  }
};

// Логирование критических изменений админа
const logAdminAction = (action) => {
  return async (req, res, next) => {
    const originalSend = res.send;
    
    res.send = function(data) {
      // Логируем успешные операции
      if (res.statusCode >= 200 && res.statusCode < 300) {
        console.log(`📝 ADMIN ACTION: ${action}`, {
          admin: req.user?.phone || 'unknown',
          timestamp: new Date().toISOString(),
          request: {
            method: req.method,
            url: req.originalUrl,
            body: req.body
          },
          ip: req.ip
        });
      }
      
      originalSend.call(this, data);
    };
    
    next();
  };
};

// Защита от случайного массового удаления
const preventBulkDeletion = (req, res, next) => {
  const dangerousActions = [
    'DELETE /api/admin/products',
    'DELETE /api/admin/users',
    'PUT /api/admin/users/bulk'
  ];

  const currentAction = `${req.method} ${req.route?.path || req.originalUrl}`;
  
  if (dangerousActions.some(action => currentAction.includes(action.split(' ')[1]))) {
    // Требуем специальный заголовок для массовых операций
    if (!req.headers['x-confirm-bulk-action']) {
      return res.status(400).json({
        error: 'Массовые операции требуют подтверждения',
        code: 'BULK_CONFIRMATION_REQUIRED',
        hint: 'Добавьте заголовок X-Confirm-Bulk-Action: true'
      });
    }
  }
  
  next();
};

module.exports = {
  checkUserStatus,
  checkProductAvailability,
  logAdminAction,
  preventBulkDeletion
};