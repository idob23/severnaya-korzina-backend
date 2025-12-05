// src/routes/category-images.js
const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

// Создаём папку для загрузки если её нет
const uploadDir = path.join(__dirname, '../../uploads/categories');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
  console.log('📁 Создана папка для картинок категорий:', uploadDir);
}

// Настройка multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    const ext = path.extname(file.originalname);
    cb(null, 'category-' + uniqueSuffix + ext);
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB максимум
  },
  fileFilter: function (req, file, cb) {
    const allowedTypes = /jpeg|jpg|png|gif|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error('Только изображения разрешены (jpeg, jpg, png, gif, webp)'));
    }
  }
});

// POST /api/categories/:id/image - Загрузить картинку категории
router.post('/:id/image', upload.single('image'), async (req, res) => {
  try {
    const categoryId = parseInt(req.params.id);

    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Файл не загружен'
      });
    }

    // Проверяем существование категории
    const category = await prisma.category.findUnique({
      where: { id: categoryId }
    });

    if (!category) {
      // Удаляем загруженный файл
      fs.unlinkSync(req.file.path);
      return res.status(404).json({
        success: false,
        error: 'Категория не найдена'
      });
    }

    // Удаляем старую картинку если была
    if (category.imageUrl) {
      const oldImagePath = path.join(__dirname, '../../uploads/categories', path.basename(category.imageUrl));
      if (fs.existsSync(oldImagePath)) {
        fs.unlinkSync(oldImagePath);
        console.log('🗑️ Удалена старая картинка:', oldImagePath);
      }
    }

    // Формируем URL для картинки
    const imageUrl = `/uploads/categories/${req.file.filename}`;

    // Обновляем категорию
    const updatedCategory = await prisma.category.update({
      where: { id: categoryId },
      data: { imageUrl: imageUrl }
    });

    console.log(`✅ Картинка загружена для категории #${categoryId}: ${imageUrl}`);

    res.json({
      success: true,
      imageUrl: imageUrl,
      category: updatedCategory
    });

  } catch (error) {
    console.error('❌ Ошибка загрузки картинки:', error);
    
    // Удаляем файл при ошибке
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }

    res.status(500).json({
      success: false,
      error: 'Ошибка загрузки картинки: ' + error.message
    });
  }
});

// DELETE /api/categories/:id/image - Удалить картинку категории
router.delete('/:id/image', async (req, res) => {
  try {
    const categoryId = parseInt(req.params.id);

    const category = await prisma.category.findUnique({
      where: { id: categoryId }
    });

    if (!category) {
      return res.status(404).json({
        success: false,
        error: 'Категория не найдена'
      });
    }

    if (!category.imageUrl) {
      return res.status(400).json({
        success: false,
        error: 'У категории нет картинки'
      });
    }

    // Удаляем файл
    const imagePath = path.join(__dirname, '../../uploads/categories', path.basename(category.imageUrl));
    if (fs.existsSync(imagePath)) {
      fs.unlinkSync(imagePath);
      console.log('🗑️ Удалена картинка:', imagePath);
    }

    // Обновляем категорию
    const updatedCategory = await prisma.category.update({
      where: { id: categoryId },
      data: { imageUrl: null }
    });

    res.json({
      success: true,
      category: updatedCategory
    });

  } catch (error) {
    console.error('❌ Ошибка удаления картинки:', error);
    res.status(500).json({
      success: false,
      error: 'Ошибка удаления картинки: ' + error.message
    });
  }
});

module.exports = router;
