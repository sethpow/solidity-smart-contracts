pragma solidity 0.5.12;

contract Ownable {
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _; // continue execution if above is true
    }
    
     // runs whenever contract is created
    constructor() public {
        owner = msg.sender;
    }
    
}