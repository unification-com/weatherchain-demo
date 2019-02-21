#!/usr/bin/env bash

cd /root/workchain_root_sc && truffle migrate --reset
sed -i "s/WORKCHAIN_ROOT_CONTRACT_ADDRESS=/WORKCHAIN_ROOT_CONTRACT_ADDRESS=$(node abi.js addr 12345)/g" /root/assets/weatherchain.env