pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

//Admin contract
contract Admin is Ownable {
    
    // **************** Mappings ****************
    mapping (address => bool) _whitelist;
    mapping (address => bool) _blacklist;
    
    // **************** Events ****************
    event Whitelisted(address _address);
    event Blacklisted(address _address);
    
    // **************** Functions ****************
    
    //WhiteList an address
    function whitelist(address _address) public onlyOwner {
        
        //add address to whitelist collection and set as true it on blacklist
        _whitelist[_address] = true;
        _blacklist[_address] = false;
        
         //fire event
        emit Whitelisted(_address);
    }
    
    //BlackList an address
    function blacklist(address _address) public onlyOwner {
        
        //add address to blacklist collection and set as false it on whitelist
        _whitelist[_address] = false;
        _blacklist[_address] = true;
        
         //fire event
        emit Blacklisted(_address);
    }
    
    //Return true if address is whitelisted, else false
    function isWhitelisted(address _address) public returns (bool){
       return _whitelist[_address];
    }
    
    //Return false if address is whitelisted, else false
    function isBlacklisted(address _address) public returns (bool){
        return _blacklist[_address];
        
    }
    
}