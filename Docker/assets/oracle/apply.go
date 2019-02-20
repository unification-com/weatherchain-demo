package main

import (
	"context"
	"crypto/ecdsa"
	"fmt"
	"log"
	"math/big"

	"github.com/unification-com/mainchain/accounts/abi/bind"
	"github.com/unification-com/mainchain/common"
	"github.com/unification-com/mainchain/crypto"
	"github.com/unification-com/mainchain/ethclient"

	store "./contracts"
)

const upload_key = "4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d"
const genesis_hash = "GENESIS_STRING"

var (
	ChainId     uint64 = 12345
	GenesisHash        = [32]byte{}
)

func main() {

	client, err := ethclient.Dial("http://ganachecli:8545")
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Connection established")

	privateKey, err := crypto.HexToECDSA(upload_key)
	if err != nil {
		log.Fatal(err)
	}

	publicKey := privateKey.Public()
	publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
	if !ok {
		log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
	}

	fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
	nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		log.Fatal(err)
	}

	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	auth := bind.NewKeyedTransactor(privateKey)
	auth.Nonce = big.NewInt(int64(nonce))
	auth.Value = big.NewInt(0)      // in wei
	auth.GasLimit = uint64(5000000) // in units
	auth.GasPrice = gasPrice

	fmt.Printf("The chosen gas price is: %s wei\n", gasPrice)

	evs := make([]common.Address, 0, 1)
	evs = append(evs, common.HexToAddress("0x90f8bf6a479f320ead074411a4b0e7944ea8c9c1"))
	evs = append(evs, common.HexToAddress("0xffcf8fdee72ac11b5c542428b35eef5769c409f0"))

	copy(GenesisHash[:], []byte(genesis_hash))
	address, tx, _, err := store.DeployStore(auth, client, ChainId, GenesisHash, evs)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Contract address: %s\n", address.Hex())
	fmt.Printf("Transaction hash: %s\n", tx.Hash().Hex())

}
