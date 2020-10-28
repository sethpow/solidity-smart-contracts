pragma solidity ^0.5.12;

contract HelloWorld {
    
    struct Person {
        string name;
        uint age;
        uint height;
        bool isSenior;
    }
    
    // key value pair; address is key (data type) we search for to return the person (value)
    // people is name of mapping
    mapping(address => Person) private people;
    
    function createPerson(string memory name, uint age, uint height) public {
        //this creates a Person
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if(age >= 65){
            newPerson.isSenior = true;
        } else {
            newPerson.isSenior = false;
        }
        insertPerson(newPerson);
        
    }
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        
        // mapping people; adding newPerson to mapping
        // associating new person with the creator "key"
        people[creator] = newPerson;
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height, bool isSenior) {
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].isSenior);
    }
    
}