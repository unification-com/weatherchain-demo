FROM ubuntu:xenial

RUN apt-get update \
     && apt-get install -y wget software-properties-common \
     && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

RUN add-apt-repository -y ppa:ethereum/ethereum

ARG binary
RUN apt-get update \
     && apt-get install -y ethereum

ARG password
ARG privatekey
ARG genesis
RUN echo $password > /root/.accountpassword
RUN echo $privatekey > /root/.privatekey
ADD ./assets/build/$genesis /root/assets/genesis.json
RUN geth init /root/assets/genesis.json
RUN geth account import --password /root/.accountpassword  /root/.privatekey

ENV address=""
ENV bootnodeId=""
ENV bootnodeIp=""
ENV chainId=""
ENV listenport=""
ENV bootnode_port=""
ENV rpcport=""

CMD exec geth --bootnodes "enode://$bootnodeId@$bootnodeIp:$bootnode_port" --networkid "$chainId" --verbosity=4 --rpc --rpcaddr "0.0.0.0" --rpcport "$rpcport" --rpcapi "eth,web3,net,admin,debug,db" --rpccorsdomain "*" --syncmode="full" --port $listenport

EXPOSE $rpcport
EXPOSE $listenport