// src/services/tochkaPaymentService.js
// Сервис для работы с API Точка банк - ИСПРАВЛЕНО ДЛЯ ПРАВИЛЬНОЙ ФИСКАЛИЗАЦИИ

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
   * Создание платежа с правильной фискализацией
   */
  async createPayment({ 
    amount, 
    orderId, 
    userId, 
    batchId, 
    marginPercent = 20, 
    vatCode = 6,
    customerPhone = '79999999999',
    items = [] // ✅ НОВОЕ: массив товаров
  }) {
    console.log(`💳 [Точка] Создание платежа для заказа #${orderId}, сумма: ${amount}₽`);
    console.log(`📦 [Точка] Товаров в заказе: ${items.length}`);
    console.log(`💰 [Точка] Маржинальность: ${marginPercent}%`);

    const totalAmount = parseFloat(amount);
    
    // ✅ НОВАЯ ЛОГИКА: Формируем позиции чека
    const receiptItems = [];
    let totalGoodsAmount = 0;

    // 1. Добавляем каждый товар отдельной позицией
    if (items && items.length > 0) {
      for (const item of items) {
        // Цена товара БЕЗ маржи (базовая цена из каталога)
        const itemPrice = parseFloat(item.price);
        const itemQuantity = parseInt(item.quantity);
        const itemTotal = itemPrice * itemQuantity;
        
        totalGoodsAmount += itemTotal;

        receiptItems.push({
          description: item.name || `Товар #${item.productId}`,
          quantity: itemQuantity,
          price: itemPrice.toFixed(2),
          tax: this.getVatRate(vatCode),
          paymentObject: "commodity" // ✅ ТОВАР
        });

        console.log(`   📦 ${item.name}: ${itemQuantity} × ${itemPrice}₽ = ${itemTotal}₽`);
      }
    } else {
      // Если товары не переданы - используем старую логику (одна позиция)
      const goodsAmount = (totalAmount / (1 + marginPercent / 100)).toFixed(2);
      totalGoodsAmount = parseFloat(goodsAmount);
      
      receiptItems.push({
        description: `Товары коллективной закупки${batchId ? ` (партия №${batchId})` : ''}`,
        quantity: 1,
        price: goodsAmount,
        tax: this.getVatRate(vatCode),
        paymentObject: "commodity"
      });
    }

    // 2. Добавляем УСЛУГУ (маржа)
    const serviceAmount = (totalAmount - totalGoodsAmount).toFixed(2);
    
    receiptItems.push({
      description: "Организация коллективной закупки и доставки",
      quantity: 1,
      price: serviceAmount,
      tax: this.getVatRate(vatCode),
      paymentObject: "service" // ✅ УСЛУГА
    });

    console.log(`💰 Расчет:`);
    console.log(`   Товары (базовая цена): ${totalGoodsAmount.toFixed(2)}₽`);
    console.log(`   Услуга (маржа ${marginPercent}%): ${serviceAmount}₽`);
    console.log(`   ИТОГО: ${totalAmount.toFixed(2)}₽`);

    const requestData = {
      Data: {
        customerCode: this.customerCode,
        merchantId: this.merchantId,
        amount: totalAmount.toFixed(2),
        purpose: `Оплата заказа №${orderId}`,
        paymentMode: ["card", "sbp"],
        callbackUrl: "https://app.sevkorzina.ru/api/payments/webhook",
        ttl: 60,
        saveCard: false,
        preAuthorization: false,
        receipt: {
          customer: {
            phone: customerPhone
          },
          items: receiptItems // ✅ Массив с отдельными товарами + услуга
        }
      }
    };

    const response = await this.makeRequest('POST', '/acquiring/v1.0/payments', requestData);
    
    console.log(`✅ [Точка] Платеж создан: ${response.Data.operationId}`);

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
   * Получить ставку НДС для Точка банк
   */
  getVatRate(vatCode) {
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
}

module.exports = TochkaPaymentService;
