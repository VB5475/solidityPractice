// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding{

struct Request {
    string description;
    address payable recipient ;
    uint value;
    bool completed;
    uint noVoters;
    mapping (address=>bool) voters;

}
mapping (uint =>Request) public requests;
uint numRequests;
    mapping (address => uint) public contributors;
    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;

constructor(uint _target,uint _deadline) {
    target = _target;
    deadline = block.timestamp + _deadline;
    minimumContribution = 100 wei;
    manager = msg.sender;
}

modifier onlyManager () {
    require(msg.sender == manager,"you are not the manager");
    _;
}

modifier  onlyContributor () {
    require(contributors[msg.sender]>0,"you are not a contributor");
    _;
}

function createRequest (string calldata _description, address payable _recipient,uint _value) public onlyManager {
    Request storage newRequest = requests[numRequests];
    numRequests++;
    newRequest.description = _description;
    newRequest.recipient= _recipient;
    newRequest.value = _value;
    newRequest.completed =false;
    newRequest.noVoters = 0;

    

}


function contribution( ) public payable {
    require(block.timestamp<deadline,"deadline is passed ");
    require(msg.value>=minimumContribution,"minimum contribution should be atleast 100 wei");
    if(contributors[msg.sender]== 0 ){
        noOfContributors++;
    }
contributors[msg.sender]+=msg.value;
raisedAmount+=msg.value;

    }

function contractBalance() public view returns(uint) {
    return address(this).balance;

}

function refund() public onlyContributor{
    require(block.timestamp>deadline && raisedAmount<target,"youvre not eligilbe for refund");
   
    payable(msg.sender).transfer(contributors[msg.sender]);
    contributors[msg.sender] = 0;
}

function voteRequest(uint _reqeustNo) public onlyContributor{
   Request storage currentRequest = requests[_reqeustNo];
require(currentRequest.voters[msg.sender]==false,"you have voted already");

currentRequest.voters[msg.sender] = true;
currentRequest.noVoters++;

}

function makePayment (uint _requestNo) public onlyManager {
    require(raisedAmount>=target,"target is not achived yet");
    Request storage currentRequest = requests[_requestNo];
    require(currentRequest.completed==false,"request is already completed");
    require(currentRequest.noVoters > noOfContributors/2,"majority does not agree");
    currentRequest.recipient.transfer(currentRequest.value);
    currentRequest.completed = true;
}

}