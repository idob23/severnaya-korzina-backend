// src/routes/addresses.js
const express = require('express');
const { PrismaClient } = require('@prisma/client');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();
const prisma = new PrismaClient();

// Все маршруты требуют авторизации
router.use(authenticateToken);

// GET /api/addresses - Получить все адреса пользователя
router.get('/', async (req, res) => {
  try {
    const addresses = await prisma.address.findMany({
      where: { userId: req.user.id },
      orderBy: [
        { isDefault: 'desc' },
        { createdAt: 'desc' }
      ]
    });

    res.json({ addresses });

  } catch (error) {
    console.error('Ошибка получения адресов:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

// POST /api/addresses - Добавить новый адрес
router.post('/', async (req, res) => {
  try {
    const { title, address, isDefault } = req.body;

    if (!title || !address) {
      return res.status(400).json({
        error: 'Название и адрес обязательны'
      });
    }

    // Если новый адрес должен стать основным, сбрасываем флаг у других
    if (isDefault) {
      await prisma.address.updateMany({
        where: { 
          userId: req.user.id,
          isDefault: true 
        },
        data: { isDefault: false }
      });
    }

    const newAddress = await prisma.address.create({
      data: {
        userId: req.user.id,
        title,
        address,
        isDefault: isDefault || false
      }
    });

    res.status(201).json({
      message: 'Адрес добавлен успешно',
      address: newAddress
    });

  } catch (error) {
    console.error('Ошибка добавления адреса:', error);
    res.status(500).json({
      error: 'Внутренняя ошибка сервера'
    });
  }
});

module.exports = router;