const { spawn } = require('child_process');
const axios = require('axios');

const TELEGRAM_BOT_TOKEN = '8556977514:AAFlNaUu7QfDXeZDl3QWsPvZdvJhM7zzr0U';
const TELEGRAM_CHAT_ID = '2118917273';
const SERVICE_NAME = 'severnaya-korzina';

// Паттерны КРИТИЧНЫХ ошибок
const ERROR_PATTERNS = [
  /❌.*Error:/i,
  /Exception:/,
  /ECONNREFUSED/,
  /status code 5\d{2}/,
  /ReferenceError/,
  /TypeError/,
  /SyntaxError/,
  /UnhandledPromiseRejection/,
  /FATAL/,
  /CRITICAL/,
];

// Игнорируем (некритичные ошибки)
const IGNORE_PATTERNS = [
  /404.*GET/,        // 404 на GET запросы - не критично
  /404.*POST.*\/$/,  // 404 на POST / - некритично
  /200 \d+/,
  /201 \d+/,
  /304 \d+/,
];

const errorCache = new Map();
const CACHE_TIMEOUT = 600000; // 10 минут

let totalErrors = 0;
let startTime = Date.now();

async function sendTelegram(message) {
  try {
    const url = `https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage`;
    await axios.post(url, {
      chat_id: TELEGRAM_CHAT_ID,
      text: message,
      parse_mode: 'HTML'
    });
    console.log('✅ Уведомление отправлено');
  } catch (error) {
    console.error('❌ Ошибка Telegram:', error.message);
  }
}

function isError(line) {
  if (IGNORE_PATTERNS.some(pattern => pattern.test(line))) {
    return false;
  }
  return ERROR_PATTERNS.some(pattern => pattern.test(line));
}

function extractErrorSummary(line) {
  let summary = line
    .replace(/^.*?\d{2}:\d{2}:\d{2}/, '')
    .replace(/severnaya-korzina-server node\[\d+\]:\s*/, '')
    .trim();
  
  if (summary.length > 200) {
    summary = summary.substring(0, 200) + '...';
  }
  return summary;
}

function isDuplicate(errorSummary) {
  const now = Date.now();
  
  if (errorCache.has(errorSummary)) {
    const lastTime = errorCache.get(errorSummary);
    if (now - lastTime < CACHE_TIMEOUT) {
      return true;
    }
  }
  
  errorCache.set(errorSummary, now);
  
  for (const [key, time] of errorCache.entries()) {
    if (now - time > CACHE_TIMEOUT) {
      errorCache.delete(key);
    }
  }
  
  return false;
}

function formatTelegramMessage(errorSummary) {
  const uptime = Math.floor((Date.now() - startTime) / 1000 / 60);
  
  return `
🚨 <b>ОШИБКА PRODUCTION</b>

<b>Сервис:</b> ${SERVICE_NAME}
<b>Uptime:</b> ${uptime} мин
<b>Всего ошибок:</b> ${totalErrors}

<b>Ошибка:</b>
<code>${errorSummary}</code>

<b>Проверка:</b>
<code>sudo journalctl -u ${SERVICE_NAME} -n 30</code>
`.trim();
}

async function processLogLine(line) {
  if (!line.trim()) return;
  
  if (isError(line)) {
    totalErrors++;
    const errorSummary = extractErrorSummary(line);
    
    if (isDuplicate(errorSummary)) {
      console.log(`⏭️ Дубликат #${totalErrors}: ${errorSummary.substring(0, 50)}...`);
      return;
    }
    
    console.log(`\n🚨 ОШИБКА #${totalErrors}:`);
    console.log(line);
    
    const message = formatTelegramMessage(errorSummary);
    await sendTelegram(message);
  }
}

function startMonitoring() {
  console.log('🔍 Мониторинг запущен');
  console.log(`📊 Сервис: ${SERVICE_NAME}`);
  console.log(`📱 Chat ID: ${TELEGRAM_CHAT_ID}`);
  console.log(`⏱️ Кэш: ${CACHE_TIMEOUT / 1000 / 60} мин\n`);
  
  sendTelegram(`✅ <b>Мониторинг запущен</b>\n\nСервис: ${SERVICE_NAME}\nВремя: ${new Date().toLocaleString('ru-RU')}`);
  
  const journalctl = spawn('journalctl', ['-u', SERVICE_NAME, '-f', '--no-pager', '-n', '0']);
  
  journalctl.stdout.on('data', (data) => {
    const lines = data.toString().split('\n');
    lines.forEach(line => processLogLine(line));
  });
  
  journalctl.stderr.on('data', (data) => {
    console.error('❌ journalctl error:', data.toString());
  });
  
  journalctl.on('close', (code) => {
    console.log(`⚠️ Завершён с кодом ${code}`);
    sendTelegram(`⚠️ Мониторинг остановлен (код: ${code})`);
  });
  
  process.on('SIGINT', () => {
    console.log('\n👋 Остановка...');
    sendTelegram('👋 Мониторинг остановлен');
    journalctl.kill();
    process.exit(0);
  });
}

startMonitoring();
