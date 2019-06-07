function WRKChainRoot(_wrkchainRootContractAddress,
                       _mainchainWeb3ProviderUrl,
                       _wrkchainWeb3ProviderUrl,
                       _wrkchainRootAbi,
                       _wrkchainNetworkId) {

  this.web3jsMainchain = null;
  this.contractAddress = _wrkchainRootContractAddress;
  this.abi = _wrkchainRootAbi;
  this.wrkchainNetworkId = parseInt(_wrkchainNetworkId);

  let self = this;

  this.web3jsMainchain = new Web3(new Web3.providers.HttpProvider(_mainchainWeb3ProviderUrl));
  this.web3jsWrkchain = new Web3(new Web3.providers.HttpProvider(_wrkchainWeb3ProviderUrl));

  this.wrkchainRootContract = new this.web3jsMainchain.eth.Contract(this.abi, this.contractAddress);
}

WRKChainRoot.prototype.validateBlock = function(_block_num, _callback) {

  let self = this;
  this.getWrkchainBlock(_block_num).then(wrkchain_block => {
    this.runBlockHeaderFromRoot(_block_num).then(wrkchain_root_data => {
      _callback(wrkchain_block, wrkchain_root_data);
      return;
    });
    return;
  });
}

WRKChainRoot.prototype.getWrkchainBlock = async function(_block_num) {
  let wrkchain_block = await this.web3jsWrkchain.eth.getBlock(_block_num);
  return wrkchain_block;
}

WRKChainRoot.prototype.runBlockHeaderFromRoot = async function (_block_num) {
  let wrkchain_root_data = await this.getBlockHeaderFromRoot(_block_num);
  return wrkchain_root_data;
}

WRKChainRoot.prototype.getBlockHeaderFromRoot = function (_block_num) {
  let self = this;
  return new Promise(resolve => {
    self.wrkchainRootContract.getPastEvents('RecordHeader', {
      filter: {_chainId: this.wrkchainNetworkId, _height: _block_num},
      fromBlock: 0,
      toBlock: 'latest'
    }, (error, events) => {
      if(error) {
         console.log("error", error);
      } else {
         let latestEvent = events[0]
         resolve(latestEvent);
      }
    });
  });
}

WRKChainRoot.prototype.getCurrentBlockNumber = async function () {
  let blockNumber = await this.web3js.eth.getBlockNumber();
  return blockNumber;
}
