// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployPredictTheFutureScript} from "@script/lotteries/5_DeployPredictTheFuture.s.sol";
import {PredictTheFutureChallenge} from "@main/lotteries/PredictTheFuture.sol";
import {PredictTheFutureSolver} from "@main/lotteries/PredictTheFutureSolver.sol";

contract PredictTheFutureTest is Test, DeployPredictTheFutureScript {
    string mnemonic ="test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    // address public attacker = address(11);

    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
    address attacker = vm.addr(attackerPrivateKey);

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 1 ether);

        DeployPredictTheFutureScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(predictthefutureChallenge.isComplete(), false);
        assertEq(address(predictthefutureChallenge).balance, 2 ether);

        while (!predictthefutureChallenge.isComplete()) {
            solver.settleChallenge();
            vm.roll(block.number + 1);
        }

        assertEq(predictthefutureChallenge.isComplete(), true);
        assertEq(address(predictthefutureChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
