// create-test-user.js - Создание тестового пользователя
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function createTestUser() {
  try {
    console.log('👤 Создание тестового пользователя...\n');

    // Проверяем существующих пользователей
    const existingUsers = await prisma.user.findMany({
      select: { id: true, phone: true, firstName: true, lastName: true }
    });

    console.log('📋 Существующие пользователи:');
    if (existingUsers.length === 0) {
      console.log('   (пусто)');
    } else {
      existingUsers.forEach(user => {
        console.log(`   ID: ${user.id}, Phone: ${user.phone}, Name: ${user.firstName} ${user.lastName}`);
      });
    }
    console.log('');

    // Проверяем, есть ли пользователь с ID 1
    const user1 = await prisma.user.findUnique({ where: { id: 1 } });

    if (user1) {
      console.log('✅ Пользователь с ID 1 уже существует!');
      console.log(`   Phone: ${user1.phone}`);
      console.log(`   Name: ${user1.firstName} ${user1.lastName}`);
      return;
    }

    // Создаем тестового пользователя
    const newUser = await prisma.user.create({
      data: {
        phone: '+79142667582',
        firstName: 'Тестовый',
        lastName: 'Пользователь',
        isActive: true,
        acceptedTerms: true,
        acceptedTermsAt: new Date()
      }
    });

    console.log('✅ Тестовый пользователь создан!');
    console.log(`   ID: ${newUser.id}`);
    console.log(`   Phone: ${newUser.phone}`);
    console.log(`   Name: ${newUser.firstName} ${newUser.lastName}`);
    console.log('');

    // Создаем дефолтный адрес
    const address = await prisma.address.create({
      data: {
        userId: newUser.id,
        city: 'Усть-Нера',
        street: 'Тестовая',
        house: '1',
        apartment: '1',
        isDefault: true
      }
    });

    console.log('✅ Адрес создан!');
    console.log(`   ID: ${address.id}`);
    console.log('');

  } catch (error) {
    console.error('❌ Ошибка:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

createTestUser();
