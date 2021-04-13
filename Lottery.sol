pragma solidity 0.5.16;

contract Lottery {
    address payable [] public players;
    address public manager;
    
    modifier onlyManager(){
        require(msg.sender == manager, "Only callable by the manager");
        _;
    }
    
    constructor() public {
        manager = msg.sender;
    }
    
    // enter lottery by sending ether to contract address
    function() external payable {
        players.push(msg.sender);
    }
    
    // get contract balance
    function get_balance() onlyManager public view returns(uint){
        return address(this).balance;
    }
    
    function random() onlyManager public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    function selectWinner() onlyManager public {
        uint r = random();
        
        address payable winner;
        
        //a random index
        uint index = r % players.length;
        winner = players[index];
        
        //transfer contract balance to the winner address
        winner.transfer(address(this).balance);
        
        players = new address payable[](0); //resetting the players dynamic array
    }
    
}