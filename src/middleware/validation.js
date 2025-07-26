// src/middleware/validation.js
const Joi = require('joi');

// Middleware для валидации данных
const validate = (schema, property = 'body') => {
  return (req, res, next) => {
    const { error } = schema.validate(req[property], {
      allowUnknown: false,
      stripUnknown: true
    });

    if (error) {
      const errorDetails = error.details.map(detail => ({
        field: detail.path.join('.'),
        message: detail.message
      }));

      return res.status(400).json({
        error: 'Ошибка валидации данных',
        details: errorDetails
      });
    }

    next();
  };
};

// Схемы валидации

// Регистрация пользователя
const registerSchema = Joi.object({
  phone: Joi.string()
    .pattern(/^\+7\d{10}$/)
    .required()
    .messages({
      'string.pattern.base': 'Телефон должен быть в формате +7XXXXXXXXXX'
    }),
  firstName: Joi.string()
    .min(2)
    .max(50)
    .required(),
  lastName: Joi.string()
    .min(2)
    .max(50)
    .optional()
    .allow(''),
  email: Joi.string()
    .email()
    .optional()
    .allow('')
});

// Вход пользователя
const loginSchema = Joi.object({
  phone: Joi.string()
    .pattern(/^\+7\d{10}$/)
    .required(),
  smsCode: Joi.string()
    .length(4)
    .pattern(/^\d{4}$/)
    .optional()
});

// Создание заказа
const createOrderSchema = Joi.object({
  addressId: Joi.number()
    .integer()
    .positive()
    .required(),
  batchId: Joi.number()
    .integer()
    .positive()
    .optional(),
  items: Joi.array()
    .items(
      Joi.object({
        productId: Joi.number().integer().positive().required(),
        quantity: Joi.number().integer().positive().required(),
        price: Joi.number().positive().precision(2).required()
      })
    )
    .min(1)
    .required(),
  notes: Joi.string()
    .max(500)
    .optional()
    .allow('')
});

// Добавление адреса
const addAddressSchema = Joi.object({
  title: Joi.string()
    .min(2)
    .max(100)
    .required(),
  address: Joi.string()
    .min(10)
    .max(300)
    .required(),
  isDefault: Joi.boolean()
    .default(false)
});

// Параметры пагинации
const paginationSchema = Joi.object({
  page: Joi.number()
    .integer()
    .min(1)
    .default(1),
  limit: Joi.number()
    .integer()
    .min(1)
    .max(100)
    .default(20),
  search: Joi.string()
    .max(100)
    .optional()
    .allow(''),
  categoryId: Joi.number()
    .integer()
    .positive()
    .optional(),
  status: Joi.string()
    .valid('pending', 'confirmed', 'paid', 'shipped', 'delivered', 'cancelled', 'all')
    .optional(),
  userId: Joi.number()
    .integer()
    .positive()
    .optional()
});

module.exports = {
  validate,
  schemas: {
    register: registerSchema,
    login: loginSchema,
    createOrder: createOrderSchema,
    addAddress: addAddressSchema,
    pagination: paginationSchema
  }
};