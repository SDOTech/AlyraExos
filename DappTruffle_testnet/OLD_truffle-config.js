
module.exports = {

  networks: {
    
    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    ropsten: {
    provider: () => new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/181cb899a09641a8a99fce40aeb9dffd"),
    network_id: 3,       // Ropsten's id
    gas: 5500000,        // Ropsten has a lower block limit than mainnet
    confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
   
  },

 
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.6.11",    // Fetch exact version from solc-bin (default: truffle's version)
      //docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: false,
         runs: 200
       },
       //evmVersion: "byzantium"
      }
    }
  },

  
};
