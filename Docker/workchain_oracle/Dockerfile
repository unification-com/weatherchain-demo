FROM node:latest

COPY ./assets/workchain_oracle /root/workchain_oracle

WORKDIR /root/workchain_oracle

RUN npm install

WORKDIR /root/workchain_oracle

CMD cd /root/workchain_oracle && sleep 20s && npm run develop 2>&1 | tee log.txt