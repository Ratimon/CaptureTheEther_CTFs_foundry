// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";
import {console} from "@forge-std/console.sol";

import {DeployGuessTheSecretNumberScript} from "@script/lotteries/2_DeployGuessTheSecretNumber.s.sol";
import {GuessTheSecretNumberChallenge} from "@main/lotteries/GuessTheSecretNumber.sol";

contract GuessTheSecretNumberTest is Test, DeployGuessTheSecretNumberScript {
    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 2 ether);

        DeployGuessTheSecretNumberScript.run();
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
