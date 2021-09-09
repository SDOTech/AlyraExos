pragma solidity 0.6.11;

contract Whitelist {
    
    // Person
    struct Person {
        string name;
        uint age;
    }
    
    //Create a new Person
    function addPerson  (string memory _name, uint _age) public {
        Person memory person = Person(_name,_age);
        
    }
    
}