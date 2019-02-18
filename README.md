# Weatherchain

Weatherchain is a demo Workchain which runs independently in its own network. It's a simple chain
that has a single smart contract deployed which stores weather data. The data is acquired from
[SOME WEATHER API], via an Oracle, which periodically reads the API and writes the data to the
smart contract.

Weatherchain is rooted on Mainchain with its own WorkchainRoot smart contract, and also runs its own 
Workchain Oracle, which periodically reads Wetherchain's block headers, and writes the hashes/merkle roots
to its WorkchainRoot smart contract on Mainchain.

## Running Weatherchain

Ensure Mainchain is running:

1) `cd ../mainchain`
2) `make build-custom`
3) `make run-custom`

Once Mainchain is up and running, from this directory run:

1) `make build`
2) `make run`

Weatherchain's blocks can be viewed via http://10.0.1.6:8081

The Workchain Oracle's logs can be monitored:

1) `docker exec -it weatherchain_oracle /bin/bash`
2) `tail -f log.txt`

<<<<<<< Updated upstream
=======
### Bringing it down

First, bring down the Weatherchain composition, which has a network dependency:

`make down`

Then, from the Mainchain directory, bring down the mainchain composition:

`make down-custom`

>>>>>>> Stashed changes
## Docker containers

`weatherchain_bootnode`: Weatherchain's own bootnode. Listening on port `30304  ` 
`weatherchain_validator_1`: A Weatherhcain validator node. Listening on port `30305`  
`weatherchain_validator_2`: A 2nd Weatherchain validator node. Listening on port `30306`  
`weatherchain_node_1`: Weatherchain's RPC API node, for sending Txs. Runs on http://10.0.1.5:8547  
`weatherchain_explorer`: Weatherchain's own block explorer. Runs on http://10.0.1.6:8081  
`weatherchain_oracle`: Weatherchain's Workchain Oracle. Reads Weatherchain's block headers and sends them to its
WorkchainRoot smart contract on Mainchain. Posts Txs to Mainchain on http://192.168.43.20:8545  
`weatherchain_root_sc`: Runs to deply Weatherchain's WorkchainRoot smart contract on Mainchain

## Account notes

The Weatherhain demo uses the same Mnemonic as Mainchain for accounts - `candy maple cake sugar pudding cream honey rich smooth crumble sweet treat`

The following addresses are used by Weatherchain:

`0x2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e` - runs `weatherchain_validator_1`. Loaded with 1000 UND on Mainchain
and also Weatherchain's own native coin on Weatherchain
`0x2191ef87e392377ec08e7c08eb105ef5448eced5` - runs `weatherchain_validator_2`. Loaded with 1000 UND on Mainchain
and also Weatherchain's own native coin on Weatherchain
<<<<<<< Updated upstream
`0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5` - runs `weatherchain_node_1`. Loaded with 1000 UND on Mainchain
and also Weatherchain's own native coin on Weatherchain
=======
`0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5` - runs `weatherchain_node_1`. Loaded with Weatherchain's own native coin on Weatherchain
>>>>>>> Stashed changes
