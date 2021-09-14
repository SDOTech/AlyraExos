pragma solidity 0.8.0;


//Imports
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Bank {
    
    //Use SafeMath librairie
    using SafeMath for uint256;
    
    // mapping “_balances” : account => total deposit
    mapping(address=>uint) _balances;
    
    //Do a deposit
    function deposit(uint _amount) public{
        
        require(_amount>0,"amout have to be greater than 0");
        
        //_balances[msg.sender]+=_amount;//without SafeMath
        _balances[msg.sender] = _balances[msg.sender].add(_amount); //with SafeMath
    }
    
    //transfer amount to a given adress
    function transfer(address _recipient, uint _amount) public{
        
        //check if sender has enough to transfer to given address
        require(_balances[msg.sender]>=_amount,"Not enough amount to process the transfer !"); 
        
        //without SafeMath
        /*
        _balances[msg.sender] -= _amount;
        _balances[_recipient] += _amount;
        */
        
        //with SafeMath
        _balances[msg.sender] = _balances[msg.sender].sub(_amount);
        _balances[_recipient] = _balances[_recipient].add(_amount);
        
    }
    
    //get the balance of given address
    function balanceOf(address _address) public returns(uint){
        return  _balances[_address];
    }
    
}

