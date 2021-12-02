const Voting = artifacts.require("./Voting.sol");
const { expect } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("Voting", accounts => {

  it("...should Register accounts[1] From account[0]", async () => {    
    const VotingInstance = await Voting.deployed();

    // Register accounts[1] From account[0]
    await VotingInstance.registeringUsers(accounts[1], { from: accounts[0] });
    const registeredUser = await VotingInstance.getVoter(accounts[1], { from: accounts[0] });
    assert.equal(registeredUser.isRegistered, true, "accounts[1] was not registered.");    
  });

  it("...should NOT register twice accounts[1] from account[0]", async () => {
    const VotingInstance = await Voting.deployed();

  // try to register account[1] twice
    await truffleAssert.reverts(VotingInstance.registeringUsers(accounts[1], { from: accounts[0] }), "Existing Address !");
  });



 
});