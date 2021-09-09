pragma solidity 0.6.11;

contract Whitelist {
    
    // Person
    struct Person {
        string name;
        uint age;
    }
    
    Person[] public persons;
    
}