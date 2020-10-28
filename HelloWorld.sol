pragma solidity ^0.5.12;

contract HelloWorld {
    // smart contract has state variables and... (data persisting thru contracts life)
    string public message = "Hello World";
    uint[] public numbers = [99,43,54,56];
    
    //functions
    // view means its a get function (doesnt modify contract in any way, just returns a variable)
    function getMessage() public view returns(string memory){
        return message;
    }
    
    // setter modifies state, therefore we dont use 'view'
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
    
    function getNumber(uint index) public view returns(uint){
        return numbers[index];
    }
    
    function setNumber(uint newNumber, uint index) public {
        numbers[index] = newNumber;
    }
    
    function addNumber(uint newNumber) public {
        numbers.push(newNumber);
    }
    
}