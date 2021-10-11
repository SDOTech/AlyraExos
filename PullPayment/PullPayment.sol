pragma solidity 0.8.0;

contract PullPayment {

    mapping(address => uint) credits;

    function pay(address to) payable external {
        credits[to] += msg.value; 
    }

    function withdraw() external {
        uint refund = credits[msg.sender];
       //(bool success, ) = msg.sender.call.value(refund)("");
       (bool success, ) = msg.sender.call{value:refund}("");
        require(success);
    }
}