pragma solidity ^0.5.0;

contract WorkchainRoot {

    //ID of the workchain, as defined in genesis.json
    //Cannot be modified once written
    uint64 public chain_id;

    //hash of full genesis block
    //Cannot be modified once written
    bytes32 public genesis_hash;

    //Struct to store block header info
    struct BlockHeader {
        uint64 height;
        bytes32 hash;
        bytes32 parent_hash;
        bytes32 receipt_root;
        bytes32 tx_root;
        bytes32 state_root;
        address sealer;
    }

    //RecordHeader event
    event RecordHeader(
        uint64 height,
        bytes32 hash,
        bytes32 parent_hash,
        bytes32 receipt_root,
        bytes32 tx_root,
        bytes32 state_root,
        address sealer
    );

    //Block headers storage. Mapping of block number => block header
    mapping(uint64 => BlockHeader) public block_headers;

    //Current EVs - also used to whitelist addresses that can write to contract
    mapping(address => bool) current_evs;
    address[] current_evs_idx;

    //Modifier to ensure only current EVs can execute a function
    modifier onlyEv() {
        require(current_evs[msg.sender] == true);
        _;
    }

    //Contract constructor. Sets Chain ID, Genesis, and initial EVs
    constructor(
        uint64 _chain_id,
        bytes32 _genesis_hash,
        address[] memory _evs
    )
        public
    {

        require(_chain_id > 0, "ChainID required");
        require(_genesis_hash.length > 0, "Genesis block required");
        require(_evs.length > 0, "Initial EVs required");
        chain_id = _chain_id;
        genesis_hash = _genesis_hash;

        for (uint i=0; i<_evs.length; i++) {
            current_evs[_evs[i]] = true;
        }
        current_evs_idx = _evs;

    }

    //Record a workchain block header
    function recordHeader(
        uint64 _height,
        bytes32 _hash,
        bytes32 _parent_hash,
        bytes32 _receipt_root,
        bytes32 _tx_root,
        bytes32 _state_root,
        address _sealer,
        uint64 _chain_id) public onlyEv {

        require(_hash.length > 0, "Hash required");
        require(_parent_hash.length > 0, "Parent Hash required");
        require(_receipt_root.length > 0, "Receipt root required");
        require(_tx_root.length > 0, "Tx root required");
        require(_state_root.length > 0, "State root required");
        require(_sealer != address(0), "Sealer address required");
        require(current_evs[_sealer] == true, "Sealer is not a current EV");

        require(_chain_id == chain_id, "Chain ID does not match");

        BlockHeader storage bh = block_headers[_height];

        require(bh.height != _height, "Block header already exists");

        block_headers[_height] = BlockHeader(
            _height,
            _hash,
            _parent_hash,
            _receipt_root,
            _tx_root,
            _state_root,
            _sealer
        );

        emit RecordHeader(
            _height,
            _hash,
            _parent_hash,
            _receipt_root,
            _tx_root,
            _state_root,
            _sealer
        );

    }

    //Set the new EVs
    function setEvs(address[] memory _new_evs) public onlyEv {
        require(_new_evs.length > 0, "EVs required");

        for(uint i =0; i < current_evs_idx.length; i++) {
            current_evs[current_evs_idx[i]] = false;
        }

        for (uint i=0; i<_new_evs.length; i++) {
            current_evs[_new_evs[i]] = true;
        }

        delete current_evs_idx;
        current_evs_idx = _new_evs;
    }

    //Get header for block number
    function getHeader(uint64 _height) public view returns (
        bytes32 hash,
        bytes32 parent_hash,
        bytes32 receipt_root,
        bytes32 tx_root,
        bytes32 state_root,
        address sealer) {
        BlockHeader storage bh = block_headers[_height];

        hash = bh.hash;
        parent_hash = bh.parent_hash;
        receipt_root = bh.receipt_root;
        tx_root = bh.tx_root;
        state_root = bh.state_root;
        sealer = bh.sealer;
    }

    //get the Genesis block
    function getGenesis() public view returns (bytes32 genesis_hash_) {
        genesis_hash_ = genesis_hash;
    }

    //get the Chain ID
    function getChainId() public view returns (uint64 chain_id_) {
        chain_id_ = chain_id;
    }

    //return list of current EVs
    function getEvs() public view returns (address[] memory current_evs_idx_) {
        current_evs_idx_ = current_evs_idx;
    }

    //Check if public address is an EV
    function isEv(address _ev) public view returns (bool) {
        if(current_evs[_ev] == true) {
            return true;
        }
        return false;
    }

}
