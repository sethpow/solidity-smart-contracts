pragma solidity 0.5.12;

// require() checks for errors in input
// assert() checks for errors in invariants (errors in code/logic)

/* Data Locations - where solidity saves data
* storage - anything saved permanently; age of contract (state variables, mappings, etc...)
* memory - only saved during function execution; deleted after function ends (need to explicitly assign string, arrays, and structs to memory; function params default to memory)
* stack - made to hold local variables of value types (int, bool, etc..)
*/

contract HelloWorld {
    
    struct Person {
        string name;
        uint age;
        uint height;
        bool isSenior;
    }
    
    event personCreated(string name, bool isSenior);    // do not need to assign to memory in events
    event personDeleted(string name, bool isSenior, address deletedBy);
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; // continue execution if above is true
    }
    
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
        Person memory newPerson;    // struct;
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
        emit personCreated(newPerson.name, newPerson.isSenior); // emit - sends events
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
    
    function deletePerson(address creator) public onlyOwner {
        // pulling out name and isSenior data before it is deleted
        string memory name = people[creator].name;
        bool isSenior = people[creator].isSenior;
        
        delete people[creator];
        
        // invariant: after we delete person, age should be 0       people[creator].age == 0
        assert(people[creator].age == 0);
        
        emit personDeleted(name, isSenior, msg.sender);
    }
    
    // view means its a get function (doesnt modify contract in any way, just returns a variable)
    function getCreator(uint index) public view onlyOwner returns(address) {
        return creators[index];
    }
    
}