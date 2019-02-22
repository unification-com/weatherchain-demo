#!/bin/bash

cd /root/init

# Generate a unique workchain ID
CHAIN_ID=$(od -N 4 -t uL -An /dev/urandom | tr -d " ")

# generate a unique wallet mnemonic
MNEMONIC=$(node init.js mnemonic)

WORKCHAIN_RPC_HOST=$(grep 'WORKCHAIN_RPC_HOST' /root/assets/weatherchain.env)
WORKCHAIN_RPC_PORT=$(grep 'WORKCHAIN_RPC_PORT' /root/assets/weatherchain.env)

#Generate bootnode key
/root/.go/bin/bootnode -genkey /root/assets/bootnode.key
BOOTNODE_ID=$(/root/.go/bin/bootnode -nodekey /root/assets/bootnode.key -writeaddress)
sed -i "s/BOOTNODE_ID=/BOOTNODE_ID=$BOOTNODE_ID/g" /root/assets/weatherchain.env

# Write Workchain's Web3 provider to .env
sed -i "s/WORKCHAIN_WEB3_PROVIDER_URL=/WORKCHAIN_WEB3_PROVIDER_URL=http:\/\/${WORKCHAIN_RPC_HOST##*=}:${WORKCHAIN_RPC_PORT##*=}/g" /root/assets/weatherchain.env

# Write Mnemonic to .env
sed -i "s/MNEMONIC=/MNEMONIC=$MNEMONIC/g" /root/assets/weatherchain.env

# Get EV and RPC node addresses and keys, then write to .env
EV1_PUBLIC_ADDRESS=$(node init.js address "$MNEMONIC" 0)
sed -i "s/EV1_PUBLIC_ADDRESS=/EV1_PUBLIC_ADDRESS=$EV1_PUBLIC_ADDRESS/g" /root/assets/weatherchain.env

EV1_PRIVATE_KEY=$(node init.js private_key "$MNEMONIC" 0)
sed -i "s/EV1_PRIVATE_KEY=/EV1_PRIVATE_KEY=$EV1_PRIVATE_KEY/g" /root/assets/weatherchain.env

EV2_PUBLIC_ADDRESS=$(node init.js address "$MNEMONIC" 1)
sed -i "s/EV2_PUBLIC_ADDRESS=/EV2_PUBLIC_ADDRESS=$EV2_PUBLIC_ADDRESS/g" /root/assets/weatherchain.env

EV2_PRIVATE_KEY=$(node init.js private_key "$MNEMONIC" 1)
sed -i "s/EV2_PRIVATE_KEY=/EV2_PRIVATE_KEY=$EV2_PRIVATE_KEY/g" /root/assets/weatherchain.env

RPC_NODE_PUBLIC_ADDRESS=$(node init.js address "$MNEMONIC" 2)
sed -i "s/RPC_NODE_PUBLIC_ADDRESS=/RPC_NODE_PUBLIC_ADDRESS=$RPC_NODE_PUBLIC_ADDRESS/g" /root/assets/weatherchain.env

RPC_NODE_PRIVATE_KEY=$(node init.js private_key "$MNEMONIC" 2)
sed -i "s/RPC_NODE_PRIVATE_KEY=/RPC_NODE_PRIVATE_KEY=$RPC_NODE_PRIVATE_KEY/g" /root/assets/weatherchain.env

# Write EV1 and EV2 public addresses to "WORKCHAIN_EVS" variable in .env
# Used when the Workchain Root smart contract is deployed
sed -i "s/WORKCHAIN_EV_2/$EV2_PUBLIC_ADDRESS/g" /root/assets/weatherchain.env
sed -i "s/WORKCHAIN_EV_1/$EV1_PUBLIC_ADDRESS/g" /root/assets/weatherchain.env

# Set the Workchain's CHain ID in .env
sed -i "s/WORKCHAIN_NETWORK_ID=/WORKCHAIN_NETWORK_ID=$CHAIN_ID/g" /root/assets/weatherchain.env

# Psuedo generate the genesis.json
cp /root/assets/genesis_template.json /root/assets/weatherchain_genesis.json
sed -i "s/SEALERADDRESSES/${EV1_PUBLIC_ADDRESS:2}${EV2_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json

sed -i "s/EV1/${EV1_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json
sed -i "s/EV2/${EV2_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json
sed -i "s/RPC/${RPC_NODE_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json
sed -i "s/WORKCHAIN_ID/${CHAIN_ID}/g" /root/assets/weatherchain_genesis.json

# Write the genesis.json to .env. Used when deploying the Workchain Root smart contract
while IFS='' read -r line || [[ -n "$line" ]]; do
    sed -i "s/WORKCHAIN_GENESIS=/WORKCHAIN_GENESIS=${line}/g" /root/assets/weatherchain.env
done < /root/assets/weatherchain_genesis.json

# Fund the generated addresses on Mainchain using the faucet
MAINCHAIN_FAUCET_URL=$(grep 'MAINCHAIN_FAUCET_URL' /root/assets/weatherchain.env)
echo "fund $EV1_PUBLIC_ADDRESS"
wget -T 3 -t 1 -O - ${MAINCHAIN_FAUCET_URL##*=}/sendtx?to=$EV1_PUBLIC_ADDRESS
sleep 6s
echo "fund $EV2_PUBLIC_ADDRESS"
wget -T 3 -t 1 -O - ${MAINCHAIN_FAUCET_URL##*=}/sendtx?to=$EV2_PUBLIC_ADDRESS
sleep 6s
echo "fund $RPC_NODE_PUBLIC_ADDRESS"
wget -T 3 -t 1 -O - ${MAINCHAIN_FAUCET_URL##*=}/sendtx?to=$RPC_NODE_PUBLIC_ADDRESS

# Copy the generated .env to the Smart Contract deployment directory
# since it needs some values during deployment
cp /root/assets/weatherchain.env /root/workchain_root_sc/.env

# Compile Workchain Root smart contract
cd /root/workchain_root_sc
truffle compile
truffle migrate --reset
sed -i "s/WORKCHAIN_ROOT_CONTRACT_ADDRESS=/WORKCHAIN_ROOT_CONTRACT_ADDRESS=$(node abi.js addr 12345)/g" /root/assets/weatherchain.env
sed -i "s/WORKCHAIN_ROOT_ABI=/WORKCHAIN_ROOT_ABI=$(node abi.js)/g" /root/assets/weatherchain.env
