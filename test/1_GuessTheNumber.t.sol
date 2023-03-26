// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheNumberScript} from "@script/1_DeployGuessTheNumber.s.sol";
import {GuessTheNumberChallenge} from "@main/1_GuessTheNumber.sol";

interface IGuessTheNumber {
    function answer() external returns(uint8);
}
// contract GuessTheNumberTest is Test {

//     GuessTheNumberChallenge guessthenumberChallenge;

contract GuessTheNumberTest is Test, DeployGuessTheNumberScript {

    address public deployer;
    address public attacker = address(11);

    function setUp() public {

        deployer = msg.sender;

        vm.deal(deployer, 2 ether);
        vm.deal(attacker, 2 ether);

        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        guessthenumberChallenge = new GuessTheNumberChallenge{value: 1 ether}();
        // comment out due to in-abillity to deploy with sent ether
        // DeployGuessTheNumberScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        // in case public variable
        // uint8 guessNumber = IGuessTheNumber(address(guessthenumberChallenge)).answer();
        // guessthenumberChallenge.guess{value: 1 ether}(guessNumber);

        guessthenumberChallenge.guess{value: 1 ether}(42);


        assertEq( guessthenumberChallenge.isComplete(), true);
       
        vm.stopPrank(  );
    }


}