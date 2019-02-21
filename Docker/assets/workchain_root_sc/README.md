# Workchain Root Smart Contract

A simple smart contract to store header hash data from a workchain

## Compiling & Installing

Ensure chain's Docker environment is up and running.

Copy `.env.example` to `.env` and modify as required.

1. `npm install -g truffle`
2. `npm install`
3. `truffle compile`
4. `truffle migrate --reset`

Make a note of the Contract Address output by the `truffle migrate` command.

`truffle-config.js` is currently set to use Geth RPC on http://192.168.43.20:8545. Modify as required.

Also uses the default Accounts in the mnemonic seed "`candy maple cake sugar pudding cream honey rich smooth crumble sweet treat`" to deploy the contract

## Advanced deployment

The `migrations/2_deploy_workchain_root.js` can be modified as per Workchain:

`genesis_block` is the full minified `genesis.json` content  
`chain_id` is the chain ID  
`current_evs` is an array of the initial EVs' public addresses

## Interacting with the Smart Contract

First, we need to get the ABI:

`npm run abi`

Alternatively, open the file `build/contracts/WorkchainRoot.json`, and copy the contents of the `"abi"` object
(including `[]`)

Open up BABEL-MEW (`/haiku-core/babel-mew/dist/index.html`) in a browser,  
navigate to "Contracts", and click on "Interact with Contract"

Enter the Address returned from `truffle migrate`, and the full ABI output from `npm run abi`

### Setting Data

Setting data can only be run using one of the current EV's private keys

**`recordHeader`**

Record a workchain's block header data on MainChain

Data can be obtained from the `mainchain_explorer` Docker, e.g. - http://192.168.43.24:8080/block/24

Inputs:  
`_height`: `uint64` Block number, e.g. 24  
`_hash`: `bytes32` block Hash, e.g. 0x2498f81556eb345238eeed876f5b03bac2c69a09b1965b2fda4584490405ffc4  
`_parent_hash`: `bytes32` Parent Hash  
`_receipt_root`: `bytes32` Receipt merkle root  
`_tx_root`: `bytes32` Transaction merkle root  
`_state_root`: `bytes32` State DB merkle root  
`_sealer`: `address` public address of block sealer  
`_chain_id`: `uint64` Chain ID

**`setEvs`**

Update the reference for the current EVs running the Workchain

Inputs:  
`_new_evs`: `address[]` array containing new EV public addresses, e.g. `["0x627306090abab3a6e1400e9345bc60c78a8bef57", "0xf17f52151ebef6c7334fad080c5704d77216b732"]` - can only be set by a current EV


### Getting Data

The following functions return data from the smart contract:

**`getEvs`**

Retuns an array containing the public addresses of the current EVs maintaining the Workchain

**`getChainId`**

Returns the Chain ID

**`getGenesis`**

Returns the hash of the Workchain's genesis block

**`getHeader`**

Returns the stored header hashes for the given block number

Inputs:  
`_height`: `uint64` block number, e.g. 24

**`isEv`**

Checks if the given public address is currently an EV for the Workchain

Inputs:  
`_ev`: `address` Public address
