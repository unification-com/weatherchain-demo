#!/bin/bash

SUBNET_IP=$1

sleep 20

wrkoracle register --password /root/.wrkchain_oracle/.password --account 0x83197E2E58929c41f6Ebe3b4eA6D6a07Cfb4A97B --genesis /root/.wrkchain_oracle/genesis.json --auth 0x83197E2E58929c41f6Ebe3b4eA6D6a07Cfb4A97B --mainchain.rpc "http://$SUBNET_IP.15:8101"

sleep 10

wrkoracle record --password /root/.wrkchain_oracle/.password --account 0x83197E2E58929c41f6Ebe3b4eA6D6a07Cfb4A97B --mainchain.rpc "http://$SUBNET_IP.15:8101" --wrkchain.rpc "http://$SUBNET_IP.25:8547" --hash.parent --hash.receipt --hash.tx --hash.state --freq 10
