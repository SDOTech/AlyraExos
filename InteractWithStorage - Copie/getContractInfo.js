// npm install web3
// https://youtu.be/h_6cUDYbVDI

var  Web3  =  require('web3');
web3  =  new  Web3(new  Web3.providers.HttpProvider('https://ropsten.infura.io/v3/181cb899a09641a8a99fce40aeb9dffd'));
    
console.log('Contract.....');
    
var  abi  = [
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "x",
          "type": "uint256"
        }
      ],
      "name": "set",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "get",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    }
  ]
var  addr  =  "0x8cD906ff391b25304E0572b92028bE24eC1eABFb";
var  contract  =  new  web3.eth.Contract(abi, addr);
    
// FUNCTION can be "getEbola", "getInfo", "tipCreator" and "kill"
//contract.methods.FUNCTION().call().then(console.log);
contract.methods.get().call().then(console.log);