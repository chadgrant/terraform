FROM node:4.4-slim

WORKDIR /app/

ADD package.json .

RUN npm i

ADD test ./test/
ADD *.js ./

CMD ["npm","test"]
