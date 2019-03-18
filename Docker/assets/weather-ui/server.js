require("dotenv").config();
var express = require('express');
var app = express();

// set the view engine to ejs
app.set('view engine', 'ejs');

app.use('/',express.static(__dirname + '/public'));

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
        WRKCHAIN_ROOT_CONTRACT_ADDRESS: process.env.WRKCHAIN_ROOT_CONTRACT_ADDRESS,
        WRKCHAIN_ROOT_ABI: process.env.WRKCHAIN_ROOT_ABI,
        BLOCK_NUM: req.query.block
    });
});

// record header watcher page
app.get('/watch', function(req, res) {
    res.render('pages/event_watcher',{
        MAINCHAIN_WEB3_PROVIDER_URL: process.env.MAINCHAIN_WEB3_PROVIDER_URL,
        WRKCHAIN_ROOT_ABI: process.env.WRKCHAIN_ROOT_ABI,
        WRKCHAIN_ROOT_CONTRACT_ADDRESS: process.env.WRKCHAIN_ROOT_CONTRACT_ADDRESS,
        MAINCHAIN_EXPLORER_URL: process.env.MAINCHAIN_EXPLORER_URL,
        WRKCHAIN_ROOT_WRITE_TIMEOUT: process.env.WRKCHAIN_ROOT_WRITE_TIMEOUT
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