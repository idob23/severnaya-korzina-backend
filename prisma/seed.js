// prisma/seed.js - ОБНОВЛЕННАЯ ВЕРСИЯ С ДАННЫМИ ДЛЯ ПАНЕЛИ

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Начинаем заполнение базы данных...');

  try {
    // 1. Создаем тестовых пользователей
    console.log('👥 Создаем пользователей...');
    
    const users = await Promise.all([
      prisma.user.upsert({
        where: { phone: '+79991234567' },
        update: {},
        create: {
          phone: '+79991234567',
          firstName: 'Иван',
          lastName: 'Петров',
          email: 'ivan@example.com',
          isActive: true
        }
      }),
      prisma.user.upsert({
        where: { phone: '+79987654321' },
        update: {},
        create: {
          phone: '+79987654321',
          firstName: 'Мария',
          lastName: 'Сидорова',
          email: 'maria@example.com',
          isActive: true
        }
      }),
      prisma.user.upsert({
        where: { phone: '+79876543210' },
        update: {},
        create: {
          phone: '+79876543210',
          firstName: 'Алексей',
          lastName: 'Иванов',
          email: 'alex@example.com',
          isActive: true
        }
      })
    ]);

    console.log(`✅ Создано ${users.length} пользователей`);

    // 2. Создаем адреса для пользователей
    console.log('🏠 Создаем адреса...');
    
    const addresses = await Promise.all([
      prisma.address.create({
        data: {
          userId: users[0].id,
          title: 'Дом',
          address: 'г. Усть-Нера, ул. Ленина, 15, кв. 12',
          isDefault: true
        }
      }),
      prisma.address.create({
        data: {
          userId: users[1].id,
          title: 'Квартира',
          address: 'г. Усть-Нера, ул. Советская, 23, кв. 45',
          isDefault: true
        }
      }),
      prisma.address.create({
        data: {
          userId: users[2].id,
          title: 'Офис',
          address: 'г. Усть-Нера, ул. Мира, 7, офис 301',
          isDefault: true
        }
      })
    ]);

    console.log(`✅ Создано ${addresses.length} адресов`);

    // 3. Создаем категории товаров
    console.log('📂 Создаем категории...');
    
    const categories = await Promise.all([
      prisma.category.upsert({
        where: { id: 1 },
        update: {},
        create: {
          name: 'Молочные продукты',
          description: 'Молоко, творог, сыр, кефир',
          isActive: true
        }
      }),
      prisma.category.upsert({
        where: { id: 2 },
        update: {},
        create: {
          name: 'Мясо и птица',
          description: 'Говядина, свинина, курица',
          isActive: true
        }
      }),
      prisma.category.upsert({
        where: { id: 3 },
        update: {},
        create: {
          name: 'Хлебобулочные изделия',
          description: 'Хлеб, батоны, булочки',
          isActive: true
        }
      })
    ]);

    console.log(`✅ Создано ${categories.length} категорий`);

    // 4. Создаем товары
    console.log('🛒 Создаем товары...');
    
    const products = await Promise.all([
      // Молочные продукты
      prisma.product.upsert({
        where: { id: 1 },
        update: {},
        create: {
          categoryId: categories[0].id,
          name: 'Молоко 3.2%',
          description: 'Натуральное цельное молоко',
          price: 85.00,
          unit: 'л',
          minQuantity: 1,
          maxQuantity: 20,
          isActive: true
        }
      }),
      prisma.product.upsert({
        where: { id: 2 },
        update: {},
        create: {
          categoryId: categories[0].id,
          name: 'Творог 9%',
          description: 'Домашний творог',
          price: 320.00,
          unit: 'кг',
          minQuantity: 1,
          maxQuantity: 10,
          isActive: true
        }
      }),
      // Мясо
      prisma.product.upsert({
        where: { id: 3 },
        update: {},
        create: {
          categoryId: categories[1].id,
          name: 'Говядина (лопатка)',
          description: 'Свежая охлажденная говядина',
          price: 650.00,
          unit: 'кг',
          minQuantity: 1,
          maxQuantity: 5,
          isActive: true
        }
      }),
      // Хлеб
      prisma.product.upsert({
        where: { id: 4 },
        update: {},
        create: {
          categoryId: categories[2].id,
          name: 'Хлеб ржаной',
          description: 'Традиционный ржаной хлеб',
          price: 95.00,
          unit: 'шт',
          minQuantity: 1,
          maxQuantity: 10,
          isActive: true
        }
      })
    ]);

    console.log(`✅ Создано ${products.length} товаров`);

    // 5. Создаем активную закупку с данными для информационной панели
    console.log('📦 Создаем активную закупку...');
    
    const batch = await prisma.batch.upsert({
      where: { id: 1 },
      update: {},
      create: {
        title: 'Молочные продукты - январь 2025',
        description: 'Коллективная закупка молочных продуктов от местных фермеров. Экономия до 20%!',
        startDate: new Date('2025-01-15'),
        endDate: new Date('2025-02-15'),
        deliveryDate: new Date('2025-02-20'),
        minParticipants: 30,
        maxParticipants: 200,
        status: 'active',
        pickupAddress: 'г. Усть-Нера, ул. Ленина, 15 (офис Северной корзины)',
        
        // НОВЫЕ ПОЛЯ ДЛЯ ИНФОРМАЦИОННОЙ ПАНЕЛИ
        targetAmount: 3000000.00,    // 3 млн рублей - цель
        currentAmount: 2250000.00,   // 2.25 млн - текущая сумма (75%)
        participantsCount: 187,      // 187 участников
        progressPercent: 75,         // 75% выполнения
        autoLaunch: true,
        marginPercent: 20.00,        // 20% наценка
        lastCalculated: new Date()
      }
    });

    console.log(`✅ Создана закупка: ${batch.title}`);

    // 6. Добавляем товары в закупку
    console.log('📝 Добавляем товары в закупку...');
    
    await Promise.all([
      prisma.batchItem.upsert({
        where: { 
          batchId_productId: {
            batchId: batch.id,
            productId: products[0].id
          }
        },
        update: {},
        create: {
          batchId: batch.id,
          productId: products[0].id, // Молоко
          price: 75.00,  // Цена со скидкой
          discount: 10.00,
          isActive: true
        }
      }),
      prisma.batchItem.upsert({
        where: { 
          batchId_productId: {
            batchId: batch.id,
            productId: products[1].id
          }
        },
        update: {},
        create: {
          batchId: batch.id,
          productId: products[1].id, // Творог
          price: 290.00, // Цена со скидкой
          discount: 30.00,
          isActive: true
        }
      })
    ]);

    console.log(`✅ Добавлены товары в закупку`);

    // 7. Создаем тестовые заказы для демонстрации
    console.log('🛍️ Создаем тестовые заказы...');
    
    const orders = await Promise.all([
      // Заказ от первого пользователя
      prisma.order.create({
        data: {
          userId: users[0].id,
          batchId: batch.id,
          addressId: addresses[0].id,
          status: 'pending',
          totalAmount: 15000.00,
          notes: 'Доставить до 18:00',
          orderItems: {
            create: [
              {
                productId: products[0].id,
                quantity: 10,
                price: 75.00
              },
              {
                productId: products[1].id,
                quantity: 5,
                price: 290.00
              }
            ]
          }
        }
      }),
      
      // Заказ от второго пользователя  
      prisma.order.create({
        data: {
          userId: users[1].id,
          batchId: batch.id,
          addressId: addresses[1].id,
          status: 'pending',
          totalAmount: 8500.00,
          orderItems: {
            create: [
              {
                productId: products[0].id,
                quantity: 5,
                price: 75.00
              },
              {
                productId: products[1].id,
                quantity: 2,
                price: 290.00
              }
            ]
          }
        }
      })
    ]);

    console.log(`✅ Создано ${orders.length} тестовых заказов`);

    // 8. Создаем дополнительную неактивную закупку для истории
    console.log('📋 Создаем завершенную закупку...');
    
    await prisma.batch.upsert({
      where: { id: 2 },
      update: {},
      create: {
        title: 'Мясные продукты - декабрь 2024',
        description: 'Завершенная закупка мясных продуктов',
        startDate: new Date('2024-12-01'),
        endDate: new Date('2024-12-31'),
        deliveryDate: new Date('2025-01-05'),
        minParticipants: 25,
        maxParticipants: 100,
        status: 'delivered',
        pickupAddress: 'г. Усть-Нера, ул. Ленина, 15',
        targetAmount: 2500000.00,
        currentAmount: 2500000.00,  // Цель достигнута
        participantsCount: 156,
        progressPercent: 100,
        autoLaunch: true,
        marginPercent: 18.00
      }
    });

    console.log('✅ Создана завершенная закупка');

    console.log('\n🎉 База данных успешно заполнена!');
    console.log('\n📊 Созданные данные:');
    console.log(`- Пользователи: ${users.length}`);
    console.log(`- Адреса: ${addresses.length}`);
    console.log(`- Категории: ${categories.length}`);
    console.log(`- Товары: ${products.length}`);
    console.log(`- Закупки: 2 (1 активная, 1 завершенная)`);
    console.log(`- Заказы: ${orders.length}`);
    
    console.log('\n🎯 Данные для информационной панели:');
    console.log(`- Активная закупка: "${batch.title}"`);
    console.log(`- Цель: ${batch.targetAmount.toLocaleString()} ₽`);
    console.log(`- Собрано: ${batch.currentAmount.toLocaleString()} ₽ (${batch.progressPercent}%)`);
    console.log(`- Участников: ${batch.participantsCount}`);

  } catch (error) {
    console.error('❌ Ошибка при заполнении базы данных:', error);
    throw error;
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });