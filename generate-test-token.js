// generate-test-token.js - Генерация тестового JWT токена
// Запуск: node generate-test-token.js

require('dotenv').config();
const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  console.error('❌ JWT_SECRET не найден в .env файле!');
  process.exit(1);
}

console.log('🔑 Генерация тестового JWT токена...\n');

// Создаем токен для тестового пользователя
const testUserToken = jwt.sign(
  { 
    userId: 85,
    phone: '+79142667582',
    role: 'user'
  },
  JWT_SECRET,
  { expiresIn: '24h' }
);

// Создаем токен для админа
const adminToken = jwt.sign(
  {
    login: 'admin',
    role: 'admin'
  },
  JWT_SECRET,
  { expiresIn: '24h' }
);

console.log('━'.repeat(70));
console.log('✅ Токены сгенерированы успешно!\n');

console.log('👤 ТЕСТОВЫЙ ПОЛЬЗОВАТЕЛЬ (userId: 1):');
console.log('━'.repeat(70));
console.log(testUserToken);
console.log('');

console.log('👑 АДМИН:');
console.log('━'.repeat(70));
console.log(adminToken);
console.log('');

console.log('━'.repeat(70));
console.log('📝 Пример использования для теста платежа:\n');

console.log('curl -X POST http://localhost:3000/api/payments/create \\');
console.log('  -H "Content-Type: application/json" \\');
console.log(`  -H "Authorization: Bearer ${testUserToken}" \\`);
console.log('  -d \'{\n' +
           '    "amount": 150,\n' +
           '    "orderId": "TEST_' + Date.now() + '",\n' +
           '    "customerPhone": "79142667582",\n' +
           '    "customerName": "Тестовый Пользователь"\n' +
           '  }\'');

console.log('');
console.log('💡 Токены действительны 24 часа');
console.log('');
