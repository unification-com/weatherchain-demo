FROM node:latest

COPY ./assets/workchain_root_sc /root/workchain_root_sc
COPY ./assets/init /root/init
COPY ./assets/init_workchain.sh /root/init_workchain.sh

WORKDIR /root
RUN chmod +x init_workchain.sh

WORKDIR /root/init

RUN npm install

WORKDIR /root/workchain_root_sc
RUN npm install -g truffle
RUN npm install

CMD cd /root && ./init_workchain.sh

#CMD cd /root/workchain_root_sc && truffle migrate --reset \
#    && sed -i "s/WORKCHAIN_ROOT_CONTRACT_ADDRESS=/WORKCHAIN_ROOT_CONTRACT_ADDRESS=$(node abi.js addr 12345)/g" /root/assets/weatherchain.env \
#    && sed -i "s/WORKCHAIN_ROOT_ABI=/WORKCHAIN_ROOT_ABI=$(node abi.js)/g" /root/assets/weatherchain.env
