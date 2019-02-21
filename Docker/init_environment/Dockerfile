FROM node:latest

COPY ./assets/workchain_root_sc /root/workchain_root_sc
COPY ./assets/weatherchain.env /root/workchain_root_sc/.env

WORKDIR /root/workchain_root_sc

RUN npm install -g truffle
RUN npm install
RUN truffle compile

WORKDIR /root/assets

CMD cd /root/workchain_root_sc && truffle migrate --reset \
    && sed -i "s/WORKCHAIN_ROOT_CONTRACT_ADDRESS=/WORKCHAIN_ROOT_CONTRACT_ADDRESS=$(node abi.js addr 12345)/g" /root/assets/weatherchain.env \
    && sed -i "s/WORKCHAIN_ROOT_ABI=/WORKCHAIN_ROOT_ABI=$(node abi.js)/g" /root/assets/weatherchain.env
