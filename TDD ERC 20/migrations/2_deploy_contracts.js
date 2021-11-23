// Import du smart contract "SimpleStorage"
const ERC20Token = artifacts.require("ERC20Token");
module.exports = (deployer) => {
 // Deployer le smart contract!
 deployer.deploy(ERC20Token,1000);
}