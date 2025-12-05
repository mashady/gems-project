FROM node:20

WORKDIR /app

COPY frontend/package*.json ./
RUN npm install

# Copy source files excluding node_modules
COPY frontend/src ./src
COPY frontend/public ./public
COPY frontend/index.html ./
COPY frontend/vite.config.js ./
COPY frontend/eslint.config.js ./

EXPOSE 5173

CMD ["npm", "run", "dev"]
