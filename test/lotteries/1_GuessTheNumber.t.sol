// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheNumberScript} from "@script/lotteries/1_DeployGuessTheNumber.s.sol";
import {GuessTheNumberChallenge} from "@main/lotteries/1_GuessTheNumber.sol";

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

        uint8 answer = uint8(
            uint256(  
                vm.load(address(guessthenumberChallenge), 0)
            )
        );

        guessthenumberChallenge.guess{value: 1 ether}(answer);

        assertEq( guessthenumberChallenge.isComplete(), true);
       
        vm.stopPrank(  );
    }


}