require("dotenv").config();

import HDWalletProvider from "truffle-hdwallet-provider";
import Web3 from "web3";

const web3 = new Web3(new HDWalletProvider(process.env.PRIVATE_KEY, process.env.WRKCHAIN_WEB3_PROVIDER_URL));
const abi = JSON.parse(process.env.WEATHER_ORACLE_ABI);
const address = process.env.WEATHER_ORACLE_CONTRACT_ADDRESS;
const contract = web3.eth.contract(abi).at(address);

const account = () => {
  return new Promise((resolve, reject) => {
    web3.eth.getAccounts((err, accounts) => {
      if (err === null) {
        resolve(accounts[0]);
      } else {
        reject(err);
      }
    });
  });
};

export const updateWeather = ({ weatherDescription, temperature, humidity, visibility, pressure, sunrise, sunset }) => {
  return new Promise((resolve, reject) => {
    account().then(account => {
      contract.updateWeather(weatherDescription, temperature, humidity, visibility, pressure, sunrise, sunset,
        { from: account }, (err, res) => {
          if (err === null) {
            resolve(res);
          } else {
            reject(err);
          }
        }
      );
    }).catch(error => reject(error));
  });
};

export const weatherUpdate = (callback) => {
  contract.WeatherUpdate((error, result) => callback(error, result));
};
