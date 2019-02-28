FROM ubuntu:xenial

RUN apt-get update \
     && apt-get install -y wget software-properties-common \
     && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

RUN add-apt-repository -y ppa:ethereum/ethereum

ARG binary
RUN apt-get update \
     && apt-get install -y ethereum

COPY ./assets/build/bootnode.key /root/assets/bootnode.key

ENV bootnode_port=""

CMD exec bootnode -nodekey /root/assets/bootnode.key -verbosity 4 --addr :$bootnode_port

EXPOSE $bootnode_port