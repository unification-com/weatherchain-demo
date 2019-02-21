const fs = require('fs');

const ContractJsonPath = './build/contracts/WorkchainRoot.json'

function main() {
    let args = process.argv.slice(2);
    let contract = JSON.parse(fs.readFileSync(ContractJsonPath, 'utf8'));
    
    switch (args[0]) {
       case 'abi':
       default:
           abi(contract);
           break;
       case 'addr':
           contract_address(contract, args[1]);
           break;
    }
}

function abi(contract) {
    console.log(JSON.stringify(contract.abi));
}

function contract_address(contract, networkId) {
    console.log(contract.networks[networkId].address);
}

main();
