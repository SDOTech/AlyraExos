pragma solidity 0.6.11;

contract Time{
    
    function getTime() public returns (uint){
        return block.timestamp;
    }
}