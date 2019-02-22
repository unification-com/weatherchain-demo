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
2) `make build`
3) `make run`

Once Mainchain is up and running, from this directory run:

1) `make init`
2) `make build`
3) `make run`

**Please note:** you'll need to bring the system down using `make down` before attempting to run
it again. This will mean re-running the `init` and `build` scripts.

## Viewing Weatherchain info

You'll need to wait a minute or so for the environment to start running, and for the Weatherchain UI
to start up.

### Block explorer
Weatherchain's blocks can be viewed via http://172.25.0.6:8081

### Weatherchain UI
Weatherchain also has a simple UI for watching the Weather Service smart contract,
 and verifying blocks with the Mainchain: http://172.25.0.7:4040/
 
http://172.25.0.7:4040/ - this is just a simple interface to display WEather data that is being sent
to the Weather smart contract on Weatherchain  
http://172.25.0.7:4040/watch - Watches the Workchain Root smart contract on Mainchain for 
Weatherchain's block hash deposits  
http://172.25.0.7:4040/validate - Validate one of Weatherchain's blocks against the hashes
stored in its Workchain Root smart contract on Mainchain

### Bringing it down

First, bring down the Weatherchain composition, which has a network dependency:

`make down`

Then, from the Mainchain directory, bring down the mainchain composition:

`make down`

## Docker containers

`weatherchain_bootnode`: Weatherchain's own bootnode. Listening on port `30304  ` 
`weatherchain_validator_1`: A Weatherhcain validator node. Listening on port `30305`  
`weatherchain_validator_2`: A 2nd Weatherchain validator node. Listening on port `30306`  
`weatherchain_node_1`: Weatherchain's RPC API node, for sending Txs. Runs on http://172.25.0.5:8547  
`weatherchain_explorer`: Weatherchain's own block explorer. Runs on http://172.25.0.6:8081  
`weatherchain_oracle`: Weatherchain's Workchain Oracle. Reads Weatherchain's block headers and sends them to its
WorkchainRoot smart contract on Mainchain. Posts Txs to Mainchain on http://192.168.43.20:8545  
`weather_service`: Deploys a simple smart contract to store weather data on Weatherchain. Runs a simple
oracle service to read weather from api.openweathermap.org, and write it to the smart contract.
`init_weatherchain_environment`: Initialises the Workchains environment. Only run during `make init`

## Init notes

`make init` will initialise a unique environment for the Weatherchain demo. It will generate the
necessary genesis block, chain ID, and wallets required to run the demo.

Initialisation calls the Mainchain Faucet to fund the Workchain's addresses with UND
so that the workchain can deposit hashes to its Workchain Root smart contract.

The faucet can be monitored in:

`docker exec -it faucet /bin/bash`

and within the container, running:

`tail -f faucet_log.txt`

## Account notes

The Weatherhain demo generates accounts, and smart contract addresses during the `make init` target.
The Mnemonic, and associated addresses and keys can be viewed in `Docker/assets/.env`