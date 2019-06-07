FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && \
    git clone https://bitbucket.org/designisdead/blockchain-explorer.git

WORKDIR "/opt/blockchain-explorer"
RUN git checkout c6e12f1 && \
    npm install

ARG wrkchain_rpc
RUN sed -i "s/localhost:8545/${wrkchain_rpc}/g" views/layout/default_layout.jade && \
    sed -i "s/8080/8081/g" bin/www && \
    grep -lr -e ' ETH' * | xargs sed -i 's/ ETH/ RAIN/g' && \
    grep -lr -e 'Ethereum' * | xargs sed -i 's/Ethereum/RAIN/g'  && \
    grep -lr -e 'Ether' * | xargs sed -i 's/Ether/RAIN/g' && \
    grep -rl -e '(ethusd' * | xargs sed -i 's/(ethusd/(0.1/g' && \
    echo "PORT=8081" >> .env

CMD npm run start
