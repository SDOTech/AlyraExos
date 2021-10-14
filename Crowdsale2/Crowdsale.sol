pragma solidity ^0.8.0;
 

contract Crowdsale {

 
   address public owner; // the owner of the contract
   address public escrow; // wallet to collect raised ETH
   uint256 public savedBalance = 0; // Total amount raised in ETH
   mapping (address => uint256) public balances; // Balances in incoming Ether
 
   // Initialization
   constructor (address _escrow) {
       owner = tx.origin;
       // add address of the specific contract
       escrow = _escrow;
   }
  
   // function to receive ETH
   receive() payable external {
       balances[msg.sender] = balances[msg.sender]+msg.value;
       savedBalance = savedBalance+msg.value;
      
       payable(escrow).transfer(msg.value);
   }
  
   // refund investisor
   function withdrawPayments() public{
       address payee = msg.sender;
       uint256 payment = balances[payee];
 
       //payee.send(payment);
       payable(payee).transfer(payment);
 
       savedBalance = savedBalance-payment;
       balances[payee] = 0;
   }
}