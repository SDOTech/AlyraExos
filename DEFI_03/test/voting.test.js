const Voting = artifacts.require("./Voting.sol");
const { assert } = require('chai');
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
  // workflowstatus should be ProposalsRegistrationStarted
  it("...workflowstatus should be ProposalsRegistrationStarted", async () => {
    const VotingInstance = await Voting.deployed();  

    //admin openProposaRegistration
    const trx = await VotingInstance.openProposaRegistration({ from: accounts[0] });    
    const currentStatus = await VotingInstance.getCurrentWorkflowStatus();
    assert.equal(currentStatus, Voting.WorkflowStatus.ProposalsRegistrationStarted, "WorkflowStatus not correct");
  });

  // unregistred user cannot vote
  it("...user[2] cannot do a proposal (not whitelisted by admin)", async () => {
    const VotingInstance = await Voting.deployed();    
    await truffleAssert.reverts( await VotingInstance.makeProposal("Propal Test from accounts[2]", {from: accounts[2]}), "Action not allowed for this address");
  });


  // check if user[1] hasVoted
  it("...user[1].has voted should be true after a proposal", async () => {
    const VotingInstance = await Voting.deployed();    
    
    await VotingInstance.makeProposal("Propal Test from accounts[1]", {from: accounts[1]})
    const user = await VotingInstance.getVoter(accounts[1], { from: accounts[0] });    
    assert.equal(user.hasVoted, true, "accounts[1].hasVoted is false !");
  });
 
});