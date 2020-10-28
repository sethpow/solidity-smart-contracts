pragma solidity 0.5.12;

// require() checks for errors in input
// assert() checks for errors in invariants (errors in code/logic)

contract HelloWorld {
    
    struct Person {
        string name;
        uint age;
        uint height;
        bool isSenior;
    }
    
    address public owner;
    
    // runs whenever contract is created
    constructor() public {
        owner = msg.sender;
    }
    
    // key value pair; address is key (data type) we search for to return the person (value)
    // people is name of mapping
    mapping(address => Person) private people;
    
    address[] private creators;
    
    function createPerson(string memory name, uint age, uint height) public {
        require(age < 150, "Age needs to be below 150");
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
        creators.push(msg.sender);
        
        // the following assert is checking the invariant:      people[msg.sender] == newPerson
        // msg.sender hash should equal newPerson hash
        assert( // hash of person added into people mapping                                                                                             // person we created in createPerson function
            keccak256(abi.encodePacked(people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].isSenior)) == keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.height, newPerson.isSenior))
        );

    }
    
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        
        // mapping people; adding newPerson to mapping
        // associating new person with the creator "key"
        people[creator] = newPerson;
    }
    
    // view means its a get function (doesnt modify contract in any way, just returns a variable)
    function getPerson() public view returns(string memory name, uint age, uint height, bool isSenior) {
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].isSenior);
    }
    
    function deletePerson(address creator) public {
        require(msg.sender == owner);
        delete people[creator];
        
        // invariant: after we delete person, age should be 0       people[creator].age == 0
        assert(people[creator].age == 0);
    }
    
    // view means its a get function (doesnt modify contract in any way, just returns a variable)
    function getCreator(uint index) public view returns(address) {
        require(msg.sender == owner, "Caller must be the owner.");
        return creators[index];
    }
    
}