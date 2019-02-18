FROM node:latest

COPY ./assets/workchain_oracle /root/workchain_oracle

WORKDIR /root/workchain_oracle

RUN npm install

WORKDIR /root/workchain_oracle

COPY ./assets/workchain_oracle.env /root/workchain_oracle/.env

CMD cd /root/workchain_oracle && sleep 20s && npm run develop 2>&1 | tee sc_log.txt