// src/services/tochkaPaymentService.js
// Сервис для работы с API Точка банк

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
   * Создание платежа
   */
  async createPayment({ 
    amount, 
    orderId, 
    userId, 
    batchId, 
    marginPercent = 20, 
    vatCode = 6,
    customerPhone = '79999999999'
  }) {
    console.log(`💳 [Точка] Создание платежа для заказа #${orderId}, сумма: ${amount}₽`);

    // Расчет сумм для фискализации (аналогично ЮKassa)
    const totalAmount = parseFloat(amount);
    const goodsAmount = (totalAmount / (1 + marginPercent / 100)).toFixed(2);
    const serviceAmount = (totalAmount - parseFloat(goodsAmount)).toFixed(2);

    console.log(`💰 Расчет: Итого=${totalAmount}, Товары=${goodsAmount}, Услуга=${serviceAmount}`);

    const requestData = {
      Data: {
        customerCode: this.customerCode,
        merchantId: this.merchantId,
        amount: totalAmount.toFixed(2),
        purpose: `Оплата заказа №${orderId}`,
        paymentMode: ["card", "sbp"], // Карты и СБП
	callbackUrl: "https://app.sevkorzina.ru/api/payments/webhook",
        ttl: 60, // 60 минут на оплату
        saveCard: false,
        preAuthorization: false,
        // Фискализация через digitalKassaTochka
        receipt: {
          customer: {
            phone: customerPhone
          },
          items: [
            {
              description: `Товары коллективной закупки${batchId ? ` (партия №${batchId})` : ''}`,
              quantity: 1,
              price: parseFloat(goodsAmount),
              tax: this.getVatRate(vatCode),
              paymentObject: "commodity" // товар
            },
            {
              description: "Услуга организации коллективной закупки",
              quantity: 1,
              price: parseFloat(serviceAmount),
              tax: this.getVatRate(vatCode),
              paymentObject: "service" // услуга
            }
          ]
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
        goods: parseFloat(goodsAmount),
        service: parseFloat(serviceAmount),
        total: totalAmount,
        marginPercent: marginPercent
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
      
      // API возвращает Data.Operation с массивом данных платежа
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
        
        // Обновляем статус заказа в БД
        // Логика обновления будет добавлена в следующем шаге
        
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
      1: 'none',      // без НДС
      2: 'vat0',      // НДС 0%
      3: 'vat10',     // НДС 10%
      4: 'vat20',     // НДС 20%
      5: 'vat110',    // НДС 10/110
      6: 'vat120'     // НДС 20/120
    };
    return vatMap[vatCode] || 'vat120';
  }
}

module.exports = TochkaPaymentService;
