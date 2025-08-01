// src/middleware/auth.js - ИСПРАВЛЕННАЯ ВЕРСИЯ

const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// Middleware для проверки JWT токена (поддерживает и обычных пользователей, и админов)
const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith('Bearer ') 
      ? authHeader.slice(7) 
      : null;

    if (!token) {
      return res.status(401).json({
        error: 'Токен доступа не предоставлен'
      });
    }

    // Проверяем токен
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // ИСПРАВЛЕНИЕ: Проверяем тип токена (админ или обычный пользователь)
    if (decoded.role === 'admin') {
      // Админский токен
      req.user = {
        id: 'admin-id',
        login: decoded.login || 'admin',
        firstName: 'Администратор',
        lastName: 'Системы',
        phone: '+79999999999',
        email: 'admin@severnaya-korzina.ru',
        role: 'admin',
        isActive: true
      };
      
      console.log('✅ Админ аутентифицирован:', decoded.login);
      next();
      return;
    }

    // Обычный пользователь - ищем в базе данных
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: {
        id: true,
        phone: true,
        firstName: true,
        lastName: true,
        email: true,
        isActive: true
      }
    });

    if (!user) {
      return res.status(401).json({
        error: 'Пользователь не найден'
      });
    }

    if (!user.isActive) {
      return res.status(403).json({
        error: 'Аккаунт заблокирован'
      });
    }

    // Добавляем пользователя в req для использования в роутах
    req.user = user;
    next();

  } catch (error) {
    console.error('Ошибка проверки токена:', error);
    
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({
        error: 'Недействительный токен'
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        error: 'Токен истек'
      });
    }

    return res.status(500).json({
      error: 'Ошибка проверки авторизации'
    });
  }
};

// Middleware для проверки роли администратора
const requireAdmin = async (req, res, next) => {
  try {
    // Проверяем что пользователь админ
    if (req.user?.role === 'admin') {
      next();
      return;
    }

    // Или проверяем что это админский телефон
    const adminPhones = process.env.ADMIN_PHONES?.split(',') || [];
    if (adminPhones.includes(req.user?.phone)) {
      next();
      return;
    }

    return res.status(403).json({
      error: 'Доступ запрещен. Требуются права администратора'
    });

  } catch (error) {
    console.error('Ошибка проверки прав администратора:', error);
    res.status(500).json({
      error: 'Ошибка проверки прав доступа'
    });
  }
};

module.exports = {
  authenticateToken,
  requireAdmin
};