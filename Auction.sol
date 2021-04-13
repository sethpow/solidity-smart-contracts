pragma solidity ^0.5.16;

contract AuctionCreator {
    // msg.sender will be AuctionCreator contract address
    Auction[] public auctions;
    
    function createAuction() public {
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    
    enum State {Started, Running, Ended, Cancelled}
    State public auctionState;
    
    uint public highestBindingBid;
    address payable public highestBidder;
    
    mapping(address => uint) public bids;
    
    uint public bidIncrement;
    
    constructor(address payable creator) public {
        owner = creator;
        auctionState = State.Running;
        
        startBlock = block.number;
        endBlock = startBlock + 40320;
        ipfsHash = "";
        bidIncrement = 10;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this.");
        _;
    }
    
    modifier notOwner() {
        require(msg.sender != owner, "The owner cannot perform this.");
        _;
    }
    
    modifier afterStart() {
        require(block.number >= startBlock, "Cannot bid before the auction starts");
        _;
    }
    
    modifier beforeEnd() {
        require(block.number <= endBlock, "Cannot bid after the auction has ended");
        _;
    }
    
    function min(uint a, uint b) pure internal returns(uint) {
        if(a <= b) {
            return a;
        } else {
            return b;
        }
    }
    
    function cancelAuction() public onlyOwner {
        auctionState = State.Cancelled;
    }
    
    function placeBid() payable public notOwner afterStart beforeEnd returns(bool) {
        require(auctionState == State.Running, "Auction is not running");
        require(msg.value >= .0001 ether, "Must bid more ether");
        
        uint currentBid = bids[msg.sender] + msg.value;
        
        require(currentBid > highestBindingBid, "Bid must be higher than the highest binding bid");
        
        bids[msg.sender] = currentBid;
        
        // if current bid is greater than the value sent by the highest bidder
        if(currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = msg.sender;
        }
        
        return true;
    }
    
    function finalizeAuction() public {
        require(auctionState == State.Cancelled || block.number >= endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);
        
        address payable recipient;
        uint value;
        
        // Cancelled
        if(auctionState == State.Cancelled) {
            recipient = msg.sender;
            value = bids[msg.sender];
        } else {
            // Ended, not Cancelled
            if(msg.sender == owner) {
                recipient = owner;
                value = highestBindingBid;
            } else {
                if(msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                } else {
                    // neither the owner or highest bidder
                    recipient = msg.sender;
                    value = bids[msg.sender];
                }
            }
        }
        
        recipient.transfer(value);
    }
    
}