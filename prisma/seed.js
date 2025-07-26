const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Начинаем заполнение базы тестовыми данными...');

  // Очищаем существующие данные
  await prisma.orderItem.deleteMany({});
  await prisma.order.deleteMany({});
  await prisma.batchItem.deleteMany({});
  await prisma.batch.deleteMany({});
  await prisma.product.deleteMany({});
  await prisma.category.deleteMany({});
  await prisma.address.deleteMany({});
  await prisma.user.deleteMany({});

  // Создаем категории
  const categories = await Promise.all([
    prisma.category.create({
      data: {
        name: 'Молочные продукты',
        description: 'Молоко, сыр, кефир, творог',
        imageUrl: 'https://example.com/dairy.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Мясо и птица',
        description: 'Свежее мясо, курица, колбасы',
        imageUrl: 'https://example.com/meat.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Овощи и фрукты',
        description: 'Свежие овощи и фрукты',
        imageUrl: 'https://example.com/vegetables.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Хлеб и выпечка',
        description: 'Хлеб, булочки, торты',
        imageUrl: 'https://example.com/bread.jpg'
      }
    }),
    prisma.category.create({
      data: {
        name: 'Бакалея',
        description: 'Крупы, макароны, консервы',
        imageUrl: 'https://example.com/groceries.jpg'
      }
    })
  ]);

  console.log(`✅ Создано ${categories.length} категорий`);

  // Создаем товары
  const products = await Promise.all([
    // Молочные продукты
    prisma.product.create({
      data: {
        categoryId: categories[0].id,
        name: 'Молоко 3.2%',
        description: 'Пастеризованное молоко высшего качества',
        price: 65.00,
        unit: 'л',
        minQuantity: 1,
        maxQuantity: 10,
        imageUrl: 'https://example.com/milk.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[0].id,
        name: 'Творог 9%',
        description: 'Домашний творог из натурального молока',
        price: 150.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 5,
        imageUrl: 'https://example.com/cottage-cheese.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[0].id,
        name: 'Сыр "Российский"',
        description: 'Твердый сыр премиум качества',
        price: 450.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 3,
        imageUrl: 'https://example.com/cheese.jpg'
      }
    }),

    // Мясо и птица
    prisma.product.create({
      data: {
        categoryId: categories[1].id,
        name: 'Говядина (вырезка)',
        description: 'Мраморная говядина высшего сорта',
        price: 800.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 5,
        imageUrl: 'https://example.com/beef.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[1].id,
        name: 'Курица домашняя',
        description: 'Свежая курица от местных фермеров',
        price: 300.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 10,
        imageUrl: 'https://example.com/chicken.jpg'
      }
    }),

    // Овощи и фрукты
    prisma.product.create({
      data: {
        categoryId: categories[2].id,
        name: 'Картофель',
        description: 'Молодой картофель из Якутии',
        price: 80.00,
        unit: 'кг',
        minQuantity: 5,
        maxQuantity: 50,
        imageUrl: 'https://example.com/potato.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[2].id,
        name: 'Морковь',
        description: 'Сладкая морковь нового урожая',
        price: 60.00,
        unit: 'кг',
        minQuantity: 2,
        maxQuantity: 20,
        imageUrl: 'https://example.com/carrot.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[2].id,
        name: 'Яблоки',
        description: 'Красные яблоки сорта "Гала"',
        price: 120.00,
        unit: 'кг',
        minQuantity: 2,
        maxQuantity: 20,
        imageUrl: 'https://example.com/apples.jpg'
      }
    }),

    // Хлеб и выпечка
    prisma.product.create({
      data: {
        categoryId: categories[3].id,
        name: 'Хлеб черный',
        description: 'Ржаной хлеб на закваске',
        price: 45.00,
        unit: 'шт',
        minQuantity: 1,
        maxQuantity: 10,
        imageUrl: 'https://example.com/bread.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[3].id,
        name: 'Булочки с маком',
        description: 'Свежие булочки с маковой начинкой',
        price: 25.00,
        unit: 'шт',
        minQuantity: 4,
        maxQuantity: 20,
        imageUrl: 'https://example.com/rolls.jpg'
      }
    }),

    // Бакалея
    prisma.product.create({
      data: {
        categoryId: categories[4].id,
        name: 'Рис длиннозерный',
        description: 'Премиум рис для плова и гарниров',
        price: 90.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 10,
        imageUrl: 'https://example.com/rice.jpg'
      }
    }),
    prisma.product.create({
      data: {
        categoryId: categories[4].id,
        name: 'Гречка ядрица',
        description: 'Отборная гречневая крупа',
        price: 85.00,
        unit: 'кг',
        minQuantity: 1,
        maxQuantity: 10,
        imageUrl: 'https://example.com/buckwheat.jpg'
      }
    })
  ]);

  console.log(`✅ Создано ${products.length} товаров`);

  // Создаем тестовых пользователей
  const users = await Promise.all([
    prisma.user.create({
      data: {
        phone: '+79142667582',
        firstName: 'Иван',
        lastName: 'Петров',
        email: 'ivan@example.com'
      }
    }),
    prisma.user.create({
      data: {
        phone: '+79001234567',
        firstName: 'Мария',
        lastName: 'Сидорова',
        email: 'maria@example.com'
      }
    }),
    prisma.user.create({
      data: {
        phone: '+79009876543',
        firstName: 'Алексей',
        lastName: 'Иванов'
      }
    })
  ]);

  console.log(`✅ Создано ${users.length} пользователей`);

  // Создаем адреса для пользователей
  const addresses = await Promise.all([
    prisma.address.create({
      data: {
        userId: users[0].id,
        title: 'Дом',
        address: 'ул. Ленина, 15, кв. 10',
        isDefault: true
      }
    }),
    prisma.address.create({
      data: {
        userId: users[0].id,
        title: 'Работа',
        address: 'ул. Советская, 22, офис 5'
      }
    }),
    prisma.address.create({
      data: {
        userId: users[1].id,
        title: 'Дом',
        address: 'ул. Мира, 8, кв. 25',
        isDefault: true
      }
    }),
    prisma.address.create({
      data: {
        userId: users[2].id,
        title: 'Дом',
        address: 'ул. Кирова, 33, кв. 7',
        isDefault: true
      }
    })
  ]);

  console.log(`✅ Создано ${addresses.length} адресов`);

  // Создаем активную закупку
  const batch = await prisma.batch.create({
    data: {
      title: 'Зимняя закупка продуктов',
      description: 'Большая закупка продуктов на зимний период со скидками до 30%',
      startDate: new Date('2024-12-01'),
      endDate: new Date('2024-12-25'),
      deliveryDate: new Date('2024-12-30'),
      minParticipants: 10,
      maxParticipants: 100,
      pickupAddress: 'ул. Ленина, 15 (магазин "Северная корзина")',
      status: 'active'
    }
  });

  // Добавляем товары в закупку со скидками
  const batchItems = await Promise.all([
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[0].id, // Молоко
        price: 55.00, // Скидка с 65
        discount: 15.38
      }
    }),
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[3].id, // Говядина
        price: 650.00, // Скидка с 800
        discount: 18.75
      }
    }),
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[5].id, // Картофель
        price: 60.00, // Скидка с 80
        discount: 25.00
      }
    }),
    prisma.batchItem.create({
      data: {
        batchId: batch.id,
        productId: products[10].id, // Рис
        price: 75.00, // Скидка с 90
        discount: 16.67
      }
    })
  ]);

  console.log(`✅ Создана закупка с ${batchItems.length} товарами`);

  // Создаем тестовые заказы
  const orders = await Promise.all([
    prisma.order.create({
      data: {
        userId: users[0].id,
        batchId: batch.id,
        addressId: addresses[0].id,
        status: 'pending',
        totalAmount: 340.00,
        notes: 'Доставить до 18:00',
        orderItems: {
          create: [
            {
              productId: products[0].id,
              quantity: 2,
              price: 55.00
            },
            {
              productId: products[5].id,
              quantity: 5,
              price: 60.00
            }
          ]
        }
      }
    }),
    prisma.order.create({
      data: {
        userId: users[1].id,
        batchId: batch.id,
        addressId: addresses[2].id,
        status: 'confirmed',
        totalAmount: 725.00,
        orderItems: {
          create: [
            {
              productId: products[3].id,
              quantity: 1,
              price: 650.00
            },
            {
              productId: products[10].id,
              quantity: 1,
              price: 75.00
            }
          ]
        }
      }
    })
  ]);

  console.log(`✅ Создано ${orders.length} заказов`);

  console.log('🎉 База данных успешно заполнена тестовыми данными!');
  console.log('📊 Статистика:');
  console.log(`   - Категорий: ${categories.length}`);
  console.log(`   - Товаров: ${products.length}`);
  console.log(`   - Пользователей: ${users.length}`);
  console.log(`   - Адресов: ${addresses.length}`);
  console.log(`   - Закупок: 1`);
  console.log(`   - Заказов: ${orders.length}`);
}

main()
  .catch((e) => {
    console.error('❌ Ошибка при заполнении базы:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });