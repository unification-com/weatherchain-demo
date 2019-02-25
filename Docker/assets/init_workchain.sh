#!/bin/bash

cd /root/init

cat /root/init/autogen.env >> /root/assets/.env

# Generate a unique workchain ID
CHAIN_ID=$(od -N 4 -t uL -An /dev/urandom | tr -d " ")

# generate a unique wallet mnemonic
MNEMONIC=$(node init.js mnemonic)

WORKCHAIN_RPC_HOST=$(grep 'WORKCHAIN_RPC_HOST' /root/assets/.env)
WORKCHAIN_RPC_PORT=$(grep 'WORKCHAIN_RPC_PORT' /root/assets/.env)

#Generate bootnode key
/root/.go/bin/bootnode -genkey /root/assets/bootnode.key
BOOTNODE_ID=$(/root/.go/bin/bootnode -nodekey /root/assets/bootnode.key -writeaddress)
chmod +rw /root/assets/bootnode.key
sed -i "s/BOOTNODE_ID=/BOOTNODE_ID=$BOOTNODE_ID/g" /root/assets/.env

# Write Workchain's Web3 provider to .env
sed -i "s/WORKCHAIN_WEB3_PROVIDER_URL=/WORKCHAIN_WEB3_PROVIDER_URL=http:\/\/${WORKCHAIN_RPC_HOST##*=}:${WORKCHAIN_RPC_PORT##*=}/g" /root/assets/.env

# Write Mnemonic to .env
sed -i "s/MNEMONIC=/MNEMONIC=$MNEMONIC/g" /root/assets/.env

# Get EV and RPC node addresses and keys, then write to .env
EV1_PUBLIC_ADDRESS=$(node init.js address "$MNEMONIC" 0)
sed -i "s/EV1_PUBLIC_ADDRESS=/EV1_PUBLIC_ADDRESS=$EV1_PUBLIC_ADDRESS/g" /root/assets/.env

EV1_PRIVATE_KEY=$(node init.js private_key "$MNEMONIC" 0)
sed -i "s/EV1_PRIVATE_KEY=/EV1_PRIVATE_KEY=$EV1_PRIVATE_KEY/g" /root/assets/.env

EV2_PUBLIC_ADDRESS=$(node init.js address "$MNEMONIC" 1)
sed -i "s/EV2_PUBLIC_ADDRESS=/EV2_PUBLIC_ADDRESS=$EV2_PUBLIC_ADDRESS/g" /root/assets/.env

EV2_PRIVATE_KEY=$(node init.js private_key "$MNEMONIC" 1)
sed -i "s/EV2_PRIVATE_KEY=/EV2_PRIVATE_KEY=$EV2_PRIVATE_KEY/g" /root/assets/.env

RPC_NODE_PUBLIC_ADDRESS=$(node init.js address "$MNEMONIC" 2)
sed -i "s/RPC_NODE_PUBLIC_ADDRESS=/RPC_NODE_PUBLIC_ADDRESS=$RPC_NODE_PUBLIC_ADDRESS/g" /root/assets/.env

RPC_NODE_PRIVATE_KEY=$(node init.js private_key "$MNEMONIC" 2)
sed -i "s/RPC_NODE_PRIVATE_KEY=/RPC_NODE_PRIVATE_KEY=$RPC_NODE_PRIVATE_KEY/g" /root/assets/.env

RPC_NODE_PUBLIC_ADDRESS_MAINCHAIN=$(node init.js address "$MNEMONIC" 3)
sed -i "s/RPC_NODE_PUBLIC_ADDRESS_MAINCHAIN=/RPC_NODE_PUBLIC_ADDRESS_MAINCHAIN=$RPC_NODE_PUBLIC_ADDRESS_MAINCHAIN/g" /root/assets/.env

RPC_NODE_PRIVATE_KEY_MAINCHAIN=$(node init.js private_key "$MNEMONIC" 3)
sed -i "s/RPC_NODE_PRIVATE_KEY_MAINCHAIN=/RPC_NODE_PRIVATE_KEY_MAINCHAIN=$RPC_NODE_PRIVATE_KEY_MAINCHAIN/g" /root/assets/.env

# Write EV1 and EV2 public addresses to "WORKCHAIN_EVS" variable in .env
# Used when the Workchain Root smart contract is deployed
sed -i "s/WORKCHAIN_EV_2/$EV2_PUBLIC_ADDRESS/g" /root/assets/.env
sed -i "s/WORKCHAIN_EV_1/$EV1_PUBLIC_ADDRESS/g" /root/assets/.env

# Set the Workchain's CHain ID in .env
sed -i "s/WORKCHAIN_NETWORK_ID=/WORKCHAIN_NETWORK_ID=$CHAIN_ID/g" /root/assets/.env

# Psuedo generate the genesis.json
cp /root/assets/genesis_template.json /root/assets/weatherchain_genesis.json
sed -i "s/SEALERADDRESSES/${EV1_PUBLIC_ADDRESS:2}${EV2_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json

sed -i "s/EV1/${EV1_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json
sed -i "s/EV2/${EV2_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json
sed -i "s/RPC/${RPC_NODE_PUBLIC_ADDRESS:2}/g" /root/assets/weatherchain_genesis.json
sed -i "s/WORKCHAIN_ID/${CHAIN_ID}/g" /root/assets/weatherchain_genesis.json

# Write the genesis.json to .env. Used when deploying the Workchain Root smart contract
while IFS='' read -r line || [[ -n "$line" ]]; do
    sed -i "s/WORKCHAIN_GENESIS=/WORKCHAIN_GENESIS=${line}/g" /root/assets/.env
done < /root/assets/weatherchain_genesis.json

# Fund the generated addresses on Mainchain using the faucet
MAINCHAIN_FAUCET_URL=$(grep 'MAINCHAIN_FAUCET_URL' /root/assets/.env)
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
cp /root/assets/.env /root/workchain-root-contract/.env

# Compile Workchain Root smart contract
MAINCHAIN_NETWORK_ID=$(grep 'MAINCHAIN_NETWORK_ID' /root/assets/.env)
cd /root/workchain-root-contract
truffle compile
truffle migrate --reset
WORKCHAIN_ROOT_CONTRACT_ADDRESS=$(node abi.js addr ${MAINCHAIN_NETWORK_ID##*=})
sed -i "s/WORKCHAIN_ROOT_CONTRACT_ADDRESS=/WORKCHAIN_ROOT_CONTRACT_ADDRESS=${WORKCHAIN_ROOT_CONTRACT_ADDRESS}/g" /root/assets/.env
sed -i "s/WORKCHAIN_ROOT_ABI=/WORKCHAIN_ROOT_ABI=$(node abi.js)/g" /root/assets/.env

echo "======================================="
echo "= ENVIRONMENT INITIALISATION COMPLETE ="
echo "======================================="
echo ""
echo "Weatherchain EV1"
echo "---"
echo "Public address: ${EV1_PUBLIC_ADDRESS}"
echo "Private Key: ${EV1_PRIVATE_KEY}"
echo ""
echo "Weatherchain EV2"
echo "---"
echo "Public address: ${EV2_PUBLIC_ADDRESS}"
echo "Private Key: ${EV2_PRIVATE_KEY}"
echo ""
echo "Weatherchain RPC Node"
echo "--------"
echo "Public address: ${RPC_NODE_PUBLIC_ADDRESS}"
echo "Private Key: ${RPC_NODE_PRIVATE_KEY}"
echo ""
echo "Generated Wallet Mnemonic: ${MNEMONIC}"
echo ""
echo "(Wallets will work on both Mainchain and Weatherchain)"
echo ""
echo "Workchain Network ID: ${CHAIN_ID}"
echo "Workchain Root smart contract address on Mainchain: ${WORKCHAIN_ROOT_CONTRACT_ADDRESS}"
echo ""
echo "now run:"
echo ""
echo "  make build"
echo ""
