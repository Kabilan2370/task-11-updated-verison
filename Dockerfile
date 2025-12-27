FROM node:20

WORKDIR /app

RUN apt-get update && \
    apt-get install -y python3 make g++ bash && \
    rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build

ENV NODE_ENV=production

EXPOSE 1337

CMD ["npm", "run", "start"]
