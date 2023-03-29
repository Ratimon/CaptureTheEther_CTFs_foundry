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
    address public attacker = address(11);

    // PredictTheFutureSolver solver;

    function setUp() public {
        vm.deal(attacker, 1.5 ether);
        vm.label(attacker, "Attacker");

        predictthefutureChallenge = new PredictTheFutureChallenge{value: 1 ether}();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq( predictthefutureChallenge.isComplete(), false);
        assertEq( address(predictthefutureChallenge).balance, 1 ether);

        solver = new PredictTheFutureSolver{value: 1 ether}(address(predictthefutureChallenge), 7);

        while (!predictthefutureChallenge.isComplete()) {
             solver.settleChallenge();
             vm.roll(block.number + 1);
        }

        assertEq( predictthefutureChallenge.isComplete(), true);
        assertEq( address(predictthefutureChallenge).balance, 0 ether);
       
        vm.stopPrank(  );
    }

}