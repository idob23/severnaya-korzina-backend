# Dockerfile
FROM node:18-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package files
COPY package*.json ./
COPY prisma/ ./prisma/

# Устанавливаем зависимости
RUN npm ci --only=production && npm cache clean --force

# Генерируем Prisma клиент
RUN npx prisma generate

# Копируем исходный код
COPY src/ ./src/

# Создаем non-root пользователя
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Создаем необходимые директории
RUN mkdir -p uploads logs && \
    chown -R nodejs:nodejs /app

# Переключаемся на non-root пользователя
USER nodejs

# Экспонируем порт
EXPOSE 3000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Запускаем приложение
CMD ["npm", "start"]