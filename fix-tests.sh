#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔧 Начинаем исправление тестов...${NC}\n"

# Список файлов для исправления
TEST_FILES=(
  "test/auth.test.js"
  "test/products.test.js"
  "test/orders.test.js"
  "test/payments.test.js"
  "test/batches.test.js"
  "test/batches-crud.test.js"
  "test/integration.test.js"
  "test/settings.test.js"
  "test/api-integration.test.js"
)

# Проверка безопасности для добавления в начало каждого теста
SAFETY_CHECK='// 🚨 КРИТИЧЕСКАЯ ПРОВЕРКА БЕЗОПАСНОСТИ
if (process.env.NODE_ENV !== '\''test'\'') {
  throw new Error('\''🚨 Этот тест можно запускать ТОЛЬКО с NODE_ENV=test'\'');
}

'

# Импорт cleanDatabase
CLEANER_IMPORT="const { cleanDatabase } = require('./helpers/db-cleaner');\n"

# Обрабатываем каждый файл
for file in "${TEST_FILES[@]}"; do
  if [ -f "$file" ]; then
    echo -e "${YELLOW}Обрабатываю: $file${NC}"
    
    # Проверяем есть ли уже защита
    if grep -q "NODE_ENV !== 'test'" "$file"; then
      echo -e "${GREEN}✅ Защита уже есть, пропускаю${NC}\n"
      continue
    fi
    
    # Создаём резервную копию
    cp "$file" "$file.backup"
    
    # Добавляем импорт cleanDatabase после других импортов
    if ! grep -q "cleanDatabase" "$file"; then
      # Находим последний require и добавляем после него
      sed -i "/^const.*require/a\\${CLEANER_IMPORT}" "$file"
    fi
    
    # Добавляем проверку безопасности после импортов
    sed -i "/^jest.setTimeout/i\\${SAFETY_CHECK}" "$file"
    
    # Если нет jest.setTimeout, добавляем перед describe
    if ! grep -q "jest.setTimeout" "$file"; then
      sed -i "/^describe/i\\${SAFETY_CHECK}jest.setTimeout(30000);\n" "$file"
    fi
    
    echo -e "${GREEN}✅ Файл исправлен${NC}\n"
  else
    echo -e "${RED}⚠️  Файл не найден: $file${NC}\n"
  fi
done

echo -e "${GREEN}🎉 Исправление завершено!${NC}"
echo -e "${YELLOW}📝 Резервные копии сохранены с расширением .backup${NC}\n"
