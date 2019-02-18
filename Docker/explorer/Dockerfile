FROM node:6.11-alpine

WORKDIR "/opt"

RUN apk add --update git make g++ && \
    git clone https://bitbucket.org/designisdead/blockchain-explorer.git

WORKDIR "/opt/blockchain-explorer"
RUN git checkout c6e12f1
RUN npm install

# change port to 8081
RUN grep -lr -e '8080' ./bin/www | xargs sed -i 's/8080/8081/g'
RUN grep -lr -e '8545' * | xargs sed -i 's/8545/8547/g'
RUN grep -lr -e ' ETH' * | xargs sed -i 's/'\'' ETH'\''/'\'' RAIN'\''/g'

CMD npm run start

EXPOSE 8081
