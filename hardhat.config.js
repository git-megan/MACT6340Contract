require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
// import "@nomicfoundation/hardhat-toolbox";
// import "dotenv/config";

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const POLYGONSCAN_API_KEY = process.env.POLYGONSCAN_API_KEY;
const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;

// change these for different networks
const ALCHEMY_URL = `https://polygon-amoy.g.alchemy.com/v2/${ALCHEMY_API_KEY}`;
//const ALCHEMY_URL = `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`;
//const ALCHEMY_URL = `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`;
//const ALCHEMY_URL = `https://eth-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`;

const STUNT_WALLET_PRIVATE_KEY = process.env.STUNT_WALLET_PRIVATE_KEY;
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY;

module.exports = {
  //export default {
  etherscan: {
    apiKey: {
      mainnet: ETHERSCAN_API_KEY,
      sepolia: ETHERSCAN_API_KEY,
      polygon: POLYGONSCAN_API_KEY,
      polygonAmoy: POLYGONSCAN_API_KEY,
    },
  },
  gasReporter: {
    enabled: false,
    currency: "USD",
    coinmarketcap: COINMARKETCAP_API_KEY,
    token: "MATIC", // POL on polygonAmoy
    outputFile: "gas-report.txt",
    noColors: true,
  },
  defaultNetwork: "hardhat", //"polygonAmoy", // hardhat for testing, change this for different networks
  networks: {
    hardhat: {
      chainId: 31337,
      gas: 30000000,
      blockGasLimit: 30000000, // add this line
    },
    // Polygon Amoy replaces Mumbai
    //polygonMumbai: {
    //   url: ALCHEMY_URL,
    //   accounts: [STUNT_WALLET_PRIVATE_KEY],
    //   gasPrice: 35000000000,
    //   chainId: 80001,
    // },
    polygonAmoy: {
      url: ALCHEMY_URL,
      accounts: [STUNT_WALLET_PRIVATE_KEY],
      gasPrice: 35000000000,
      chainId: 80002,
    },
    polygon: {
      url: ALCHEMY_URL,
      accounts: [STUNT_WALLET_PRIVATE_KEY],
      gasPrice: 35000000000,
      chainId: 137,
    },
    sepolia: {
      url: ALCHEMY_URL,
      accounts: [STUNT_WALLET_PRIVATE_KEY],
      gasPrice: 35000000000,
      chainId: 11155111,
    },
    ethereum: {
      url: ALCHEMY_URL,
      accounts: [STUNT_WALLET_PRIVATE_KEY],
      gasPrice: 35000000000,
      chainId: 1,
    },
  },
  solidity: {
    version: "0.8.27", // use an exact version here and in contract to avoid verification problems
    settings: {
      optimizer: {
        enabled: false, // may cause verification problems if true
      },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
