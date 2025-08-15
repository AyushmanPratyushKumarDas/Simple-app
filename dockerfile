FROM node:18

WORKDIR /mnt/c/Users/ASUS/Desktop/docker_files/simple-app

COPY package*.json ./
RUN npm install

COPY . . 

EXPOSE 3000

CMD ["node", "app.js"]