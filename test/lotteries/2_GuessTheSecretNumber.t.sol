// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";
import {console} from "@forge-std/console.sol";

import {DeployGuessTheSecretNumberScript} from "@script/lotteries/2_DeployGuessTheSecretNumber.s.sol";
import {GuessTheSecretNumberChallenge} from "@main/lotteries/GuessTheSecretNumber.sol";

contract GuessTheSecretNumberTest is Test, DeployGuessTheSecretNumberScript {
    address public attacker = address(11);

    function setUp() public {
        vm.deal(attacker, 2 ether);
        vm.label(attacker, "Attacker");

        guessthesecretnumberChallenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
        // comment out due to in-abillity to deploy with sent ether
        // DeployGuessTheSecretNumberScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(guessthesecretnumberChallenge.isComplete(), false);
        assertEq(address(guessthesecretnumberChallenge).balance, 1 ether);

        bytes32 secret = vm.load(address(guessthesecretnumberChallenge), 0);
        uint8 length = 255;
        uint8 answer;
        for (uint8 i = 0; i < length; i++) {
            if (keccak256(abi.encodePacked(i)) == secret) answer = i;
        }
        guessthesecretnumberChallenge.guess{value: 1 ether}(answer);
        console.log("answer", answer);
        assertEq(guessthesecretnumberChallenge.isComplete(), true);
        assertEq(address(guessthesecretnumberChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
