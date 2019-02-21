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
    echo 'go run /root/.go/src/github.com/unification-com/oracle/oracle.go "http://172.25.0.5:8547" "http://192.168.43.20:8545" "659cbb0e2411a44db63778987b1e22153c086a95eb6b18bdf89de078917abc63" "0x345cA3e014Aaf5dcA488057592ee47305D9B3e10" 10 500005' >> /root/.bash_history && \
    echo "alias ll='ls -la'" >> /root/.bashrc

COPY ./assets/oracle /root/.go/src/github.com/unification-com/oracle

CMD go run /root/.go/src/github.com/unification-com/oracle/oracle.go "http://172.25.0.5:8547" "http://192.168.43.20:8545" "659cbb0e2411a44db63778987b1e22153c086a95eb6b18bdf89de078917abc63" "0x345cA3e014Aaf5dcA488057592ee47305D9B3e10" 10 500005 2>&1 | tee /root/oracle_log.txt
