require("dotenv").config();

const WorkchainRoot = artifacts.require("./WorkchainRoot.sol");
const Web3 = require('web3-utils');

let genesis_block = process.env.WORKCHAIN_GENESIS
let chain_id = process.env.WORKCHAIN_NETWORK_ID
let current_evs = process.env.WORKCHAIN_EVS;

let evs_str = current_evs.replace(/\\(.)/mg, "$1");
let evs = JSON.parse(evs_str);

let genesis_sha = Web3.sha3(genesis_block);

module.exports = function(deployer) {
    deployer.deploy(WorkchainRoot,
    chain_id,
    genesis_sha,
    evs
    );
};
