FROM node:latest

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

N

EXPOSE 8080

CMD ["npm", "start"]