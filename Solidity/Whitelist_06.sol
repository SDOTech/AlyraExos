pragma solidity 0.6.11;

contract Whitelist {
    
    //Mapings
    mapping (address => bool) whitelist;
    
    //Events
    event Authorized(address _address);
    
}