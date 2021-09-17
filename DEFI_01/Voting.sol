pragma solidity ^0.8.0;

//External libs
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// *******************************************
// ********** Smart contract Voting **********
// **********        DEFI 01        **********
// *******************************************
contract Voting is Ownable{
    
// ********** Events **********
event VoterRegistered(address voterAddress);
event ProposalsRegistrationStarted();
event ProposalsRegistrationEnded();
event ProposalRegistered(uint proposalId);
event VotingSessionStarted();
event VotingSessionEnded();
event Voted (address voter, uint proposalId);
event VotesTallied();
event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);

// ====== Enumerations ======
enum WorkflowStatus {
    RegisteringVoters,
    ProposalsRegistrationStarted,
    ProposalsRegistrationEnded,
    VotingSessionStarted,
    VotingSessionEnded,
    VotesTallied
}

// // ======  Entities  ====== 
struct Voter {
    bool isRegistered;
    bool hasVoted;
    uint votedProposalId;
    address voterId;
}

struct Proposal {
    uint idProposal;
    string description;
    uint voteCount;
    bool isWinner;
}

// ====== variables ====== 
mapping (address => bool) private _whitelist; //only users in whitelist can propose and vote
bool private _isProposalSessionOpen = false; //define state of proposal session (true : users can wite their proposal, else not !)
bool private _isVoteOpen = false; //if true, allowed users can vote for proposals
uint proposalId = 0;
uint winningProposalId = 0; //0 mean no proposal is defined (proposalId start at 1) - *** NOTE DE RELECTURE : ce champ ne peut pas gérer des égalités de vote !
uint maxcountForProposalId = 0;
Proposal[] public proposals;
Voter[] public voters;

// ************************************************************ Functions ************************************************************ 

// Admin only can add users in whitelist
function whitelist(address _address) public onlyOwner {
    require(!_whitelist[_address], "This address is already whitelisted !");
    _whitelist[_address] = true;
    
    //fire event
    emit VoterRegistered(_address);
}

// Admin only can open proposal session
function openProposaRegistration() public onlyOwner {
    _isProposalSessionOpen = true;
    
    //Clean up the new Proposal session
    delete proposals; //clean proposals to start the new proposal registration
    proposalId = 0; //need to reset prosalId
    winningProposalId = 0;
    delete voters; //clean voters from old vote session
    maxcountForProposalId = 0;
    
    //fire Events
    emit ProposalsRegistrationStarted(); 
    emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.ProposalsRegistrationStarted);
}

// Admin only can close proposal session
function closeProposalRegistration() public onlyOwner{
    
    _isProposalSessionOpen = false;
    
    //fire Events
    emit ProposalsRegistrationEnded(); 
    emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
}

// Admin only can open a vote session
function openVoteSession() public onlyOwner{
    
    require(proposals.length>1,"2 proposals min. needed !"); //need 2 proposals at least
    require(!_isProposalSessionOpen);//proposal session need to be closed
    
    _isVoteOpen = true;
    
    //fire Events
    emit VotingSessionStarted();
    emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotingSessionStarted);
}

// Admin only can close a vote session
function closeVoteSession() public onlyOwner {
    
    _isVoteOpen = false;
    
    //fire Events
    emit VotingSessionEnded();
    emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
}

// User make a proposal
// - description : string to set the proposal libelle
function makeProposal(string memory description) public {
    
    require(_isProposalSessionOpen==true, "Proposal Session not opened"); //check if session is open by admin to make a proposal
    require(_whitelist[msg.sender],"Action not allowed for this address"); //check if caller is allowed in whitelist 
    
    proposalId++;//define the newId of the proposal
    Proposal memory prop = Proposal(proposalId, description, 0, false);
    proposals.push(prop);
    
    emit ProposalRegistered(proposalId);
}


// -------------------------- TEMP
// Elector list all current proposals
function getCurrentProposals() public view returns (Proposal[] memory){
    
    require(_whitelist[msg.sender],"Action not allowed for this address"); //check if caller is allowed in whitelist to make a proposal
    
    return proposals;
}
//Get Voters list 
function getVoters() public view returns (Voter[] memory){
    return voters;
}
// --------------------------


//Elector Vote for a selected proposal
function voteForProposal(uint _proposalId) public {
    
    require(_whitelist[msg.sender],"Action not allowed for this address"); //check if caller is allowed in whitelist 
    require(!_isProposalSessionOpen);//proposal session need to be closed
    require(_isVoteOpen,"Vote session is not Open");
    
   
    //check if user has already vote for this session
    // NOTE pour relecture : je n'ai pas trouvé de foreach sur une collection typée en solidity (genre linQ et expression lambda en C#. Cela existe ? )
    bool isVoteAllowed = true;
    for(uint i = 0; i<voters.length; i++){
        if(voters[i].voterId == msg.sender && voters[i].hasVoted){
            isVoteAllowed = false;
        }
    }
    require(isVoteAllowed, "You have already Vote in this Session !");
   
    //check if _proposalId exists (we know that proposalId start from 0 and each proposal increment +1)
    require(_proposalId<=proposalId,"proposalId not found !");
    
    
    Voter memory voter = Voter(true,true,_proposalId,msg.sender);
    voters.push(voter);
    
    //increment voteCount with this new Vote
    for(uint cptPr=0;cptPr<proposals.length;cptPr++){
        if(proposals[cptPr].idProposal==_proposalId)
        {
            proposals[cptPr].voteCount++;
            //if this new count is best than other it is temporally the Winner
            if(proposals[cptPr].voteCount>maxcountForProposalId)
            {
                maxcountForProposalId = proposals[cptPr].voteCount;
                winningProposalId = proposals[cptPr].idProposal; // NOTE RELECTURE : winningProposalId ne permet pas la gestion d'egalité dans les votes
            }
        }
    }
    
    //fire events
    emit Voted(msg.sender, _proposalId);
}

//Get Vote result : affect
function getVoteResults() public onlyOwner returns (Proposal[] memory) {
    
    require(!_isVoteOpen,"Voting Session need to be closed !");
    
    emit VotesTallied();
    
    return proposals;
}






}// end of smart contract