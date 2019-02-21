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
    echo "cd /root/.go/src/github.com/unification-com/haiku-core && git checkout go_oracle" >> /root/.bash_history && \
    echo 'go run /root/.go/src/github.com/unification-com/haiku-core/oracle/oracle.go "http://172.25.0.5:8547" "http://192.168.43.20:8545" "659cbb0e2411a44db63778987b1e22153c086a95eb6b18bdf89de078917abc63" "0x345cA3e014Aaf5dcA488057592ee47305D9B3e10" 10 500005' >> /root/.bash_history && \
    echo "alias ll='ls -la'" >> /root/.bashrc

CMD cd /root/.go/src/github.com/unification-com/haiku-core && \
    git checkout go_oracle && sleep 60s && \
    go run /root/.go/src/github.com/unification-com/haiku-core/oracle/oracle.go "http://172.25.0.5:8547" "http://192.168.43.20:8545" "659cbb0e2411a44db63778987b1e22153c086a95eb6b18bdf89de078917abc63" "0x345cA3e014Aaf5dcA488057592ee47305D9B3e10" 10 500005 2>&1 | tee /root/oracle_log.txt


CMD go run /root/.go/src/github.com/unification-com/oracle/oracle.go "http://172.25.0.5:8547" "http://192.168.43.20:8545" "659cbb0e2411a44db63778987b1e22153c086a95eb6b18bdf89de078917abc63" "0x345cA3e014Aaf5dcA488057592ee47305D9B3e10" 10 500005 2>&1 | tee /root/oracle_log.txt
