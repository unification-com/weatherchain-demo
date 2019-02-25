FROM node:latest

RUN apt-get update && \
    apt-get -y install \
        git \
        make build-essential

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

RUN go install github.com/unification-com/mainchain/cmd/bootnode


COPY ./assets/init /root/init
COPY ./assets/init_workchain.sh /root/init_workchain.sh

WORKDIR /root

RUN cd /root && git clone https://github.com/unification-com/workchain-root-contract.git

RUN chmod +x init_workchain.sh

WORKDIR /root/init

RUN npm install

WORKDIR /root/workchain-root-contract
RUN npm install -g truffle
RUN npm install

CMD cd /root && ./init_workchain.sh
