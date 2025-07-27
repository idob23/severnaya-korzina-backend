// src/routes/admin-auth.js - НОВЫЙ РОУТ ДЛЯ АДМИНА
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { PrismaClient } = require('@prisma/client');

const router = express.Router();
const prisma = new PrismaClient();

// POST /api/admin-auth/login - Простой вход для админа
router.post('/login', async (req, res) => {
  try {
    const { login, password } = req.body;

    console.log('🔐 Попытка входа админа:', { login });

    // Простая проверка логина и пароля
    if (login !== 'admin' || password !== 'admin') {
      console.log('❌ Неверный логин или пароль');
      return res.status(401).json({
        success: false,
        error: 'Неверный логин или пароль'
      });
    }

    console.log('✅ Админ вошел в систему');

    // Создаем JWT токен для админа
    const token = jwt.sign(
      { 
        userId: 'admin-id', 
        login: 'admin',
        role: 'admin'
      },
      process.env.JWT_SECRET,
      { expiresIn: '24h' } // Токен на 24 часа
    );

    res.json({
      success: true,
      message: 'Вход выполнен успешно',
      user: {
        id: 'admin-id',
        login: 'admin',
        firstName: 'Администратор',
        lastName: 'Системы',
        email: 'admin@severnaya-korzina.ru',
        role: 'admin',
        isActive: true
      },
      token
    });

  } catch (error) {
    console.error('❌ Ошибка входа админа:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/admin-auth/profile - Получить профиль админа
router.get('/profile', async (req, res) => {
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

    // Проверяем токен
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Недостаточно прав'
      });
    }

    res.json({
      success: true,
      user: {
        id: 'admin-id',
        login: 'admin',
        firstName: 'Администратор',
        lastName: 'Системы',
        email: 'admin@severnaya-korzina.ru',
        role: 'admin',
        isActive: true
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения профиля админа:', error);
    
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({
        success: false,
        error: 'Недействительный токен'
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: 'Токен истек'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/admin-auth/check - Проверка токена админа
router.get('/check', async (req, res) => {
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

    // Проверяем токен
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    if (decoded.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: 'Недостаточно прав'
      });
    }

    res.json({
      success: true,
      message: 'Токен действителен',
      user: {
        id: decoded.userId,
        login: decoded.login,
        role: decoded.role
      }
    });

  } catch (error) {
    console.error('❌ Ошибка проверки токена админа:', error);
    
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({
        success: false,
        error: 'Недействительный токен'
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({
        success: false,
        error: 'Токен истек'
      });
    }

    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;