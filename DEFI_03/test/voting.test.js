const Voting = artifacts.require("./Voting.sol");
const { expect, assert } = require('chai');
const truffleAssert = require('truffle-assertions');

contract("Voting", accounts => {

  // Should Register accounts[1] From account[0]
  it("...should Register accounts[1] From account[0]", async () => {    
    const VotingInstance = await Voting.deployed();
    
    await VotingInstance.registeringUsers(accounts[1], { from: accounts[0] });
    const registeredUser = await VotingInstance.getVoter(accounts[1], { from: accounts[0] });
    assert.equal(registeredUser.isRegistered, true, "accounts[1] was not registered.");    
  });

  // Should NOT register twice accounts[1] from account[0]
  it("...should NOT register twice accounts[1] from account[0]", async () => {
    const VotingInstance = await Voting.deployed();  
    await truffleAssert.reverts(VotingInstance.registeringUsers(accounts[1], { from: accounts[0] }), "Existing Address !");
  });

  // check workflow status after admin open Proposal Registration
  // workflowstatus shoulb be ProposalsRegistrationStarted
  it("...workflowstatus should be ProposalsRegistrationStarted", async () => {
    const VotingInstance = await Voting.deployed();  

    //admin openProposaRegistration
    const trx = await VotingInstance.openProposaRegistration({ from: accounts[0] });    
    const currentStatus = await VotingInstance.getCurrentWorkflowStatus();
    assert.equal(currentStatus, Voting.WorkflowStatus.ProposalsRegistrationStarted, "WorkflowStatus not correct");

  });


 
});