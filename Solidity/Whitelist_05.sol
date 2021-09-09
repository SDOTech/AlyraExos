pragma solidity 0.6.11;

contract Whitelist {
    
    // Person
    struct Person {
        string name;
        uint age;
    }
    
    Person[] public persons;
    
    //Add Person to defined persons array
    function add(string memory _name, uint _age) public {
        Person memory person = Person(_name,_age);
        persons.push(person);
    }
    
    
    //Remove last person entered in persons array
    function remove() public {
        persons.pop();
    }
}