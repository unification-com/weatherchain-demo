FROM node:8

COPY ./assets/weather-oracle-contract /root/weather-oracle-contract
COPY ./assets/.env /root/weather-oracle-contract/.env
COPY ./assets/weather-oracle-service /root/weather-oracle-service
COPY ./assets/.env /root/weather-oracle-service/.env
COPY ./assets/weather-ui /root/weather-ui
COPY ./assets/.env /root/weather-ui/.env
COPY ./assets/deploy_weather_service.sh /root/deploy_weather_service.sh

RUN chmod +x /root/deploy_weather_service.sh

WORKDIR /root/weather-oracle-contract

RUN npm install -g truffle
RUN npm install
RUN truffle compile

WORKDIR /root/weather-oracle-service
RUN npm install

WORKDIR /root/weather-ui
RUN npm install

CMD cd /root && ./deploy_weather_service.sh

#EXPOSE 4040