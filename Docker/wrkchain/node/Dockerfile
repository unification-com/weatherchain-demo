FROM debian:stretch-slim

RUN apt-get update && \
    apt-get -y install \
        build-essential \
        git \
        telnet \
        vim \
        wget

WORKDIR "/root"

ARG GO_VERSION
ARG PRIVATE_KEY
ARG WALLET_PASS
ARG WRKCHAIN_DATA_DIR
ARG SUBNET_IP

RUN wget https://dl.google.com/go/go1.$GO_VERSION.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.$GO_VERSION.linux-amd64.tar.gz && \
    rm go1.$GO_VERSION.linux-amd64.tar.gz && \
    mkdir ~/.go

ENV GOPATH="/root/.go"
ENV GOROOT="/usr/local/go"
ENV PATH="/usr/local/go/bin:${PATH}"

RUN go get github.com/ethereum/go-ethereum
RUN go install github.com/ethereum/go-ethereum/cmd/geth

ADD ./assets/genesis.json /root/$WRKCHAIN_DATA_DIR/genesis.json
COPY ./assets/node_keys /root/$WRKCHAIN_DATA_DIR/node_keys
COPY ./assets/static-nodes.json /root/$WRKCHAIN_DATA_DIR/static-nodes.json

RUN sed -i "s/172.25.1/${SUBNET_IP}/g" /root/$WRKCHAIN_DATA_DIR/static-nodes.json \
    && cat /root/$WRKCHAIN_DATA_DIR/static-nodes.json

RUN echo $WALLET_PASS > /root/.walletpassword
RUN echo $PRIVATE_KEY > /root/.privatekey
RUN /root/.go/bin/geth --datadir=/root/$WRKCHAIN_DATA_DIR init /root/$WRKCHAIN_DATA_DIR/genesis.json
RUN /root/.go/bin/geth --datadir=/root/$WRKCHAIN_DATA_DIR account import --password /root/.walletpassword  /root/.privatekey
RUN echo "alias ll='ls -la'" >> /root/.bashrc
