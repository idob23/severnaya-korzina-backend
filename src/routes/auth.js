// src/routes/auth.js - ИСПРАВЛЕННАЯ ВЕРСИЯ
const express = require('express');
const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// POST /api/auth/register - Регистрация пользователя
router.post('/register', async (req, res) => {
  try {
    const { phone, firstName, lastName, email } = req.body;

    console.log('🔐 Попытка регистрации:', { phone, firstName, lastName, email });

    if (!phone || !firstName) {
      return res.status(400).json({
        success: false,
        error: 'Телефон и имя обязательны'
      });
    }

    // Проверяем, существует ли пользователь
    const existingUser = await prisma.user.findUnique({
      where: { phone }
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        error: 'Пользователь с таким номером уже существует'
      });
    }

    // Создаем пользователя
    const user = await prisma.user.create({
      data: {
        phone,
        firstName,
        lastName: lastName || null,
        email: email || null
      }
    });

    console.log('✅ Пользователь создан:', user.id);

    // Генерируем JWT токен
    const token = jwt.sign(
      { userId: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.status(201).json({
      success: true,
      message: 'Пользователь зарегистрирован успешно',
      user: {
        id: user.id,
        phone: user.phone,
        name: user.firstName, // ИСПРАВЛЕНО: возвращаем как 'name'
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        createdAt: user.createdAt,
        isActive: user.isActive
      },
      token
    });

  } catch (error) {
    console.error('❌ Ошибка регистрации:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/auth/login - Вход пользователя
router.post('/login', async (req, res) => {
  try {
    const { phone, smsCode } = req.body;

    console.log('🔐 Попытка входа:', { phone, smsCode });

    if (!phone) {
      return res.status(400).json({
        success: false,
        error: 'Номер телефона обязателен'
      });
    }

    // Для тестирования принимаем код 1234
    if (smsCode && smsCode !== '1234') {
      console.log('❌ Неверный SMS код:', smsCode);
      return res.status(400).json({
        success: false,
        error: 'Неверный SMS код'
      });
    }

    // Ищем пользователя
    const user = await prisma.user.findUnique({
      where: { phone },
      include: {
        addresses: true
      }
    });

    if (!user) {
      console.log('❌ Пользователь не найден:', phone);
      
      // АВТОМАТИЧЕСКИ СОЗДАЕМ ПОЛЬЗОВАТЕЛЯ ДЛЯ ТЕСТИРОВАНИЯ
      console.log('🔧 Создаем нового пользователя для:', phone);
      
      const newUser = await prisma.user.create({
        data: {
          phone,
          firstName: 'Тестовый пользователь',
          lastName: null,
          email: null
        },
        include: {
          addresses: true
        }
      });

      console.log('✅ Новый пользователь создан:', newUser.id);

      // Генерируем JWT токен для нового пользователя
      const token = jwt.sign(
        { userId: newUser.id, phone: newUser.phone },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
      );

      return res.json({
        success: true,
        message: 'Вход выполнен успешно',
        user: {
          id: newUser.id,
          phone: newUser.phone,
          name: newUser.firstName, // ИСПРАВЛЕНО: возвращаем как 'name'
          firstName: newUser.firstName,
          lastName: newUser.lastName,
          email: newUser.email,
          createdAt: newUser.createdAt,
          isActive: newUser.isActive,
          addresses: newUser.addresses || []
        },
        token
      });
    }

    if (!user.isActive) {
      console.log('❌ Аккаунт заблокирован:', phone);
      return res.status(403).json({
        success: false,
        error: 'Аккаунт заблокирован'
      });
    }

    console.log('✅ Пользователь найден:', user.id);

    // Генерируем JWT токен
    const token = jwt.sign(
      { userId: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.json({
      success: true,
      message: 'Вход выполнен успешно',
      user: {
        id: user.id,
        phone: user.phone,
        name: user.firstName, // ИСПРАВЛЕНО: возвращаем как 'name'
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        createdAt: user.createdAt,
        isActive: user.isActive,
        addresses: user.addresses || []
      },
      token
    });

  } catch (error) {
    console.error('❌ Ошибка входа:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/auth/profile - Получить профиль пользователя
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    console.log('👤 Запрос профиля пользователя:', req.user.id);

    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        addresses: true
      }
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        error: 'Пользователь не найден'
      });
    }

    res.json({
      success: true,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.firstName, // ИСПРАВЛЕНО: возвращаем как 'name'
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        createdAt: user.createdAt,
        isActive: user.isActive,
        addresses: user.addresses || []
      }
    });

  } catch (error) {
    console.error('❌ Ошибка получения профиля:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/auth/check - Проверка токена
router.get('/check', authenticateToken, async (req, res) => {
  try {
    res.json({
      success: true,
      message: 'Токен действителен',
      user: req.user
    });
  } catch (error) {
    console.error('❌ Ошибка проверки токена:', error);
    res.status(500).json({
      success: false,
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;