#!/bin/bash

cd /root/weather-oracle-contract
truffle migrate --reset 2>&1 | tee sc_log.txt

WORKCHAIN_NETWORK_ID_ENV=$(grep 'WORKCHAIN_NETWORK_ID' .env)
WORKCHAIN_NETWORK_ID=${WORKCHAIN_NETWORK_ID_ENV##*=}

sed -i "s/WEATHER_ORACLE_CONTRACT_ADDRESS=/WEATHER_ORACLE_CONTRACT_ADDRESS=$(node abi.js addr ${WORKCHAIN_NETWORK_ID})/g" /root/weather-oracle-contract/.env
sed -i "s/WEATHER_ORACLE_ABI=/WEATHER_ORACLE_ABI=$(node abi.js)/g" /root/weather-oracle-contract/.env
sed -i "s/WEATHER_ORACLE_CONTRACT_ADDRESS=/WEATHER_ORACLE_CONTRACT_ADDRESS=$(node abi.js addr ${WORKCHAIN_NETWORK_ID})/g" /root/weather-oracle-service/.env
sed -i "s/WEATHER_ORACLE_ABI=/WEATHER_ORACLE_ABI=$(node abi.js)/g" /root/weather-oracle-service/.env
sed -i "s/WEATHER_ORACLE_CONTRACT_ADDRESS=/WEATHER_ORACLE_CONTRACT_ADDRESS=$(node abi.js addr ${WORKCHAIN_NETWORK_ID})/g" /root/weather-ui/.env
sed -i "s/WEATHER_ORACLE_ABI=/WEATHER_ORACLE_ABI=$(node abi.js)/g" /root/weather-ui/.env

sleep 1s

cd /root/weather-oracle-service && npm run develop 2>&1 | tee service_log.txt & cd /root/weather-ui && node server.js