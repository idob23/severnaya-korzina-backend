// prisma/seed.js - ИСПРАВЛЕННАЯ ВЕРСИЯ
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Начинаем заполнение базы данных...');

  // Очищаем существующие данные в правильном порядке
  console.log('🧹 Очищаем старые данные...');
  await prisma.batchItem.deleteMany();
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.address.deleteMany();
  await prisma.batch.deleteMany();
  await prisma.product.deleteMany();
  await prisma.category.deleteMany();
  await prisma.user.deleteMany();

  // 1. Создаем категории товаров
  console.log('📦 Создаем категории товаров...');
  
  const categories = await Promise.all([
    prisma.category.create({
      data: {
        name: 'Молочные продукты',
        description: 'Молоко, творог, сыры, йогурты',
        imageUrl: 'https://example.com/dairy.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Мясо и птица',
        description: 'Свежее мясо, птица, полуфабрикаты',
        imageUrl: 'https://example.com/meat.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Хлебобулочные изделия',
        description: 'Хлеб, выпечка, торты',
        imageUrl: 'https://example.com/bakery.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Овощи и фрукты',
        description: 'Свежие овощи, фрукты, зелень',
        imageUrl: 'https://example.com/vegetables.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Крупы и макароны',
        description: 'Крупы, макаронные изделия, бобовые',
        imageUrl: 'https://example.com/grains.jpg'
      }
    })
  ]);

  console.log(`✅ Создано ${categories.length} категорий`);

  // 2. Создаем товары
  console.log('🛍️ Создаем товары...');
  
  const products = await Promise.all([
    // Молочные продукты
    prisma.product.create({
      data: {
        categoryId: categories[0].id,
        name: 'Молоко 3.2%',
        description: 'Свежее коровье молоко от местных фермеров',
        price: 85.50,
        unit: 'л',
        minQuantity: 1,
        maxQuantity: 20
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[0].id,
        name: 'Творог домашний',
        description: 'Натуральный творог 18% жирности',
        price: 320.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 5
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[0].id,
        name: 'Сыр российский',
        description: 'Классический российский сыр',
        price: 450.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 3
      }
    }),

    // Мясо и птица
    prisma.product.create({
      data: {
        categoryId: categories[1].id,
        name: 'Говядина (вырезка)',
        description: 'Премиальная говяжья вырезка',
        price: 850.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 10
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[1].id,
        name: 'Курица домашняя',
        description: 'Домашняя курица, выращенная без антибиотиков',
        price: 320.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 5
      }
    }),

    // Овощи и фрукты
    prisma.product.create({
      data: {
        categoryId: categories[3].id,
        name: 'Картофель',
        description: 'Картофель местного производства',
        price: 35.00,
        unit: 'кг',
        minQuantity: 2,
        maxQuantity: 50
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[3].id,
        name: 'Яблоки',
        description: 'Сочные яблоки сорта Антоновка',
        price: 120.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 10
      }
    })
  ]);

  console.log(`✅ Создано ${products.length} товаров`);

  // 3. Создаем тестовых пользователей
  console.log('👥 Создаем тестовых пользователей...');
  
  const users = await Promise.all([
    prisma.user.create({
      data: {
        phone: '+79991234567',
        firstName: 'Админ',
        lastName: 'Администратор',
        email: 'admin@severnaya-korzina.ru'
      }
    }),
    prisma.user.create({
      data: {
        phone: '+79997654321',
        firstName: 'Иван',
        lastName: 'Петров',
        email: 'ivan.petrov@email.com'
      }
    }),
    prisma.user.create({
      data: {
        phone: '+79995551234',
        firstName: 'Мария',
        lastName: 'Сидорова',
        email: 'maria.sidorova@email.com'
      }
    })
  ]);

  console.log(`✅ Создано ${users.length} пользователей`);

  // 4. Создаем адреса для пользователей
  console.log('🏠 Создаем адреса...');
  
  const addresses = await Promise.all([
    // Для админа
    prisma.address.create({
      data: {
        userId: users[0].id,
        title: 'Офис',
        address: 'г. Усть-Нера, ул. Ленина, 15, офис 201',
        isDefault: true
      }
    }),
    
    // Для Ивана Петрова
    prisma.address.create({
      data: {
        userId: users[1].id,
        title: 'Дом',
        address: 'г. Усть-Нера, ул. Советская, 23, кв. 45',
        isDefault: true
      }
    }),
    
    // Для Марии Сидоровой
    prisma.address.create({
      data: {
        userId: users[2].id,
        title: 'Квартира',
        address: 'г. Усть-Нера, ул. Мира, 7, кв. 12',
        isDefault: true
      }
    })
  ]);

  console.log(`✅ Создано ${addresses.length} адресов`);

  // 5. Создаем тестовую закупку
  console.log('📋 Создаем закупку...');
  
  const batch = await prisma.batch.create({
    data: {
      title: 'Молочные продукты - февраль 2025',
      description: 'Коллективная закупка молочных продуктов от местных фермеров. Скидки до 15%!',
      startDate: new Date('2025-02-01'),
      endDate: new Date('2025-02-28'),
      deliveryDate: new Date('2025-03-05'),
      minParticipants: 5,
      maxParticipants: 50,
      pickupAddress: 'г. Усть-Нера, ул. Ленина, 15 (офис Северной корзины)',
      status: 'active'
    }
  });

  // Добавляем товары в закупку
  await Promise.all([
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[0].id, // Молоко
        price: 75.00,
        discount: 12.50
      }
    }),
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[1].id, // Творог
        price: 290.00,
        discount: 9.38
      }
    }),
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[2].id, // Сыр
        price: 420.00,
        discount: 6.67
      }
    })
  ]);

  // 6. Создаем тестовые заказы
  console.log('🛒 Создаем тестовые заказы...');
  
  const orders = await Promise.all([
    // Заказ от Ивана Петрова
    prisma.order.create({
      data: {
        userId: users[1].id, // Иван
        addressId: addresses[1].id,
        batchId: batch.id,
        totalAmount: 735.50,
        status: 'pending',
        notes: 'Доставить после 18:00',
        createdAt: new Date('2025-01-20T10:30:00')
      }
    }),
    
    // Заказ от Марии Сидоровой
    prisma.order.create({
      data: {
        userId: users[2].id, // Мария
        addressId: addresses[2].id,
        batchId: batch.id,
        totalAmount: 1240.00,
        status: 'confirmed',
        notes: null,
        createdAt: new Date('2025-01-22T14:15:00')
      }
    }),
    
    // Еще один заказ от Ивана (оплаченный)
    prisma.order.create({
      data: {
        userId: users[1].id, // Иван
        addressId: addresses[1].id,
        totalAmount: 450.00,
        status: 'paid',
        notes: 'Только молочные продукты',
        createdAt: new Date('2025-01-25T09:45:00')
      }
    }),
    
    // Доставленный заказ от Марии
    prisma.order.create({
      data: {
        userId: users[2].id, // Мария
        addressId: addresses[2].id,
        totalAmount: 860.00,
        status: 'delivered',
        notes: null,
        createdAt: new Date('2025-01-18T16:20:00')
      }
    }),
    
    // Отмененный заказ
    prisma.order.create({
      data: {
        userId: users[1].id, // Иван
        addressId: addresses[1].id,
        totalAmount: 320.00,
        status: 'cancelled',
        notes: 'Отменил по личным причинам',
        createdAt: new Date('2025-01-26T11:00:00')
      }
    })
  ]);

  // Добавляем товары в заказы
  console.log('📦 Добавляем товары в заказы...');
  
  await Promise.all([
    // Товары для первого заказа Ивана (pending)
    prisma.orderItem.create({
      data: {
        orderId: orders[0].id,
        productId: products[0].id, // Молоко
        quantity: 3,
        price: 85.50
      }
    }),
    prisma.orderItem.create({
      data: {
        orderId: orders[0].id,
        productId: products[1].id, // Творог
        quantity: 1,
        price: 320.00
      }
    }),
    prisma.orderItem.create({
      data: {
        orderId: orders[0].id,
        productId: products[2].id, // Сыр
        quantity: 0.5,
        price: 450.00
      }
    }),

    // Товары для заказа Марии (confirmed)
    prisma.orderItem.create({
      data: {
        orderId: orders[1].id,
        productId: products[3].id, // Говядина
        quantity: 1,
        price: 850.00
      }
    }),
    prisma.orderItem.create({
      data: {
        orderId: orders[1].id,
        productId: products[4].id, // Курица
        quantity: 1,
        price: 320.00
      }
    }),
    prisma.orderItem.create({
      data: {
        orderId: orders[1].id,
        productId: products[5].id, // Картофель
        quantity: 2,
        price: 35.00
      }
    }),

    // Товары для оплаченного заказа Ивана
    prisma.orderItem.create({
      data: {
        orderId: orders[2].id,
        productId: products[2].id, // Сыр
        quantity: 1,
        price: 450.00
      }
    }),

    // Товары для доставленного заказа Марии
    prisma.orderItem.create({
      data: {
        orderId: orders[3].id,
        productId: products[0].id, // Молоко
        quantity: 2,
        price: 85.50
      }
    }),
    prisma.orderItem.create({
      data: {
        orderId: orders[3].id,
        productId: products[6].id, // Яблоки
        quantity: 5,
        price: 120.00
      }
    }),

    // Товары для отмененного заказа
    prisma.orderItem.create({
      data: {
        orderId: orders[4].id,
        productId: products[4].id, // Курица
        quantity: 1,
        price: 320.00
      }
    })
  ]);

  console.log(`✅ Создано ${orders.length} заказов с товарами`);

  console.log(`✅ Создана закупка с товарами`);

  /// 7. Выводим итоговую статистику
  console.log('\n📊 Итоговая статистика:');
  
  const stats = await Promise.all([
    prisma.category.count(),
    prisma.product.count(),
    prisma.user.count(),
    prisma.address.count(),
    prisma.batch.count(),
    prisma.order.count(),
    prisma.orderItem.count()
  ]);

  console.log(`📦 Категорий: ${stats[0]}`);
  console.log(`🛍️ Товаров: ${stats[1]}`);
  console.log(`👥 Пользователей: ${stats[2]}`);
  console.log(`🏠 Адресов: ${stats[3]}`);
  console.log(`📋 Закупок: ${stats[4]}`);
  console.log(`🛒 Заказов: ${stats[5]}`);
  console.log(`📦 Позиций в заказах: ${stats[6]}`);

  console.log('\n🎉 База данных успешно заполнена тестовыми данными!');
  console.log('\n📱 Тестовые учетные записи:');
  console.log('👑 Админ: +79991234567 (логин: admin, пароль: admin)');
  console.log('👤 Иван: +79997654321 (SMS код: 1234)');
  console.log('👤 Мария: +79995551234 (SMS код: 1234)');
  console.log('\n🛒 Тестовые заказы:');
  console.log('📋 5 заказов с разными статусами');
  console.log('📦 10+ товаров в заказах');
  console.log('🎯 Готово для тестирования админ-панели!');
}

main()
  .catch((e) => {
    console.error('❌ Ошибка при заполнении базы данных:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });