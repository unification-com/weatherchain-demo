#!/bin/bash

cp /root/wrkchain_validator.env /root/weather-oracle-contract/.env
cd /root/weather-oracle-contract
truffle compile && truffle migrate --reset 2>&1 | tee sc_log.txt

WRKCHAIN_NETWORK_ID_ENV=$(grep 'WRKCHAIN_NETWORK_ID' /root/weather-oracle-contract/.env)
WRKCHAIN_NETWORK_ID=${WRKCHAIN_NETWORK_ID_ENV##*=}

sed -i "s/WEATHER_ORACLE_CONTRACT_ADDRESS=/WEATHER_ORACLE_CONTRACT_ADDRESS=$(node abi.js addr ${WRKCHAIN_NETWORK_ID})/g" /root/weather-oracle-contract/.env
sed -i "s/WEATHER_ORACLE_ABI=/WEATHER_ORACLE_ABI=$(node abi.js)/g" /root/weather-oracle-contract/.env

cp /root/weather-oracle-contract/.env /root/weather-oracle-service/.env
cp /root/weather-oracle-contract/.env /root/weather-ui/.env

cd /root/weather-oracle-service && npm run develop 2>&1 | tee service_log.txt & cd /root/weather-ui && node server.js