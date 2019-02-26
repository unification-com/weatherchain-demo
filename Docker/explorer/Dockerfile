FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && \
    git clone https://bitbucket.org/designisdead/blockchain-explorer.git

WORKDIR "/opt/blockchain-explorer"
RUN git checkout c6e12f1 && \
    npm install

# change port to 8081
RUN grep -lr -e '8080' ./bin/www | xargs sed -i 's/8080/8081/g' && \
    sed -i "s/localhost:8545/localhost:8547/g" views/layout/default_layout.jade && \
    grep -lr -e ' ETH' * | xargs sed -i 's/ ETH/ RAIN/g' && \
    grep -lr -e 'Ethereum' * | xargs sed -i 's/Ethereum/Weatherchain/g' && \
    grep -lr -e 'Ether' * | xargs sed -i 's/Ether/Weatherchain/g'

CMD npm run start

EXPOSE 8081
