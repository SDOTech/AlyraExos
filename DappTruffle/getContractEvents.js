var  Web3  =  require('web3');
web3  =  new  Web3(new  Web3.providers.HttpProvider('https://mainnet.infura.io/v3/181cb899a09641a8a99fce40aeb9dffd'));

var  addr  =  "0xe16f391e860420e65c659111c9e1601c0f8e2818";

console.log('Events by Address: '  +  addr);

var  abi  = [{"constant":true,"inputs":[],"name":"getEbola","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getInfo","outputs":[{"name":"","type":"string"},{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"tipCreator","outputs":[{"name":"","type":"string"},{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"}]

var  contract  =  new  web3.eth.Contract(abi, addr);

console.log('-----------------------------------');
console.log('Matching Smart Contract Events');
console.log('-----------------------------------');

const simpleStorage = new web3.eth.Contract(abi, addr);
simpleStorage.methods.get().call((err, data) => {
  console.log(data);
});

