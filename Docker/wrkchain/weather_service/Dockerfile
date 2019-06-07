FROM node:8

COPY ./assets/ /root/

RUN chmod +x /root/scripts/deploy_weather_service.sh

WORKDIR /root/weather-oracle-contract

RUN npm install -g truffle && npm install

WORKDIR /root/weather-oracle-service
RUN npm install

WORKDIR /root/weather-ui
RUN npm install

ARG WRKCHAIN_WEB3_PROVIDER_URL
ARG WRKCHAIN_RPC_HOST
ARG WRKCHAIN_RPC_PORT
ARG MAINCHAIN_WEB3_PROVIDER_URL

RUN sed -i "s/WRKCHAIN_WEB3_PROVIDER_URL=/WRKCHAIN_WEB3_PROVIDER_URL=http:\/\/${WRKCHAIN_WEB3_PROVIDER_URL}/g" /root/wrkchain_validator.env && \
    sed -i "s/WRKCHAIN_RPC_HOST=/WRKCHAIN_RPC_HOST=${WRKCHAIN_RPC_HOST}/g" /root/wrkchain_validator.env && \
    sed -i "s/WRKCHAIN_RPC_PORT=/WRKCHAIN_RPC_PORT=${WRKCHAIN_RPC_PORT}/g" /root/wrkchain_validator.env && \
    sed -i "s/MAINCHAIN_WEB3_PROVIDER_URL=/MAINCHAIN_WEB3_PROVIDER_URL=http:\/\/${MAINCHAIN_WEB3_PROVIDER_URL}/g" /root/wrkchain_validator.env

CMD cd /root && ./scripts/deploy_weather_service.sh
