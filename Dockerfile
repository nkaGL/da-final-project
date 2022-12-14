FROM alpine:latest

USER root
WORKDIR /app

COPY package.json /app
RUN apk add --no-cache nodejs npm
RUN npm install

COPY . .

EXPOSE 8080
CMD [ "node", "/app/app.js" ]
