const WeatherOracle = artifacts.require("./WeatherOracle.sol");
const Web3 = require('web3-utils');
require("dotenv").config();

let oracles = [
    process.env.WEATHER_ORACLE_ADDRESS
]

module.exports = function(deployer) {
    deployer.deploy(
      WeatherOracle,
      oracles
    );
};
