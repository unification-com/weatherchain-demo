#!/bin/bash

cp /root/build/.env /root/weather-oracle-contract/.env
cd /root/weather-oracle-contract
truffle compile && truffle migrate --reset 2>&1 | tee sc_log.txt

WORKCHAIN_NETWORK_ID_ENV=$(grep 'WORKCHAIN_NETWORK_ID' /root/build/.env)
WORKCHAIN_NETWORK_ID=${WORKCHAIN_NETWORK_ID_ENV##*=}

sed -i "s/WEATHER_ORACLE_CONTRACT_ADDRESS=/WEATHER_ORACLE_CONTRACT_ADDRESS=$(node abi.js addr ${WORKCHAIN_NETWORK_ID})/g" /root/build/.env
sed -i "s/WEATHER_ORACLE_ABI=/WEATHER_ORACLE_ABI=$(node abi.js)/g" /root/build/.env

cp /root/build/.env /root/weather-oracle-service/.env
cp /root/build/.env /root/weather-ui/.env

cd /root/weather-oracle-service && npm run develop 2>&1 | tee service_log.txt & cd /root/weather-ui && node server.js