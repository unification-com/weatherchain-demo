FROM node:8

COPY ./assets/ /root/

RUN chmod +x /root/scripts/deploy_weather_service.sh

WORKDIR /root/weather-oracle-contract

RUN npm install -g truffle && npm install

WORKDIR /root/weather-oracle-service
RUN npm install

WORKDIR /root/weather-ui
RUN npm install

CMD cd /root && ./scripts/deploy_weather_service.sh
