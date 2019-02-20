FROM ubuntu:xenial

RUN apt-get update \
     && apt-get install -y wget software-properties-common \
     && rm -rf /var/lib/apt/lists/*

WORKDIR "/root"

RUN add-apt-repository -y ppa:ethereum/ethereum

ARG binary
RUN apt-get update \
     && apt-get install -y ethereum

COPY ./assets/bootnode.key /root/assets/bootnode.key

CMD exec bootnode -nodekey /root/assets/bootnode.key -verbosity 4 --addr :30304

EXPOSE 30304/udp