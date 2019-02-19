require("dotenv").config();
var express = require('express');
var app = express();

// set the view engine to ejs
app.set('view engine', 'ejs');

app.use('/',express.static(__dirname + '/public'));

// index page
app.get('/', function(req, res) {
    res.render('pages/index',{
        WORKCHAIN_WEB3_PROVIDER_URL: process.env.WORKCHAIN_WEB3_PROVIDER_URL,
        WEATHER_ORACLE_ABI: process.env.WEATHER_ORACLE_ABI,
        WEATHER_ORACLE_CONTRACT_ADDRESS: process.env.WEATHER_ORACLE_CONTRACT_ADDRESS
    });
});

app.listen(4040);
console.log('4040 is the magic port');