FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && \
    git clone https://bitbucket.org/designisdead/blockchain-explorer.git

WORKDIR "/opt/blockchain-explorer"
RUN git checkout c6e12f1 && \
    npm install

ARG workchain_rpc_port
ARG workchain_explorer_port
ARG coin_sym

# change port from 8080 to configured port
RUN sed -i -E "s/8080/${workchain_explorer_port}/g" bin/www && \
    sed -i -E "s/localhost:8545/localhost:${workchain_rpc_port}/g" views/layout/default_layout.jade && \
    grep -lr -e ' ETH' * | xargs sed -i -E "s/ ETH/ ${coin_sym}/g" && \
    grep -lr -e 'Ethereum' * | xargs sed -i 's/Ethereum/Weatherchain/g' && \
    grep -lr -e 'Ether' * | xargs sed -i 's/Ether/Weatherchain/g'&& \
    grep -rl -e '(ethusd' * | xargs sed -i 's/(ethusd/(0.01/g'

ENV explorer_port=""

CMD npm run start

EXPOSE $workchain_explorer_port
