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

RUN echo "go install github.com/unification-com/haiku-core/oracle" >> /root/.bash_history && \
    echo "go run /root/.go/src/github.com/unification-com/haiku-core/oracle/oracle.go" >> /root/.bash_history && \
    echo "/root/.go/bin/oracle" >> /root/.bash_history && \
    echo "alias ll='ls -la'" >> /root/.bashrc