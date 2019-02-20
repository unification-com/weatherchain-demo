FROM node:8


WORKDIR /root

COPY ./assets/weather-oracle-contract /root/assets/weather-oracle-contract
COPY ./assets/weatherchain.env /root/assets/weather-oracle-contract/.env
COPY ./assets/weather-oracle-service /root/assets/weather-oracle-service
COPY ./assets/weatherchain.env /root/assets/weather-oracle-service/.env
COPY ./assets/weather-ui /root/assets/weather-ui
COPY ./assets/weatherchain.env /root/assets/weather-ui/.env

WORKDIR /root/assets/weather-oracle-contract

RUN npm install -g truffle
RUN npm install
RUN truffle compile

WORKDIR /root/assets/weather-oracle-service
RUN npm install

WORKDIR /root/weather-ui
RUN npm install

CMD cd /root/assets/weather-oracle-contract && truffle migrate --reset 2>&1 | tee sc_log.txt \
    && cd /root/assets/weather-oracle-service && npm run develop 2>&1 | tee service_log.txt \
    & cd /root/assets/weather-ui && node server.js

#EXPOSE 4040