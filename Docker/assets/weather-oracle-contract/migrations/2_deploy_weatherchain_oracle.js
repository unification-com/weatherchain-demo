const WeatherOracle = artifacts.require("./WeatherOracle.sol");
const Web3 = require('web3-utils');

module.exports = function(deployer) {
    deployer.deploy(WeatherOracle,
    "0f4f2ac550a1b4e2280d04c21cea7ebd822934b5"
    );
};
