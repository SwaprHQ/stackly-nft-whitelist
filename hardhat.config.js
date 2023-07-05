require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

const dotenv = require("dotenv");
dotenv.config();

const { PRIVATE_KEY, GNOSIS_NODE_URL, ETHERSCAN_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      forking: {
        url: `${GNOSIS_NODE_URL}`,
      },
      accounts: [{
        privateKey: `0x${PRIVATE_KEY}`,
        balance: "10000000000000000000000"
      }],
    },
    gnosis: {
      url: `${GNOSIS_NODE_URL}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    url: "https://gnosisscan.io",
    apiKey: ETHERSCAN_API_KEY,
  },
};
