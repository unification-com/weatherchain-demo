FROM node:8


WORKDIR /root

COPY ./assets/weather-oracle-contract /root/weather-oracle-contract
COPY ./assets/weather-oracle-contract/.env.example /root/weather-oracle-contract/.env
COPY ./assets/weather-oracle-service /root/weather-oracle-service

WORKDIR /root/weather-oracle-contract

RUN npm install -g truffle
RUN npm install
RUN truffle compile

WORKDIR /root/weather-oracle-service
RUN npm install
RUN cp .env.example .env

CMD cd /root/weather-oracle-contract && truffle migrate --reset 2>&1 | tee sc_log.txt \
    && cd /root/weather-oracle-service && npm run develop 2>&1 | tee service_log.txt