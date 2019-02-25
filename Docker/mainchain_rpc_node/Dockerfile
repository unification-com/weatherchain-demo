FROM ubuntu:xenial

RUN apt-get update && \
    apt-get -y install \
        git \
        vim \
        telnet \
        make build-essential software-properties-common \
        wget curl && \
    apt-get autoremove && \
    apt-get clean

WORKDIR "/root"

RUN wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz && \
    mkdir ~/.go

ENV GOPATH="/root/.go"
ENV GOROOT="/usr/local/go"
ENV PATH="/usr/local/go/bin:${PATH}"

RUN mkdir /root/.ssh && \
    mkdir -p ${GOPATH}/src/github.com/unification-com

RUN cd ${GOPATH}/src/github.com/unification-com && \
    git clone https://github.com/unification-com/mainchain.git

RUN echo "alias ll='ls -la'" >> /root/.bashrc

RUN go install github.com/unification-com/mainchain/cmd/geth

ARG password
ARG privatekey
RUN echo $password > ~/.accountpassword
RUN echo $privatekey > ~/.privatekey
ADD ./assets/genesis.json ./genesis.json
RUN /root/.go/bin/geth init genesis.json
RUN /root/.go/bin/geth account import --password ~/.accountpassword  ~/.privatekey

ENV address=""
ENV bootnodeId=""
ENV bootnodeIp=""
ENV CHAIN_ID=""

CMD exec /root/.go/bin/geth --bootnodes "enode://$bootnodeId@$bootnodeIp:30401" --networkid ${CHAIN_ID} --verbosity=4 --rpc --rpcaddr "0.0.0.0" --rpcapi "eth,web3,net,admin,debug,db" --rpccorsdomain "*" --rpcvhosts "*" --syncmode="full"

EXPOSE 8545
