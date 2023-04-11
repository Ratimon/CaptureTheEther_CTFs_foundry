// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheNewNumberScript} from "@script/lotteries/4_DeployGuessTheNewNumber.s.sol";
import {GuessTheNewNumberChallenge} from "@main/lotteries/GuessTheNewNumber.sol";
import {GuessTheNewNumberSolver} from "@main/lotteries/GuessTheNewNumberSolver.sol";

contract GuessTheNewNumberTest is Test, DeployGuessTheNewNumberScript {
    string mnemonic ="test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    GuessTheNewNumberSolver solver;

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 2 ether);

        DeployGuessTheNewNumberScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(guessthenewnumberChallenge.isComplete(), false);
        assertEq(address(guessthenewnumberChallenge).balance, 1 ether);

        solver = new GuessTheNewNumberSolver(address(guessthenewnumberChallenge));
        solver.solve{value: 1 ether}();

        assertEq(guessthenewnumberChallenge.isComplete(), true);
        assertEq(address(guessthenewnumberChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
