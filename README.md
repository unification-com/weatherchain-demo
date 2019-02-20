# Weatherchain

Weatherchain is a demo Workchain which runs independently in its own network. It's a simple chain
that has a single smart contract deployed which stores weather data. The data is acquired from
openweathermap.org, via an Oracle service, which periodically reads the API and writes the data to the
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

Weatherchain's blocks can be viewed via http://172.25.0.6:8081

Weatherchain also has a simple UI for watching the Weather Service smart contract,
 and verifying blocks with the Mainchain: http://172.25.0.7:4040/

### Bringing it down

First, bring down the Weatherchain composition, which has a network dependency:

`make down`

Then, from the Mainchain directory, bring down the mainchain composition:

`make down-custom`

## Docker containers

`weatherchain_bootnode`: Weatherchain's own bootnode. Listening on port `30304  ` 
`weatherchain_validator_1`: A Weatherhcain validator node. Listening on port `30305`  
`weatherchain_validator_2`: A 2nd Weatherchain validator node. Listening on port `30306`  
`weatherchain_node_1`: Weatherchain's RPC API node, for sending Txs. Runs on http://172.25.0.5:8547  
`weatherchain_explorer`: Weatherchain's own block explorer. Runs on http://172.25.0.6:8081  
`weatherchain_oracle`: Weatherchain's Workchain Oracle. Reads Weatherchain's block headers and sends them to its
WorkchainRoot smart contract on Mainchain. Posts Txs to Mainchain on http://192.168.43.20:8545  
`weatherchain_root_sc`: Runs to deply Weatherchain's WorkchainRoot smart contract on Mainchain
`weather_service`: Deploys a simple smart contract to store weather data on Weatherchain. Runs a simple
oracle service to read weather from api.openweathermap.org, and write it to the smart contract.

## Account notes

The Weatherhain demo uses the same standard Test-RPC Mnemonic as Mainchain for its test accounts - `candy maple cake sugar pudding cream honey rich smooth crumble sweet treat`

The following addresses are used by Weatherchain:

`0x2932b7a2355d6fecc4b5c0b6bd44cc31df247a2e` (address[5]) - runs `weatherchain_validator_1`. Loaded with 1000 UND on Mainchain
and also 1000 RAIN (Weatherchain's own native coin) on Weatherchain
`0x2191ef87e392377ec08e7c08eb105ef5448eced5` (address[6]) - runs `weatherchain_validator_2`. Loaded with 1000 UND on Mainchain
and also 1000 RAIN (Weatherchain's own native coin) on Weatherchain
`0x0f4f2ac550a1b4e2280d04c21cea7ebd822934b5` (address[7]) - runs `weatherchain_node_1`. Loaded with 1000 RAIN (Weatherchain's own native coin) on Weatherchain.
This address is also used by `weather_service` to write weather data to its smart contract.