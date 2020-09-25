module.exports = {
  /*networks: {
    development: {
      host: "127.0.0.1", 
      port: 8545,
      network_id: "*",
    }
  },*/
  mocha: {
    timeout: 100000
  },
  compilers: {
    solc: {
      version: "0.5.14",    // Fetch exact version from solc-bin (default: truffle's version)
      docker: false,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 600
        },
        evmVersion: "byzantium"
      }
    }
  }
}
