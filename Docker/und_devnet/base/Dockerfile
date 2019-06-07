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

RUN mkdir -p ${GOPATH}/src/github.com/unification-com

RUN cd ${GOPATH}/src/github.com/unification-com && \
    git clone https://github.com/unification-com/mainchain.git --depth 1

RUN cd ${GOPATH}/src/github.com/unification-com/mainchain/cmd/und && \
    go install .

COPY ./Docker/und_devnet/assets/bootnode_keys /root/.und_mainchain/bootnode_keys
COPY ./Docker/und_devnet/assets/bootnode_keys/static-nodes-docker.json /root/.und_mainchain/und/static-nodes.json
COPY ./Docker/und_devnet/assets/genesis/genesis-50010.json /root/.und_mainchain/genesis.json

RUN echo "alias ll='ls -la'" >> /root/.bashrc
