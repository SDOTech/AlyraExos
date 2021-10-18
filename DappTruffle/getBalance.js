const Web3 = require('web3')
const rpcURL = "https://mainnet.infura.io/v3/0xd804ab1667e940052614a5acd103dde4d298ce36"
const web3 = new Web3(rpcURL)

web3.eth.getBalance("0xb683d83a532e2cb7dfa5275eed3698436371cc9f", (err, wei) => { 
   balance = web3.utils.fromWei(wei, 'ether'); // convertir la valeur en ether
   console.log(balance);
});