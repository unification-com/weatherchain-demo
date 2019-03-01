# Weatherchain

Weatherchain is a demo Workchain which runs independently in its own network. It's a simple chain
that has a single smart contract deployed which stores weather data. The data is acquired from
openweathermap.org, via an Oracle service, which periodically reads the API and writes the data to the
smart contract.

Weatherchain is rooted on Mainchain with its own WorkchainRoot smart contract, and also runs its own 
Workchain Oracle, which periodically reads Wetherchain's block headers, and writes the hashes/merkle roots
to its WorkchainRoot smart contract on Mainchain.

## Running Weatherchain

By default, Weatherchain is configured to run on the Unitication's Testnet, which is
currently running on AWS. Simply run:

1. `make init`
2. `make build`
3. `make run`

to bring up the environment.

During the `make init` target, you will be prompted to customise your environment. This can be 
done by editing the generated `./Docker/assets/build/.env` file.

## Viewing Weatherchain info

You'll need to wait a minute or so for the environment to start running, and for the Weatherchain UI
to start up. The console should output a banner notifying that the system is ready:

```

=====================================
= WEATHER SERVICE UI READY          =
= ------------------------          =
=                                   =
= open:                             =
= http://localhost:4040             =
=                                   =
=====================================
```

### Block explorer
Weatherchain's blocks can be viewed via http://localhost:8081

### Weatherchain UI
Weatherchain also has a simple UI for watching the Weather Service smart contract,
 and verifying blocks with the Mainchain: http://localhost:4040
 
http://localhost:4040/ - this is just a simple interface to display Weather data that is being sent
to the Weather smart contract on Weatherchain  
http://localhost:4040/watch - Watches the Workchain Root smart contract on Mainchain for 
Weatherchain's latest block hash deposits  
http://localhost:4040/validate - Validate one of Weatherchain's blocks against the hashes
stored in its Workchain Root smart contract on Mainchain. Simply enter the block number
to get the validation output

#### Notes

**Please note:** you'll need to bring the system down using `make down` before attempting to run
it again. This will mean re-running the `make init` and `make build` scripts.

### Bringing it all down

Bing down the Weatherchain composition by running:

`make down`

## Docker containers

`weatherchain_bootnode`: Weatherchain's own bootnode. Listening on port `30304  `  
`weatherchain_validator_1`: A Weatherhcain validator node. Listening on port `30305`  
`weatherchain_validator_2`: A 2nd Weatherchain validator node. Listening on port `30306`  
`weatherchain_node_1`: Weatherchain's RPC API node, for sending Txs. Runs on http://localhost:8547  
`weatherchain_explorer`: Weatherchain's own block explorer. Runs on http:/localhost:8081  
`weatherchain_oracle`: Weatherchain's Workchain Oracle. Reads Weatherchain's block headers and sends them to its
WorkchainRoot smart contract on Mainchain. Posts Txs to Mainchain via http://52.14.173.249:8101  
`weather_service`: Deploys a simple smart contract to store weather data on Weatherchain. Runs a simple
oracle service to read weather from api.openweathermap.org, and write it to the smart contract.  
`init_weatherchain_environment`: Initialises the Weatherchain's environment.
Only run during the `make init` target.

## Init: further notes

`make init` will initialise a unique environment for the Weatherchain demo each time it is run. 
It will generate the necessary genesis block, chain ID, and wallets required to run the demo. 
It generates new wallets, chain ID and re-deploys a new Workchain Root to prevent any potential 
clashes with an existing demo system. 

Initialisation calls the Mainchain Testnet Faucet to fund the Workchain's addresses with UND
so that the workchain can deposit hashes to its Workchain Root smart contract.

## Account notes

The Weatherhain demo generates accounts, and smart contract addresses during the `make init` target.

## Thanks

`Docker/assets/weather-oracle-contract` derived from https://github.com/decentorganization/weather-oracle-contract  
`Docker/assets/weather-oracle-service` derived from https://github.com/decentorganization/weather-oracle-service