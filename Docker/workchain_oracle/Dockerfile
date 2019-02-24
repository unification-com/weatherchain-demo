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
    mkdir -p ${GOPATH}/src/github.com/unification-com

RUN cd ${GOPATH}/src/github.com/unification-com && \
    git clone https://github.com/unification-com/mainchain.git

RUN apt-get install -y software-properties-common

ENV PATH="/usr/local/go/bin:/root/.go/bin:${PATH}"

RUN echo "clear; clean; work" >> /root/.bash_history && \
    echo "alias ll='ls -la'" >> /root/.bashrc

RUN cd ${GOPATH}/src/github.com/unification-com && \
    git clone https://github.com/unification-com/workchain-root-oracle

ENV mainchain_rpc=""
ENV workchain_rpc=""
ENV private_key=""
ENV workchain_root_address=""
ENV timeout=""
ENV workchain_chain_id=""

CMD go run /root/.go/src/github.com/unification-com/workchain-root-oracle/oracle.go "$workchain_rpc" "$mainchain_rpc" "$private_key" "$workchain_root_address" $timeout $workchain_chain_id 2>&1 | tee /root/oracle_log.txt
