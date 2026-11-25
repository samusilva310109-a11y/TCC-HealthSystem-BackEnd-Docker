FROM node:20-alpine

WORKDIR /usr/src/apps

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

CMD [ "node", "app.js" ]