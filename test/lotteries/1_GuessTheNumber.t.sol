// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheNumberScript} from "@script/lotteries/1_DeployGuessTheNumber.s.sol";
import {GuessTheNumberChallenge} from "@main/lotteries/GuessTheNumber.sol";

contract GuessTheNumberTest is Test, DeployGuessTheNumberScript {
    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 1 ether);

        DeployGuessTheNumberScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(guessthenumberChallenge.isComplete(), false);
        assertEq(address(guessthenumberChallenge).balance, 1 ether);
        uint8 answer = uint8(uint256(vm.load(address(guessthenumberChallenge), 0)));
        guessthenumberChallenge.guess{value: 1 ether}(answer);
        assertEq(guessthenumberChallenge.isComplete(), true);
        assertEq(address(guessthenumberChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
