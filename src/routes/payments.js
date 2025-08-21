// src/routes/payments.js
const express = require('express');
const router = express.Router();
const axios = require('axios');
const { authenticateToken } = require('../middleware/auth');

const YOOKASSA_SHOP_ID = '1148812';
const YOOKASSA_SECRET_KEY = 'test_jSLEuLPMPW58_iRfez3W_ToHsrMv2XS_cgqIYpNMa5A';
const YOOKASSA_API_URL = 'https://api.yookassa.ru/v3';

router.post('/create', async (req, res) => {
  try {
    const { amount, orderId, customerPhone, customerName } = req.body;

    if (!amount || !orderId) {
      return res.status(400).json({
        success: false,
        error: 'Amount or order ID not specified'
      });
    }

    const basicAuth = Buffer.from(`${YOOKASSA_SHOP_ID}:${YOOKASSA_SECRET_KEY}`).toString('base64');
    const idempotenceKey = `order_${orderId}_${Date.now()}`;

    const requestBody = {
      amount: {
        value: parseFloat(amount).toFixed(2),
        currency: 'RUB',
      },
      confirmation: {
        type: 'redirect',
        return_url: 'https://sevkorzina.ru/payment-success?status=success',
      },
      capture: true,
      description: `Payment for order ${orderId}`,
      metadata: {
        order_id: orderId,
        customer_phone: customerPhone || '',
        customer_name: customerName || '',
        app_name: 'severnaya_korzina',
        user_id: req.user?.id || 1
      },
      payment_method_data: { type: 'bank_card' },
      receipt: {
        customer: { phone: customerPhone || '1234567890' },
        items: [{
          description: 'Payment for goods',
          quantity: '1.00',
          amount: {
            value: parseFloat(amount).toFixed(2),
            currency: 'RUB',
          },
          vat_code: 1
        }],
      },
    };

    const response = await axios.post(`${YOOKASSA_API_URL}/payments`, requestBody, {
      headers: {
        'Authorization': `Basic ${basicAuth}`,
        'Content-Type': 'application/json',
        'Idempotence-Key': idempotenceKey,
      },
      timeout: 30000
    });

    if (response.status === 200 || response.status === 201) {
      const paymentData = response.data;
      
      res.json({
        success: true,
        paymentId: paymentData.id,
        status: paymentData.status,
        confirmationUrl: paymentData.confirmation.confirmation_url,
        message: 'Payment created successfully'
      });
    } else {
      throw new Error(`YooKassa API returned status ${response.status}`);
    }

  } catch (error) {
    console.error('Payment creation error:', error.message);

    if (error.response?.data) {
      res.status(400).json({
        success: false,
        error: error.response.data.description || 'Payment system error'
      });
    } else {
      res.status(500).json({
        success: false,
        error: 'Connection error to payment system'
      });
    }
  }
});

router.get('/status/:paymentId', async (req, res) => {
  try {
    const { paymentId } = req.params;
    const basicAuth = Buffer.from(`${YOOKASSA_SHOP_ID}:${YOOKASSA_SECRET_KEY}`).toString('base64');

    const response = await axios.get(`${YOOKASSA_API_URL}/payments/${paymentId}`, {
      headers: {
        'Authorization': `Basic ${basicAuth}`,
        'Content-Type': 'application/json',
      },
      timeout: 10000
    });

    if (response.status === 200) {
      const paymentData = response.data;
      
      res.json({
        success: true,
        paymentId: paymentData.id,
        status: paymentData.status,
        isPaid: paymentData.status === 'succeeded',
        isCanceled: paymentData.status === 'canceled',
        isPending: paymentData.status === 'pending',
        amount: parseFloat(paymentData.amount.value),
        createdAt: paymentData.created_at,
        paidAt: paymentData.paid_at || null
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Error checking payment status'
    });
  }
});

module.exports = router;
