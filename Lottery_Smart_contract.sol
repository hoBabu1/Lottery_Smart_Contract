// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Lottery
{
    address public manager;
    address payable[] public participants;
    constructor()
    {
        manager = msg.sender ;
    }
    receive() external payable 
    {
        require(msg.value == 2 ether);
        participants.push(payable(msg.sender));
    }
    function fetch_balance() public view returns (uint)
    {
        require(msg.sender == manager);
        return address(this).balance;
    }
    function random() private view returns(uint)
    {
      return uint(keccak256(abi.encodePacked( block.timestamp , participants.length)));
    }
    function select_winner() public 
    {
        require(msg.sender == manager);
        require(participants.length>=3);
        uint index =  random()%participants.length;
        address payable winner ;
        winner = participants[index];
        winner.transfer(fetch_balance());
        participants = new address payable[](0);
    }
}