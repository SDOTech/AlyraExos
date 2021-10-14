pragma solidity 0.6.11;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Crowdsale {
  using SafeMath for uint256;
  
  address public owner; // the owner of the contract
  address payable public escrow; // wallet to collect raised ETH
  uint256 public savedBalance = 0; // Total amount raised in ETH
  mapping (address => uint256) public balances; // Balances in incoming Ether
  
  // Event to record each time Ether is paid out
  event PayEther(
  address indexed _receiver,
  uint256 indexed _value,
  uint256 indexed _timestamp
  );
  
  // Initialization
  constructor (address payable _escrow) public{
      owner = msg.sender;
      // add address of the specific contract
      escrow = _escrow;
  }
  
   // function to receive ETH
  receive() payable external {
      balances[msg.sender] = balances[msg.sender].add(msg.value);
      savedBalance = savedBalance.add(msg.value);
      escrow.transfer(msg.value);
      emit PayEther(escrow, msg.value, now);
  }
  
   // refund investisor
  function withdrawPayments() public{
      address payable payee = msg.sender;
      uint256 payment = balances[payee];
      
      require(payment != 0);
      require(address(this).balance >= payment);
    
      savedBalance = savedBalance.sub(payment);
      balances[payee] = 0;
    
      payee.transfer(payment);
      emit PayEther(payee, payment, now);
  }
}

/*


Revoir la logique du remboursement et l’aligner avec le processus de la collecte des fonds. Il est fortement conseillé d’utiliser le pattern PullPayment.
Explication : Actuellement, un investisseur ne peut pas être sur de pouvoir récupérer ses fonds envoyés. En effet, lors de l’envoi des ethers vers le Crowdsale par un investisseur le smart contract effectue immédiatement un transfert du montant reçu vers l’escrow wallet.
Imaginons le scénario suivant: - Un investisseur envoie 2 ETH au Crowdsale. - Après 2h, l’investisseur n’est plus emballé et préfère récupérer ses 2 ETH. - L’investisseur fait alors appelle à la fonction withdrawPayments, sauf que cette dernière va lever une exception et les fonds ne seront pas récupérés.
Pourquoi ? Car, notre contrat à 0 ETH et donc il ne peut pas effectuer le remboursement.
Solution ? - Laisser les ETHs sur le Crowdsale (pas recommandé et il y a un risque d’attaques). Effectuer un transfert des fonds collectés de l’adresse du wallet escrow vers le smart contract Crowdsale. - Déterminer une période de remboursement, avant de déclencher cette période il faut penser à effectuer un transfert des fonds collectés de l’adresse du wallet escrow vers le smart contract Crowdsale.




*/