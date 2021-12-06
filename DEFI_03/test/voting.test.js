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
    await truffleAssert.reverts(VotingInstance.registeringUsers(accounts[1], { from: accounts[0] }));
  });

  // Check workflow status after admin open Proposal Registration
  it("...workflowstatus should be ProposalsRegistrationStarted", async () => {
    const VotingInstance = await Voting.deployed();  
    
    const trx = await VotingInstance.openProposaRegistration({ from: accounts[0] });    
    const currentStatus = await VotingInstance.getCurrentWorkflowStatus();
    assert.equal(currentStatus, Voting.WorkflowStatus.ProposalsRegistrationStarted, "WorkflowStatus not correct");
  });

   // unregistred user cannot do a proposal
   it("...user[2] cannot do a proposal (not whitelisted by admin) - should fail", async () => {
     const VotingInstance = await Voting.deployed();    
     truffleAssert.reverts(VotingInstance.makeProposal("Propal Test from accounts[2]", {from: accounts[2]}));
   });

  
  //check event after proposal done
  it("...event ProposalRegistered should be emited", async () => {
    const VotingInstance = await Voting.deployed();
    const tx = await VotingInstance.makeProposal("Propal Test from accounts[1]", { from: accounts[1] });

    truffleAssert.eventEmitted(tx, 'ProposalRegistered');
  });

  //user allowed make a proposal
   it("...proposal should be recorded", async () => {
    const VotingInstance = await Voting.deployed();    
    
     //get proposal count 
     let propBefore = await VotingInstance.getProposals({ from: accounts[1] });
     let countBefore = parseInt(propBefore.length);
     countBefore  = null ?? 0
     
     const tx = await VotingInstance.makeProposal("Propal Test from accounts[1]", { from: accounts[1] });
     
     let propAfter = await VotingInstance.getProposals({ from: accounts[1] })
     let countAfter = parseInt(propAfter.length);
     const isGreater = countAfter > countBefore;    
     assert.equal(isGreater, true, "proposal not recorded:" + countBefore + " - " + countAfter);
     
  });
 



 
});