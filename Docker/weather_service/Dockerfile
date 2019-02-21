FROM node:8

COPY ./assets/weather-oracle-contract /root/weather-oracle-contract
COPY ./assets/weatherchain.env /root/weather-oracle-contract/.env
COPY ./assets/weather-oracle-service /root/weather-oracle-service
COPY ./assets/weatherchain.env /root/weather-oracle-service/.env
COPY ./assets/weather-ui /root/weather-ui
COPY ./assets/weatherchain.env /root/weather-ui/.env

WORKDIR /root/weather-oracle-contract

RUN npm install -g truffle
RUN npm install
RUN truffle compile

WORKDIR /root/weather-oracle-service
RUN npm install

WORKDIR /root/weather-ui
RUN npm install

CMD cd /root/weather-oracle-contract && truffle migrate --reset 2>&1 | tee sc_log.txt \
    && cd /root/weather-oracle-service && npm run develop 2>&1 | tee service_log.txt \
    & cd /root/weather-ui && node server.js

#EXPOSE 4040