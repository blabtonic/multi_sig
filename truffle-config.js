// const HDWalletProvider = require('@truffle/hdwallet-provider');
// const infuraKey = process.env.INFURA_PROVIDER_KEY;

// const fs = require('fs');
// const mnemonic = fs.readFileSync('.secret').toString().trim();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1", // Localhost (default: none)
      port: 7545, // Standard Ethereum port (default: none)
      network_id: "*", // Any network (default: none)
    },
  },

  compilers: {
    solc: {
      version: "0.7.6", // Fetch exact version from solc-bin (default: truffle's version)
    },
  },
};
