pragma solidity 0.5.12;

// interface = definition of an external contract and its functions
contract Person {
    function createPerson(string memory name, uint age, uint height) public payable;
}

contract ExternalContract {
    Person instance = Person(0xaE036c65C649172b43ef7156b009c6221B596B8b);
    
    function ExternalCreatePerson(string memory name, uint age, uint height) public payable {
        // Call createPerson in Person contract
        // forward any ether to Person
        instance.createPerson.value(msg.value)(name, age, height);
    }
}