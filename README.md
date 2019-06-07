# WeatherChain

WeatherChain is a completely self-contained demo WRKChain which runs 
independently in its own network. It's a simple chain
that has a single smart contract deployed which stores weather data. 
The data is acquired from openweathermap.org, via an Oracle service, which 
periodically reads the API and writes the data to the smart contract.

WeatherChain is rooted on Mainchain with its own WRKChain Root smart contract,
and also runs its own WRKChain Oracle, which periodically reads Wetherchain's
block headers, and writes the hashes/merkle roots to its WRKChain Root 
smart contract on Mainchain.

## Running WeatherChain

Docker and Docker Compose are required to run the WeatherChain demo.

Run the demo using:

```bash
make
```

### Docker network issues

By default, the demo uses the `172.25.1.0/24` subnet. If this subnet 
overlaps with your own, run:

```bash
ifconfig
```

and look for a line for your connection similar to:

```bash
inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
```

Look for the `network` (first 3 parts of the IP address) 
value of `inet addr`. This is your current subnet. In the example above, 
this is `192.168.1`.

Then set the `SUBNET_IP` variable to any other subnet. For example, run: 

```bash
SUBNET_IP=192.168.5 make
```

to run the demo on the `192.168.5.0/24` subnet

## Viewing WeatherChain info

You'll need to wait a minute or so for the environment to start running, and 
for the WeatherChain UI to start up. The console should output a banner 
notifying that the system is ready:

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
WeatherChain's blocks can be viewed via http://localhost:8081

### WeatherChain UI
WeatherChain also has a simple UI for watching the Weather Service smart 
contract, and verifying blocks with the Mainchain: http://localhost:4040
 
http://localhost:4040/ - this is just a simple interface to display 
Weather data that is being sent to the Weather smart contract on WeatherChain  
http://localhost:4040/watch - Watches the WRKChain Root smart contract on 
Mainchain for WeatherChain's latest block hash deposits  
http://localhost:4040/validate - Validate one of WeatherChain's blocks 
against the hashes stored in its WRKChain Root smart contract on Mainchain. 
Simply enter the block number to get the validation output

### Bringing it all down

Bing down the WeatherChain composition by pressing <kbd>CTRL</kbd>+<kbd>C</kbd> then running:

`make down`

## Thanks

`Docker/wrkchain/assets/weather-oracle-contract` derived from https://github.com/decentorganization/weather-oracle-contract  
`Docker/wrkchain/assets/weather-oracle-service` derived from https://github.com/decentorganization/weather-oracle-service