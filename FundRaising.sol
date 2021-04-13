pragma solidity 0.5.16;

contract FundRaising {
    address public admin;
    mapping(address => uint) public contributors;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline;
    uint public goal;
    uint public raisedAmount = 0;
    
    struct Request {
        string description;
        address payable recipient;
        uint value;
        uint noOfVoters;
        bool completed;
        mapping(address => bool) voters;
    }
    
    Request[] public requests;
    
    event ContributeEvent(address sender, uint value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePaymentEvent(address recipient, uint value);  // triggered when admin makes a payment
    
    constructor(uint _goal, uint _deadline) public {
        admin = msg.sender;
        
        goal = _goal;
        deadline = now + _deadline;
        
        minimumContribution = 10;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }
    
    function contribute() public payable {
        require(now < deadline);
        require(msg.value >= minimumContribution);
        
        if(contributors[msg.sender] == 0){
            noOfContributors++;
        }
        
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;
        
        emit ContributeEvent(msg.sender, msg.value);
    }
    
    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
    
    function getRefund() public {
        require(now > deadline);
        require(raisedAmount < goal);
        require(contributors[msg.sender] > 0);
        
        address payable recipient = msg.sender;
        uint value = contributors[msg.sender];
        
        recipient.transfer(value);
        contributors[msg.sender] = 0;
    }
    
    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
        Request memory newRequest = Request({
            description: _description,
            recipient: _recipient,
            value: _value,
            noOfVoters: 0,
            completed: false
        });
        
        requests.push(newRequest);
        
        emit CreateRequestEvent(_description, _recipient, _value);
    }
    
    function voteRequest(uint index) public {
        Request storage thisRequest = requests[index];
        
        require(contributors[msg.sender] > 0);
        require(thisRequest.voters[msg.sender] == false);
        
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }
    
    // make payment to a saved request in requests array
    function makePayment(uint index) public onlyAdmin {
        Request storage thisRequest = requests[index];
        
        // request is uncompleted
        require(thisRequest.completed == false);
        
        // more than 50% voted
        require(thisRequest.noOfVoters > noOfContributors / 2);
        
        thisRequest.recipient.transfer(thisRequest.value);
        
        thisRequest.completed = true;
        
        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
    
}