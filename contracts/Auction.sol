// SPDX-License-Identifier: MIT 
pragma solidity >=0.5.0 <0.9.0;

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;
    
    enum State { Started,  Running, Ended, Cancelled }

    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;
    uint bidIncrement;
    uint minBid;

    constructor(){
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = block.number + ((60 * 60 * 24 * 7) / 15);
        ipfsHash = "";
        bidIncrement = 100;
        minBid = 100;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }

    modifier afterStart(){
        require(block.number > startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock);
        _;
    }

    function cancelAuction() public onlyOwner{
        auctionState = State.Cancelled;
    }

    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running);
        require(msg.value >= minBid);

        uint currentBid = bids[msg.sender] + msg.value;

        require(currentBid > highestBindingBid);

        bids[msg.sender] = currentBid;

        if(currentBid > bids[highestBidder]){
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        } else {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }
    }

    function min(uint a, uint b) pure internal returns (uint){
        if(a < b){
            return a;
        } else {
            return b;
        }   
    }
}