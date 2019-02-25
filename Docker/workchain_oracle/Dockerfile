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

RUN mkdir /root/.ssh && \
    mkdir -p ${GOPATH}/src/github.com/unification-com && \
    cd ${GOPATH}/src/github.com/unification-com && \
    git clone https://github.com/unification-com/mainchain.git && \
    git clone https://github.com/unification-com/workchain-root-oracle

ENV PATH="/usr/local/go/bin:/root/.go/bin:${PATH}"

ENV mainchain_rpc=""
ENV workchain_rpc=""
ENV private_key=""
ENV workchain_root_address=""
ENV timeout=""
ENV workchain_chain_id=""

RUN echo "go run /root/.go/src/github.com/unification-com/workchain-root-oracle/oracle.go" >> /root/.bash_history && \
    echo "alias ll='ls -la'" >> /root/.bashrc

CMD go run /root/.go/src/github.com/unification-com/workchain-root-oracle/oracle.go "$workchain_rpc" "$mainchain_rpc" "$private_key" "$workchain_root_address" $timeout $workchain_chain_id 2>&1 | tee /root/oracle_log.txt
