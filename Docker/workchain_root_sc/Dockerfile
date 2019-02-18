FROM node:latest

COPY ./assets/workchain_root_sc /root/workchain_root_sc
COPY ./assets/workchain_sc.env /root/workchain_root_sc/.env

WORKDIR /root/workchain_root_sc

RUN npm install -g truffle
RUN npm install
RUN truffle compile

WORKDIR /root/workchain_root_sc

CMD cd /root/workchain_root_sc && truffle migrate --reset 2>&1 | tee log.txt \
    && tail -f /dev/null