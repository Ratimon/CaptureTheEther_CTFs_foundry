// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test, console} from "@forge-std/Test.sol";

import {DeployPredictTheBlockHashScript} from "@script/lotteries/7_DeployPredictTheBlockHash.s.sol";
import {PredictTheBlockHashChallenge} from "@main/lotteries/PredictTheBlockHash.sol";

contract PredictTheBlockHashTest is Test, DeployPredictTheBlockHashScript {
    string mnemonic ="test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 1 ether);

        DeployPredictTheBlockHashScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(predicttheblockhashChallenge.isComplete(), false);
        assertEq(address(predicttheblockhashChallenge).balance, 1 ether);

        uint256 initialBlock = block.number;
        bytes32 guess = 0x0000000000000000000000000000000000000000000000000000000000000000;
        predicttheblockhashChallenge.lockInGuess{value: 1 ether}(guess);
        vm.roll(initialBlock + 1 + 257);
        predicttheblockhashChallenge.settle();

        assertEq(predicttheblockhashChallenge.isComplete(), true);
        assertEq(address(predicttheblockhashChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
