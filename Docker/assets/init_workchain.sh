#!/usr/bin/env bash

cd /root/init

sed -i "s/GEN_MNEMONIC=/GEN_MNEMONIC=$(node init.js mnemonic)/g" /root/assets/weatherchain.env


#cd /root/workchain_root_sc
#npm install -g truffle
#npm install
#truffle compile

#cd /root/workchain_root_sc && truffle migrate --reset \
#    && sed -i "s/WORKCHAIN_ROOT_CONTRACT_ADDRESS=/WORKCHAIN_ROOT_CONTRACT_ADDRESS=$(node abi.js addr 12345)/g" /root/assets/weatherchain.env \
#    && sed -i "s/WORKCHAIN_ROOT_ABI=/WORKCHAIN_ROOT_ABI=$(node abi.js)/g" /root/assets/weatherchain.env