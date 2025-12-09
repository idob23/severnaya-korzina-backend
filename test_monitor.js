const { spawn } = require('child_process');
const axios = require('axios');

const TELEGRAM_BOT_TOKEN = '8556977514:AAFlNaUu7QfDXeZDl3QWsPvZdvJhM7zzr0U';
const TELEGRAM_CHAT_ID = '2118917273';
const SERVICE_NAME = 'severnaya-korzina';

const ERROR_PATTERNS = [
  /❌/,
  /Error:/,
  /Exception:/,
  /ECONNREFUSED/,
  /status code 5\d{2}/,
  /ReferenceError/,
  /TypeError/,
];

const IGNORE_PATTERNS = [
  /GET \/api\//,
  /POST \/api\//,
  /200 \d+/,
];

async function sendTelegram(message) {
  try {
    const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
    await axios.post(url, {
      chat_id: TELEGRAM_CHAT_ID,
      text: message,
      parse_mode: 'HTML'
    });
    console.log('✅ Уведомление отправлено в Telegram');
  } catch (error) {
    console.error('❌ Ошибка отправки в Telegram:', error.message);
  }
}

function isError(line) {
  if (IGNORE_PATTERNS.some(pattern => pattern.test(line))) {
    return false;
  }
  return ERROR_PATTERNS.some(pattern => pattern.test(line));
}

console.log('🔍 ТЕСТОВЫЙ запуск мониторинга логов...');
console.log(`📊 Сервис: ${SERVICE_NAME}`);
console.log(`📱 Telegram Chat ID: ${TELEGRAM_CHAT_ID}\n`);

sendTelegram(`✅ <b>ТЕСТ монитора запущен</b>\n\nВремя: ${new Date().toLocaleString('ru-RU')}`);

const journalctl = spawn('journalctl', ['-u', SERVICE_NAME, '-f', '--no-pager', '-n', '10']);

journalctl.stdout.on('data', (data) => {
  const lines = data.toString().split('\n');
  lines.forEach(line => {
    if (line.trim() && isError(line)) {
      console.log(`\n🚨 ОШИБКА:\n${line}\n`);
      sendTelegram(`🚨 <b>ТЕСТОВАЯ ОШИБКА</b>\n\n<code>${line.substring(0, 200)}</code>`);
    }
  });
});

journalctl.on('close', (code) => {
  console.log(`⚠️ Завершился с кодом ${code}`);
});

process.on('SIGINT', () => {
  console.log('\n👋 Остановка теста...');
  journalctl.kill();
  process.exit(0);
});
