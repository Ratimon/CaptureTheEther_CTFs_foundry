// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployTokenBankScript} from "@script/miscellaneous/6_DeployTokenBank.s.sol";
import { SimpleERC223Token, TokenBankChallenge} from "@main/miscellaneous/TokenBank.sol";
import {TokenBankAttacker} from "@main/miscellaneous/TokenBankAttacker.sol";

contract TokenBankTest is Test, DeployTokenBankScript {

    string mnemonic ="test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

    address deployer = vm.addr(deployerPrivateKey);
    // address public attacker = address(11);

    SimpleERC223Token token;
    TokenBankAttacker tokenbankAttacker;


    function setUp() public {
        vm.deal(attacker, 1.5 ether);
        vm.label(attacker, "Attacker");

        DeployTokenBankScript.run();
        token = tokenbankChallenge.token();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq( tokenbankChallenge.isComplete(), false);
        assertEq( tokenbankChallenge.balanceOf(attacker), 500000 ether);
        assertEq( tokenbankChallenge.balanceOf(deployer), 500000 ether);

        assertEq( token.balanceOf(address(tokenbankChallenge)), 1000000 ether);

        tokenbankChallenge.withdraw(500000 ether);

        assertEq( tokenbankChallenge.balanceOf(attacker), 0 ether);
        assertEq( token.balanceOf(attacker), 500000 ether);

        tokenbankAttacker = new TokenBankAttacker(address(tokenbankChallenge), address(token)  );
        token.approve(address(tokenbankAttacker), type(uint256).max);
        tokenbankAttacker.attack();

        assertEq( tokenbankChallenge.isComplete(), true);
       
        vm.stopPrank( );
    }

}