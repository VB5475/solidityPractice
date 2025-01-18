
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract lottery {
    address public manager;
    address payable[] public players;
    address payable public winner;

    constructor() {
        manager = msg.sender;
    }

    function participate () public payable {
        require(msg.value==1 ether , "please pay 1 ether only");
        players.push(payable (msg.sender));


    }
function getBalance() public view returns (uint){
    require(manager == msg.sender,"bro you're not manger");
    return address(this).balance;
}

function random () internal  view returns(uint){
    return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players.length)));
}

function pickWinner () public   {
    require(manager== msg.sender,"you're not manager");
    require(players.length>=3,"particioants are not eniugh yet");
    uint randomNum = random();
    uint winnerIndex = randomNum%players.length;

    winner = players[winnerIndex];
    winner.transfer(getBalance());
    players= new address payable [](0);


}

}