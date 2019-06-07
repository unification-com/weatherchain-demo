FROM und-devnet-base

WORKDIR "/root"

# Build args
ARG password
ARG privatekey
ARG SUBNET_IP

RUN echo $password > /root/.accountpassword && \
    echo $privatekey > /root/.privatekey

RUN sed -i "s/172.25.1/${SUBNET_IP}/g" /root/.und_mainchain/und/static-nodes.json \
    && cat /root/.und_mainchain/und/static-nodes.json

RUN /root/.go/bin/und --datadir "/root/.und_mainchain" init /root/.und_mainchain/genesis.json
RUN /root/.go/bin/und --datadir "/root/.und_mainchain" account import --password /root/.accountpassword  /root/.privatekey
