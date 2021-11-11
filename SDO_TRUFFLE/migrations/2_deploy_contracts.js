var hworld = artifacts.require("./HelloWorld.sol");

module.exports = function(deployer) {
  deployer.deploy(hworld);
};
