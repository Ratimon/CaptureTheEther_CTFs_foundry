// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test, console} from "@forge-std/Test.sol";

import {DeployPredictTheBlockHashScript} from "@script/lotteries/7_DeployPredictTheBlockHash.s.sol";
import {PredictTheBlockHashChallenge} from "@main/lotteries/PredictTheBlockHash.sol";

contract PredictTheBlockHashTest is Test, DeployPredictTheBlockHashScript {

    address public attacker = address(11);

    function setUp() public {
        vm.deal(attacker, 1.5 ether);
        vm.label(attacker, "Attacker");

        predicttheblockhashChallenge = new PredictTheBlockHashChallenge{value: 1 ether}();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq( predicttheblockhashChallenge.isComplete(), false);
        assertEq( address(predicttheblockhashChallenge).balance, 1 ether);

        uint256 initialBlock = block.number;
        bytes32 guess = 0x0000000000000000000000000000000000000000000000000000000000000000;
        predicttheblockhashChallenge.lockInGuess{value: 1 ether}(guess);
        vm.roll(initialBlock + 1 + 257);
        predicttheblockhashChallenge.settle();

        assertEq( predicttheblockhashChallenge.isComplete(), true);
        assertEq( address(predicttheblockhashChallenge).balance, 0 ether);
       
        vm.stopPrank(  );
    }

}