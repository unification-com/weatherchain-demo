const WeatherOracle = artifacts.require("./WeatherOracle.sol");
const Web3 = require('web3-utils');
require("dotenv").config();

let oracles = [
    process.env.EV1_PUBLIC_ADDRESS,
    process.env.EV2_PUBLIC_ADDRESS,
    process.env.RPC_NODE_PUBLIC_ADDRESS
]

module.exports = function(deployer) {
    deployer.deploy(
      WeatherOracle,
      oracles
    );
};
