pragma solidity ^0.8.0;

//External libs
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// *******************************************
// ********** Smart contract Voting **********
// **********        DEFI 01        **********
// *******************************************
contract Voting is Ownable{

// ======  Entities  ====== 
struct Voter {
    bool isRegistered;
    bool hasVoted;
    uint votedProposalId;
}

struct Proposal {
    string description;
    uint voteCount;
    //bool isWinner;
}    

// ====== Enumerations ======
enum WorkflowStatus {
    RegisteringVoters,
    ProposalsRegistrationStarted,
    ProposalsRegistrationEnded,
    VotingSessionStarted,
    VotingSessionEnded,
    VotesTallied
}

// ====== variables ====== 
mapping (address => Voter) private _voters; //only users in whitelist can propose and vote
uint winningProposalId;
Proposal[] public proposals;
//Voter[] public voters;
WorkflowStatus _workflowStatus;

// ====== Events ====== 
event VoterRegistered(address voterAddress);
event ProposalsRegistrationStarted();
event ProposalsRegistrationEnded();
event ProposalRegistered(uint proposalId);
event VotingSessionStarted();
event VotingSessionEnded();
event Voted (address voter, uint proposalId);
event VotesTallied();
event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);



// ************************************************************ Functions ************************************************************ 

// Admin only can add users in whitelist
function registeringUsers(address _address) public onlyOwner {
    
    require(!_voters[_address].isRegistered,"Existing Address !");
    
    require (_workflowStatus != WorkflowStatus.ProposalsRegistrationStarted 
                && _workflowStatus != WorkflowStatus.ProposalsRegistrationEnded
                && _workflowStatus != WorkflowStatus.VotingSessionStarted
                && _workflowStatus != WorkflowStatus.VotingSessionEnded
                );
    
    _workflowStatus = WorkflowStatus.RegisteringVoters;
    
    Voter memory voter = Voter(true,false,0);
    _voters[_address] = voter;
    
    //fire event
    emit VoterRegistered(_address);
}


// function openProposaRegistration allow admin to open the Proposal registration
// Admin only can open proposal session
// Warning : openProposaRegistration remove proposals and voters !
function openProposaRegistration() public onlyOwner {
    
    _workflowStatus = WorkflowStatus.ProposalsRegistrationStarted; //open registration
    
    //Clean up the new Proposal session
    delete proposals; //clean proposals to start the new proposal registration

    //fire Events
    emit ProposalsRegistrationStarted(); 
    emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.ProposalsRegistrationStarted);
}

// function closeProposalRegistration allow admin to close the Proposal registration
// Admin only can close proposal session
function closeProposalRegistration() public onlyOwner{
    
    require(_workflowStatus == WorkflowStatus.ProposalsRegistrationStarted,"Session need to be opened !");
    require(proposals.length>0,"Cannot close Session without proposal !");
   
   _workflowStatus = WorkflowStatus.ProposalsRegistrationEnded; //close registration
    
    //fire Events
    emit ProposalsRegistrationEnded(); 
    emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
}

// User make a proposal
// - description : string to set the proposal libelle
function makeProposal(string memory description) public {
    
    require(_workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Proposal Session not opened"); //check if session is open by admin to make a proposal
    require(_voters[msg.sender].isRegistered,"Action not allowed for this address"); //check if caller is allowed in whitelist 
   
    Proposal memory prop = Proposal(description, 0);
    proposals.push(prop);
    
    emit ProposalRegistered(proposals.length);
}


// Admin only can open a vote session
function openVoteSession() public onlyOwner{
 
    //require(_workflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Proposal Session need to be closed");
    
    _workflowStatus = WorkflowStatus.VotingSessionStarted;
    
    //fire Events
    emit VotingSessionStarted();
    emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
}


// Admin only can close a vote session
function closeVoteSession() public onlyOwner {
    
    require(_workflowStatus == WorkflowStatus.VotingSessionStarted, "Voting Session not started");
    
     _workflowStatus = WorkflowStatus.VotingSessionEnded;
    
    //fire Events
    emit VotingSessionEnded();
    emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
}


//Elector Vote for a selected proposal
function voteForProposal(uint _proposalId) public {
    
    require(_voters[msg.sender].isRegistered,"Action not allowed for this address"); //check if caller is allowed in whitelist 
    require(_workflowStatus == WorkflowStatus.VotingSessionStarted, "Voting Session not started");
    require(!_voters[msg.sender].hasVoted,"Vote alredy done"); //check if user has already vote for this session
    require(_proposalId<=proposals.length,"Proposal not found"); //check if _proposalId exists
    
    //Proposal receive a vote
    proposals[_proposalId].voteCount++;
    
    //Voter has now vote and cannot vote again
    _voters[msg.sender].hasVoted = true;
    
     //fire events
    emit Voted(msg.sender, _proposalId);
}



//Compute result after voting
function processVoteResults() public onlyOwner  {
    
    require(_workflowStatus == WorkflowStatus.VotingSessionEnded, "Voting Session not ended !");
    
    _workflowStatus = WorkflowStatus.VotesTallied;
    
    //loop on proposals
    uint maxVotecount = 0;
    for(uint cptPr=0;cptPr<proposals.length;cptPr++){
        if(proposals[cptPr].voteCount>maxVotecount){
            maxVotecount = proposals[cptPr].voteCount;
            winningProposalId = cptPr;
        }
    }
    
     //fire events
    emit VotesTallied();
    emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
}


// Get the Winning proposal
// Vote session need to be closed
function getWinningProposal() public view returns (Proposal memory){
    require(_workflowStatus == WorkflowStatus.VotesTallied,"Vote need to be Tallied");
    
    return proposals[winningProposalId];
}




}// end of smart contract