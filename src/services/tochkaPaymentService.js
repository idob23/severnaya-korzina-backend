// src/services/tochkaPaymentService.js
// Сервис для работы с API Точка банк - ОБНОВЛЕНО ДЛЯ ПРАВИЛЬНОЙ ФИСКАЛИЗАЦИИ ЧЕРЕЗ payments_with_receipt

const axios = require('axios');
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

class TochkaPaymentService {
  constructor() {
    this.apiUrl = process.env.TOCHKA_API_URL || 'https://enter.tochka.com/uapi';
    this.customerCode = process.env.TOCHKA_CUSTOMER_CODE || '305236529';
    this.merchantId = process.env.TOCHKA_MERCHANT_ID || '200000000026552';
    this.terminalId = process.env.TOCHKA_TERMINAL_ID || '20025552';
    this.jwtToken = process.env.TOCHKA_JWT_TOKEN;
  }

  /**
   * Универсальный метод для запросов к API Точка банк
   */
  async makeRequest(method, endpoint, data = null, params = null) {
    const config = {
      method,
      url: `${this.apiUrl}${endpoint}`,
      headers: {
        'Authorization': `Bearer ${this.jwtToken}`,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      timeout: 30000
    };
    
    if (data) config.data = data;
    if (params) config.params = params;
    
    try {
      const response = await axios(config);
      return response.data;
    } catch (error) {
      console.error(`❌ Точка API ошибка (${method} ${endpoint}):`, error.response?.data || error.message);
      throw error;
    }
  }

  /**
   * Создание платежа с правильной фискализацией через payments_with_receipt
   */
  async createPayment({ 
    amount, 
    orderId, 
    userId, 
    batchId, 
    marginPercent = 20, 
    vatCode = 6,
    customerPhone = '79999999999',
    customerEmail = null,
    items = [], // массив товаров
    platform = 'web'
  }) {
    console.log(`💳 [Точка] Создание платежа для заказа #${orderId}, сумма: ${amount}₽`);
    console.log(`📦 [Точка] Товаров в заказе: ${items.length}`);
    console.log(`💰 [Точка] Маржинальность: ${marginPercent}%`);

    const totalAmount = parseFloat(amount);
    
    // Формируем позиции чека с правильной структурой для payments_with_receipt
    const Items = [];
    let totalGoodsAmount = 0;

    // 1. Добавляем каждый товар отдельной позицией
    if (items && items.length > 0) {
      for (const item of items) {
	// ДОБАВЛЕНО: Загружаем данные товара из БД если name или unit отсутствуют
        let productName = item.name;
        let productUnit = item.unit;

	if (!productName || !productUnit) {
          try {
            const product = await prisma.product.findUnique({
              where: { id: parseInt(item.productId) }
            });
            
            if (product) {
              productName = productName || product.name;
              productUnit = productUnit || product.unit || 'шт';
            }
          } catch (error) {
            console.error(`⚠️ Не удалось загрузить товар #${item.productId}:`, error.message);
          }
        }

        // item.price теперь содержит finalPrice - нужно вычислить basePrice
        const finalPrice = parseFloat(item.price);
        const basePrice = finalPrice / (1 + marginPercent / 100);
        const itemQuantity = parseInt(item.quantity);
        const itemTotal = basePrice * itemQuantity;
        
        totalGoodsAmount += itemTotal;

	console.log(`   📦 finalPrice: ${finalPrice}₽ → basePrice: ${basePrice.toFixed(2)}₽`);
	console.log(`   Debug: itemTotal=${itemTotal}, totalGoodsAmount=${totalGoodsAmount}`);

        Items.push({
	  name: productName || `Товар #${item.productId}`,
	  amount: basePrice.toFixed(2),        // Цена за единицу согласно документации
          quantity: itemQuantity,
          vatType: this.getVatType(vatCode),
          paymentMethod: "full_payment",
          paymentObject: "goods",
	  measure: this.normalizeUnit(productUnit)
        });

        console.log(`   📦 ${productName}: ${itemQuantity} × ${itemPrice}₽ = ${itemTotal}₽`);
      }
    } else {
      // Если товары не переданы - используем одну общую позицию
      const goodsAmount = (totalAmount / (1 + marginPercent / 100)).toFixed(2);
      totalGoodsAmount = parseFloat(goodsAmount);
      
      Items.push({
        name: `Товары коллективной закупки${batchId ? ` (партия №${batchId})` : ''}`,
	amount: goodsAmount,
	quantity: 1,
        vatType: this.getVatType(vatCode),
        paymentMethod: "full_payment",
        paymentObject: "goods",
        measure: "шт."
      });
    }

    // 2. Добавляем УСЛУГУ (маржа)
    const serviceAmount = (totalAmount - totalGoodsAmount).toFixed(2);
    
    if (parseFloat(serviceAmount) > 0) {
      Items.push({
        name: "Организация коллективной закупки и доставки",
        amount: serviceAmount,
	quantity: 1,
        vatType: this.getVatType(vatCode),
        paymentMethod: "full_payment",
        paymentObject: "service",
        measure: "шт."
      });
    }

    console.log(`💰 Расчет чека:`);
    console.log(`   Товары: ${totalGoodsAmount.toFixed(2)}₽`);
    console.log(`   Услуга: ${serviceAmount}₽`);
    console.log(`   ИТОГО: ${totalAmount.toFixed(2)}₽`);

    // Получаем системные настройки для налоговой системы
    const settings = await this.getSystemSettings();
    const taxSystemCode = settings.tax_system_code || 'usn_income'; // УСН доходы по умолчанию

    // Формируем запрос для payments_with_receipt endpoint
    // ВАЖНО: Для этого endpoint структура отличается от обычного /payments

    const requestData = {
      Data: {
        customerCode: this.customerCode,
        merchantId: this.merchantId,
        amount: totalAmount.toFixed(2),
        purpose: `Оплата заказа №${orderId}`,
        paymentMode: ["card", "sbp"],
redirectUrl: `https://api.sevkorzina.ru/api/payments/redirect/success?orderId=${orderId}`,
failRedirectUrl: `https://api.sevkorzina.ru/api/payments/redirect/failed?orderId=${orderId}`,
        ttl: 60,
        saveCard: false,
        preAuthorization: false,
        taxSystemCode: 'usn_income',
        Client: {
          phone: customerPhone.startsWith('+') ? customerPhone : `+${customerPhone}`,
          email: customerEmail || 'customer@sevkorzina.ru'
        },
        Items: Items
      }
    };
    
    console.log(`📤 [Точка] Отправляем на /payments_with_receipt:`, JSON.stringify(requestData, null, 2));
    
    // ✅ ИСПОЛЬЗУЕМ НОВЫЙ ENDPOINT payments_with_receipt
    const response = await this.makeRequest('POST', '/acquiring/v1.0/payments_with_receipt', requestData);
    
    console.log(`✅ [Точка] Платеж создан: ${response.Data.operationId}`);
    console.log(`📋 [Точка] Чек будет сформирован с ${Items.length} позициями`);

    return {
      success: true,
      paymentId: response.Data.operationId,
      confirmationUrl: response.Data.paymentLink,
      status: response.Data.status,
      realOrderId: orderId,
      orderCreated: true,
      breakdown: {
        goods: totalGoodsAmount,
        service: parseFloat(serviceAmount),
        total: totalAmount,
        marginPercent: marginPercent,
        itemsCount: items.length
      }
    };
  }

  /**
   * Проверка статуса платежа
   */
  async checkPaymentStatus(paymentId) {
    console.log(`🔍 [Точка] Проверка статуса платежа: ${paymentId}`);

    try {
      const response = await this.makeRequest('GET', `/acquiring/v1.0/payments/${paymentId}`, null, {
        customerCode: this.customerCode
      });
      
      const operation = response.Data?.Operation?.[0];
      
      if (!operation) {
        console.warn('⚠️ [Точка] Платеж не найден в ответе API');
        return {
          paymentId: paymentId,
          status: 'UNKNOWN',
          isPaid: false,
          isCanceled: false,
          isPending: true,
          amount: 0,
          createdAt: new Date().toISOString(),
          paidAt: null
        };
      }
      
      const status = operation.status || 'UNKNOWN';
      console.log(`📊 [Точка] Статус: ${status}`);

      return {
        paymentId: operation.operationId || paymentId,
        status: status,
        isPaid: status === 'APPROVED',
        isCanceled: status === 'FAILED' || status === 'REJECTED',
        isPending: status === 'CREATED' || status === 'PENDING',
        amount: operation.amount ? parseFloat(operation.amount) : 0,
        createdAt: operation.createdAt || new Date().toISOString(),
        paidAt: operation.paidAt || null
      };
    } catch (error) {
      console.error(`❌ [Точка] Ошибка при проверке статуса:`, error.message);
      return {
        paymentId: paymentId,
        status: 'ERROR',
        isPaid: false,
        isCanceled: false,
        isPending: false,
        amount: 0,
        createdAt: new Date().toISOString(),
        paidAt: null,
        error: error.message
      };
    }
  }

  /**
   * Обработка вебхука от Точка банк
   */
  async handleWebhook(webhookData) {
    const { event, data } = webhookData;
    
    console.log(`🔔 [Точка] Вебхук получен: ${event}`);

    if (event === 'acquiringInternetPayment') {
      const { operationId, status } = data;

      if (status === 'APPROVED') {
        console.log(`✅ [Точка] Платеж ${operationId} успешно оплачен`);
        return { success: true, message: 'Payment approved' };
      }

      if (status === 'FAILED' || status === 'REJECTED') {
        console.log(`❌ [Точка] Платеж ${operationId} отклонен`);
        return { success: true, message: 'Payment failed' };
      }
    }
    
    return { success: true, message: 'Webhook processed' };
  }

  /**
   * Получить тип НДС для Точка банк (новый формат)
   */
  getVatType(vatCode) {
    const vatMap = {
      1: 'vat20',     // НДС 20%
      2: 'vat10',     // НДС 10%
      3: 'vat120',    // НДС 20/120
      4: 'vat110',    // НДС 10/110
      5: 'vat0',      // НДС 0%
      6: 'none'       // Без НДС (УСН)
    };
    return vatMap[vatCode] || 'none';
  }

  /**
   * Получить ставку НДС (старый формат для совместимости)
   */
  getVatRate(vatCode) {
    return this.getVatType(vatCode);
  }

  /**
   * Получение системных настроек
   */
  async getSystemSettings() {
    try {
      const settings = await prisma.systemSettings.findMany();
      const result = {};
      settings.forEach(s => {
        result[s.key] = s.value;
      });
      return result;
    } catch (error) {
      console.error('Ошибка получения настроек:', error);
      return {
        default_margin_percent: '20',
        vat_code: '6',
        tax_system_code: 'usn_income'
      };
    }
  }
  normalizeUnit(unit) {
    const unitMap = {
      'л': 'л.',
      'кг': 'кг.',
      'г': 'г.',
      'шт': 'шт.',
      'упак': 'шт.',
      'пач': 'шт.',
      'м': 'м.',
      'см': 'см.',
      'дм': 'дм.',
      'мл': 'мл.',
      'т': 'т.'
    };
    const normalized = (unit || 'шт').toLowerCase().trim();
    return unitMap[normalized] || 'шт.';
  }

} 
module.exports = TochkaPaymentService;
