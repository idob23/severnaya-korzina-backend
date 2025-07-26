// src/routes/auth.js
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

    if (!phone || !firstName) {
      return res.status(400).json({
        error: 'Телефон и имя обязательны'
      });
    }

    // Проверяем, существует ли пользователь
    const existingUser = await prisma.user.findUnique({
      where: { phone }
    });

    if (existingUser) {
      return res.status(400).json({
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

    // Генерируем JWT токен
    const token = jwt.sign(
      { userId: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.status(201).json({
      message: 'Пользователь зарегистрирован успешно',
      user: {
        id: user.id,
        phone: user.phone,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email
      },
      token
    });

  } catch (error) {
    console.error('Ошибка регистрации:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/auth/login - Вход пользователя
router.post('/login', async (req, res) => {
  try {
    const { phone, smsCode } = req.body;

    if (!phone) {
      return res.status(400).json({
        error: 'Номер телефона обязателен'
      });
    }

    // Для тестирования принимаем код 1234
    if (smsCode && smsCode !== '1234') {
      return res.status(400).json({
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
      return res.status(404).json({
        error: 'Пользователь не найден'
      });
    }

    if (!user.isActive) {
      return res.status(403).json({
        error: 'Аккаунт заблокирован'
      });
    }

    // Генерируем JWT токен
    const token = jwt.sign(
      { userId: user.id, phone: user.phone },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.json({
      message: 'Вход выполнен успешно',
      user: {
        id: user.id,
        phone: user.phone,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        addresses: user.addresses
      },
      token
    });

  } catch (error) {
    console.error('Ошибка входа:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// GET /api/auth/profile - Получить профиль пользователя
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: {
        addresses: true
      }
    });

    res.json({
      user: {
        id: user.id,
        phone: user.phone,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        addresses: user.addresses
      }
    });

  } catch (error) {
    console.error('Ошибка получения профиля:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;