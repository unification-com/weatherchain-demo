function WeatherServiceContract(_contractAddress, _web3ProviderUrl, _abi) {

    let abi = _abi.replace(/\\(.)/mg, "$1");

    this.web3js = null;
    this.contractAddress = _contractAddress;
    this.abi = JSON.parse(abi);

    let self = this;

    this.web3js = new Web3(new Web3.providers.HttpProvider(_web3ProviderUrl));

    this.weatherServiceContract = new this.web3js.eth.Contract(this.abi, this.contractAddress);

}

WeatherServiceContract.prototype.getWeatherUpdate = function(_callback) {

    let self = this;

    this.getCurrentBlockNumber().then(blockNumber => {
        self.weatherServiceContract.getPastEvents('WeatherUpdate', {
            fromBlock: blockNumber,
            toBlock: 'latest'
        }, (error, events) => { })
        .then((events) => {
            _callback(events);
        });
        return;
    });
}

WeatherServiceContract.prototype.getCurrentBlockNumber = async function () {
    let blockNumber = await this.web3js.eth.getBlockNumber();
    return blockNumber;
}

