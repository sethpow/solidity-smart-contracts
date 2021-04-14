pragma solidity 0.5.16;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Cryptos is ERC20Interface {
    string public name = "Cryptos";
    string public symbol = "CRPT";
    uint public decimals = 0;
    
    uint public supply;
    address public founder;
    
    mapping(address => uint) public balances;
    
    // allowed[0x11111][0x22222] = 100;     acc 1 gives acc 2 permission to spend 100 tokens
    mapping(address => mapping(address => uint)) allowed;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    
    constructor() public {
        supply = 1000000;
        founder = msg.sender;
        balances[founder] = supply;
    }
    
    function totalSupply() public view returns (uint) {
        return supply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public returns (bool success) {
        require(balances[msg.sender] >= tokens && tokens > 0);
        
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        
        emit Transfer(msg.sender, to, tokens);
        
        return true;
    }


    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        
        allowed[msg.sender][spender] = tokens;
        
        emit Approval(msg.sender, spender, tokens);
        
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        
        balances[from] -= tokens;
        balances[to] += tokens;
        
        allowed[from][to] -= tokens;
        
        return true;
    }

}