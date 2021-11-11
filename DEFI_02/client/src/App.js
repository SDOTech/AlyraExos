import React, { Component } from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import VotingContract from "./contracts/Voting.json";
import getWeb3 from "./getWeb3";

import Accordion from 'react-bootstrap/Accordion';
import Alert from 'react-bootstrap/Alert';
import Card from 'react-bootstrap/Card';
import Button from 'react-bootstrap/Button';
import Badge from 'react-bootstrap/Badge';

import "./App.css";

class App extends Component {
  state = { web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts (Metamask).
      const accounts = await web3.eth.getAccounts();

      // Get the Voting contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = VotingContract.networks[networkId];
     
      const instance = new web3.eth.Contract(
        VotingContract.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with runInit 
      this.setState({ web3, accounts, contract: instance }, this.runInit);
    } catch (error) {      
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  //Initilazation
  runInit = async() => {
    const { contract } = this.state;

    // Get contract info     
    const contractOwner = await contract.methods.owner().call(); // The owner
    const currentWorkflowStatus = await contract.methods.getCurrentWorkflowStatus().call(); // current workflow status
    const proposals = await contract.methods.getProposals().call(); // proposals 
    const votersAdresses = await contract.methods.getVotersAdresses().call(); // addresses on wihtelist
    const winningProposal = await contract.methods.winningProposal().call(); // the winning proposal

    let contractInformation = {
        contractOwner: contractOwner,
        currentWorkflowStatus: currentWorkflowStatus,
        proposals: proposals,
        votersAdresses: votersAdresses,
        winningProposal: winningProposal,        
    };
    
    this.setState({ contractInformation });
    this.setAccountInformation();
    this.getUIWorkflowStatus();

    //Events management
    window.ethereum.on('accountsChanged', (accounts) => this.handleAccountsChanged(accounts));
    contract.events.WorkflowStatusChange().on('data', (event) => this.handleWorkflowStatusChange(event))
                                          .on('error', (error) => console.error(error));

    // ////////////////////////////////////
    // // enregistrements des événements //
    // ////////////////////////////////////
    // contract.events.VoterAdded().on('data', (event) => this.handleVoterAdded(event))
    //                             .on('error', (error) => console.error('Erreur VoterAdded : ' + Jsonify.stringify(error)));
    // contract.events.WorkflowStatusChange().on('data', (event) => this.handleWorkflowStatusChange(event))
    //                                       .on('error', (error) => console.error('Erreur WorkflowStatusChange : ' + Jsonify.stringify(error)));
    // contract.events.ProposalRegistered().on('data', (event) => this.handleProposalRegistered(event))
    //                                     .on('error', (error) => console.error('Erreur ProposalRegistered : ' + Jsonify.stringify(error)));
    // contract.events.Voted().on('data', (event) => this.handleVoted(event))
    //                        .on('error', (error) => console.error('Erreur ProposalRegistered : ' + Jsonify.stringify(error)));
    
  }

  // Connected account (Need to be call at start and when user change metamast account !)
  setAccountInformation = async() => {
    const { accounts, contract, contractInformation, web3 } = this.state;
    const connectedAccount = accounts[0];

    const voterInformation = await contract.methods.getVoter(connectedAccount).call(); 
    const canVote = voterInformation && voterInformation.isRegistered && !voterInformation.hasVoted;
    const isOwner = connectedAccount === contractInformation.contractOwner ? true : false;
    const isRegistered = voterInformation && voterInformation.isRegistered;
    const hasVoted = voterInformation && voterInformation.hasVoted; 
   
    let accountInformation = {
      account: connectedAccount,
      canVote: canVote,
      hasVoted: hasVoted,
      isOwner: isOwner,
      isRegistered: isRegistered,     
    };
    this.setState({ accountInformation });   
  };


  getUIWorkflowStatus() {
    const { contractInformation } = this.state;

    let UIWorkflowStatus
    switch (contractInformation.currentWorkflowStatus) {
      case '0':
        UIWorkflowStatus = "RegisteringVoters";
        break;
      case '1':
        UIWorkflowStatus = "ProposalsRegistrationStarted";
        break;
      case '2':
        UIWorkflowStatus = "ProposalsRegistrationEnded";
        break;
      case '3':
        UIWorkflowStatus = "VotingSessionStarted";
        break;
      case '4':
        UIWorkflowStatus = "VotingSessionEnded";
        break;
      case '5':
        UIWorkflowStatus = "VotesTallied";
        break;
    }
    this.setState({ UIWorkflowStatus });
  }

  // ========== Handles events ==========
  handleAccountsChanged = async(newAccounts) => {
    const { web3 } = this.state;
    const reloadedAccounts = await web3.eth.getAccounts();   
    this.setState({ accounts: reloadedAccounts });
    this.setAccountInformation();
  }

  handleWorkflowStatusChange = async(event) => {  
    const { contract, contractInformation } = this.state;
    contractInformation.currentWorkflowStatus = event.returnValues.newStatus;    
    this.getUIWorkflowStatus();
  }



// **************************************** Render ****************************************

  render() {
    const { accounts, accountInformation, contractInformation, UIWorkflowStatus } = this.state;

    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }

    // ======== DEFINE ALL DIV SECTIONS ========

    //DIV User connection info 
    let divConnectionInfo = accountInformation ? 
      accountInformation.account + " ": 
      "Veuillez connecter un compte"
    
    //DIV Contract info
    let isOwner = (accountInformation && accountInformation.isOwner)
    let divIsOwner = <span className='badge bg-success'>owner</span>

    //DIV workflowStatus
    let uiStatus = UIWorkflowStatus

    //DIV Admin buttons
    let divAdminButtons = <Card border="primary"><Card.Body>
      <Card.Title>Menu admin</Card.Title>
      <Button variant="primary">Ajouter électeur</Button>{' '}
      <Button variant="primary">Ouvrir la session</Button>{' '}
      <Button variant="primary">Fermer la session</Button>{' '}
      <Button variant="primary">Ouvrir le vote </Button>{' '}
      <Button variant="primary">Fermer le vote</Button>{' '}
      <Button variant="success">Resultat</Button>
    </Card.Body></Card>


     // ======== DISPLAY RENDER ========
    return (
      <div className="App">
        <h1>VOTING DAPP</h1>
        <h2>ALYRA DEFI 02</h2>  
       
       {/* Header*/}
        <Card>
        <Card.Header>Status actuel : {uiStatus}</Card.Header>          
          <Card.Body>
            <Card.Title>{divConnectionInfo}{isOwner? divIsOwner
            :
            ""}</Card.Title>
            <Card.Text>
              {isOwner ? 
              "Vous êtes l'administrateur, vous gérez les votes":
              "Le système de vote est géré par un administrateur"}
            </Card.Text>  
              {isOwner ? divAdminButtons : ""}
          </Card.Body>
        </Card>


        
      </div>
    );
  }
}

export default App;
