require("dotenv").config();
var express = require('express');
var app = express();

// set the view engine to ejs
app.set('view engine', 'ejs');

app.use('/',express.static(__dirname + '/public'));

var WRKCHAIN_ROOT_ABI=[{"constant":false,"inputs":[{"name":"_chainId","type":"uint256"},{"name":"_addressesToRemove","type":"address[]"}],"name":"removeAuthAddresses","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_chainId","type":"uint256"},{"name":"_newAuthAddresses","type":"address[]"}],"name":"addAuthAddresses","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_chainId","type":"uint256"},{"name":"_authAddresses","type":"address[]"},{"name":"_genesisHash","type":"bytes32"}],"name":"registerWrkChain","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"_chainId","type":"uint256"}],"name":"getNumBlocksSubmitted","outputs":[{"name":"numBlocksSubmitted_","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"wrkchainList","outputs":[{"name":"lastBlock","type":"uint256"},{"name":"genesisHash","type":"bytes32"},{"name":"isWrkchain","type":"bool"},{"name":"owner","type":"address"},{"name":"numBlocksSubmitted","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_chainId","type":"uint256"},{"name":"_height","type":"uint256"},{"name":"_hash","type":"bytes32"},{"name":"_parentHash","type":"bytes32"},{"name":"_receiptRoot","type":"bytes32"},{"name":"_txRoot","type":"bytes32"},{"name":"_stateRoot","type":"bytes32"},{"name":"_blockSigner","type":"address"}],"name":"recordHeader","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_chainId","type":"uint256"},{"name":"_address","type":"address"}],"name":"isAuthorisedAddress","outputs":[{"name":"_isAuthorised","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_chainId","type":"uint256"}],"name":"getGenesis","outputs":[{"name":"genesisHash_","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_chainId","type":"uint256"},{"name":"_newOwner","type":"address"}],"name":"changeWrkchainOwner","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_chainId","type":"uint256"}],"name":"getLastRecordedBlockNum","outputs":[{"name":"lastBlock_","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_wrkchainRegDeposit","type":"uint256"},{"name":"_minBlocksForDepositReturn","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":true,"name":"_height","type":"uint256"},{"indexed":true,"name":"_hash","type":"bytes32"},{"indexed":false,"name":"_parentHash","type":"bytes32"},{"indexed":false,"name":"_receiptRoot","type":"bytes32"},{"indexed":false,"name":"_txRoot","type":"bytes32"},{"indexed":false,"name":"_stateRoot","type":"bytes32"},{"indexed":false,"name":"_blockSigner","type":"address"}],"name":"RecordHeader","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":false,"name":"_genesisHash","type":"bytes32"}],"name":"RegisterWrkChain","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"LogFallbackFunctionCalled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":true,"name":"_owner","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"WRKChainDepositRefund","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":true,"name":"_authorisedBy","type":"address"},{"indexed":false,"name":"_address","type":"address"}],"name":"AuthoriseNewAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":true,"name":"_removedBy","type":"address"},{"indexed":false,"name":"_address","type":"address"}],"name":"RemoveAuthorisedAddress","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":false,"name":"_old","type":"address"},{"indexed":false,"name":"_new","type":"address"}],"name":"WRKChainOwnerChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_chainId","type":"uint256"},{"indexed":true,"name":"_owner","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"WRKChainDepositPaid","type":"event"}];
var WRKCHAIN_ROOT_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000087";

// index page
app.get('/', function(req, res) {
    res.render('pages/index',{
        WRKCHAIN_WEB3_PROVIDER_URL: process.env.WRKCHAIN_WEB3_PROVIDER_URL,
        WEATHER_ORACLE_ABI: process.env.WEATHER_ORACLE_ABI,
        WEATHER_ORACLE_CONTRACT_ADDRESS: process.env.WEATHER_ORACLE_CONTRACT_ADDRESS,
        WRKCHAIN_EXPLORER_URL: process.env.WRKCHAIN_EXPLORER_URL,
        WEATHER_ORACLE_CONTRACT_ADDRESS: process.env.WEATHER_ORACLE_CONTRACT_ADDRESS,
        WEATHER_SERVICE_TIMEOUT: process.env.WEATHER_SERVICE_TIMEOUT
    });
});

// block validation page
app.get('/validate', function(req, res) {
    res.render('pages/validate',{
        WRKCHAIN_WEB3_PROVIDER_URL: process.env.WRKCHAIN_WEB3_PROVIDER_URL,
        MAINCHAIN_WEB3_PROVIDER_URL: process.env.MAINCHAIN_WEB3_PROVIDER_URL,
        WRKCHAIN_ROOT_CONTRACT_ADDRESS: WRKCHAIN_ROOT_CONTRACT_ADDRESS,
        WRKCHAIN_ROOT_ABI: WRKCHAIN_ROOT_ABI,
        BLOCK_NUM: req.query.block,
        WRKCHAIN_NAME: process.env.WRKCHAIN_NAME,
        WRKCHAIN_NETWORK_ID: process.env.WRKCHAIN_NETWORK_ID
    });
});

// record header watcher page
app.get('/watch', function(req, res) {
    res.render('pages/event_watcher',{
        MAINCHAIN_WEB3_PROVIDER_URL: process.env.MAINCHAIN_WEB3_PROVIDER_URL,
        WRKCHAIN_ROOT_ABI: WRKCHAIN_ROOT_ABI,
        WRKCHAIN_ROOT_CONTRACT_ADDRESS: WRKCHAIN_ROOT_CONTRACT_ADDRESS,
        MAINCHAIN_EXPLORER_URL: process.env.MAINCHAIN_EXPLORER_URL,
        WRKCHAIN_ROOT_WRITE_TIMEOUT: process.env.WRKCHAIN_ROOT_WRITE_TIMEOUT,
        WRKCHAIN_NAME: process.env.WRKCHAIN_NAME,
        WRKCHAIN_NETWORK_ID: process.env.WRKCHAIN_NETWORK_ID
    });
});

app.listen(process.env.WEATHERCHAIN_UI_PORT);
console.log(process.env.WEATHERCHAIN_UI_PORT + ' is the magic port');

console.log( "=====================================");
console.log( "= WEATHER SERVICE UI READY          =");
console.log( "= ------------------------          =");
console.log( "=                                   =");
console.log( "= open:                             =");
console.log( "= http://localhost:" + process.env.WEATHERCHAIN_UI_PORT + "             =");
console.log( "=                                   =");
console.log( "=====================================");