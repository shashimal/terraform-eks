FROM --platform=linux/amd64 node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install --production

COPY . .

EXPOSE 3002

CMD ["node", "server.js"]
