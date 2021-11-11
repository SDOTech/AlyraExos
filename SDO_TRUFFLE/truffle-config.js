const path = require("path");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      host: "127.0.0.1", // localhost de notre réseau ganache 
      port: 7545, // le port rpc de notre réseau ganache 
      network_id: "5777",// le network id de notre réseau ganache 
    },    
  },

    // Configure your compilers
    compilers: {
      solc: {
        version: "0.8.9",    // Fetch exact version from solc-bin (default: truffle's version)        
        settings: {          // See the solidity docs for advice about optimization and evmVersion
          optimizer: {
          enabled: false,
          runs: 200
          },
        evmVersion: "byzantium"
        }
      },
    }

};
