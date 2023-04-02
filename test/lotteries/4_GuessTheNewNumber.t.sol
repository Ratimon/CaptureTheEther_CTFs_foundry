// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheNewNumberScript} from "@script/lotteries/4_DeployGuessTheNewNumber.s.sol";
import {GuessTheNewNumberChallenge} from "@main/lotteries/GuessTheNewNumber.sol";
import {GuessTheNewNumberSolver} from "@main/lotteries/GuessTheNewNumberSolver.sol";


contract GuessTheNewNumberTest is Test, DeployGuessTheNewNumberScript {

    address public attacker = address(11);

    GuessTheNewNumberSolver solver;

    function setUp() public {
        vm.deal(attacker, 1.5 ether);
        vm.label(attacker, "Attacker");

        guessthenewnumberChallenge = new GuessTheNewNumberChallenge{value: 1 ether}();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq( guessthenewnumberChallenge.isComplete(), false);
        assertEq( address(guessthenewnumberChallenge).balance, 1 ether);

        solver = new GuessTheNewNumberSolver(address(guessthenewnumberChallenge));
        solver.solve{value: 1 ether}();

        assertEq( guessthenewnumberChallenge.isComplete(), true);
        assertEq( address(guessthenewnumberChallenge).balance, 0 ether);
       
        vm.stopPrank( );
    }

}