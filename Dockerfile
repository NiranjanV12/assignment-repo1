FROM node:12
RUN pwd && ls
COPY package.json package.json
COPY server.js server.js
RUN npm install
CMD ["npm","start"]
