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

    constructor(){
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = block.number + ((60 * 60 * 24 * 7) / 15);
        ipfsHash = "";
        bidIncrement = 100;
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

    modifier afterEnd(){
        require(block.number <= endBlock);
        _;
    }
}