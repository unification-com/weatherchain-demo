FROM ubuntu:xenial

RUN apt-get update && \
    apt-get -y install \
        git \
        vim \
        telnet \
        make build-essential \
        wget curl

WORKDIR "/root"

RUN wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz && \
    mkdir ~/.go

ENV GOPATH="/root/.go"
ENV GOROOT="/usr/local/go"
ENV PATH="/usr/local/go/bin:${PATH}"

RUN mkdir /root/.ssh && \
    mkdir -p ${GOPATH}/src/github.com/unification-com/mainchain

COPY ./assets/ssh/github_rsa /root/.ssh/github_rsa

RUN eval "$(ssh-agent)" && \
    chmod 600 /root/.ssh/github_rsa && \
    ssh-add /root/.ssh/github_rsa && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    cd ${GOPATH}/src/github.com/unification-com && \
    git clone git@github.com:unification-com/mainchain.git

RUN eval "$(ssh-agent)" && \
    chmod 600 /root/.ssh/github_rsa && \
    ssh-add /root/.ssh/github_rsa && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts && \
    cd ${GOPATH}/src/github.com/unification-com && \
    git clone git@github.com:unification-com/haiku-core.git

RUN apt-get install -y software-properties-common

RUN add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get -y install \
        solc

RUN go install github.com/unification-com/mainchain/cmd/abigen

ENV PATH="/usr/local/go/bin:/root/.go/bin:${PATH}"

COPY ./assets/.bashrc /root/.bashrc

RUN echo "clear; clean; work" >> /root/.bash_history && \
    echo 'go run /root/.go/src/github.com/unification-com/haiku-core/oracle/oracle.go "https://mainnet.infura.io" "http://ganachecli:8545" "6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1" "0xC89Ce4735882C9F0f0FE26686c53074E09B0D550" 60' >> /root/.bash_history && \
    echo "alias ll='ls -la'" >> /root/.bashrc
