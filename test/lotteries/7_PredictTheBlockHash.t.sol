// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test, console} from "@forge-std/Test.sol";

import {DeployPredictTheBlockHashScript} from "@script/lotteries/6_DeployPredictTheBlockHash.s.sol";
import {PredictTheBlockHashChallenge} from "@main/lotteries/PredictTheBlockHash.sol";
// import {PredictTheBlockHashSolver} from "@main/lotteries/PredictTheFutureSolver.sol";

contract PredictTheBlockHashTest is Test, DeployPredictTheBlockHashScript {

    string mnemonic ="test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    // PredictTheBlockHashSolver solver;

    function setUp() public {
        vm.deal(attacker, 1.5 ether);
        vm.label(attacker, "Attacker");

        predicttheblockhashChallenge = new PredictTheBlockHashChallenge{value: 1 ether}();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq( predicttheblockhashChallenge.isComplete(), false);
        assertEq( address(predicttheblockhashChallenge).balance, 1 ether);

        // vm.roll(block.number + 1);

        // bytes32 oneguess = blockhash(0);
        // bytes32 guess = blockhash(block.number );
        // // bytes32 guess = 0x0000000000000000000000000000000000000000000000000000000000000000;

        // console.log('oneguess');
        // console.logBytes32(oneguess);

        // console.log('guess1');
        // console.logBytes32(guess);

        // vm.roll(block.number + 256);

        // bytes32 preguess = blockhash(1);
        // bytes32 guess2 = blockhash(block.number + 1);


        // console.log('preguess');
        // console.logBytes32(preguess);

        // console.log('guess2');
        // console.logBytes32(guess2);

        // ///////


        // while (!predicttheblockhashChallenge.isComplete()) {

        uint256 initialBlock = block.number;

            // bytes32 guess = blockhash(block.number + 1);
        bytes32 guess3 = 0x0000000000000000000000000000000000000000000000000000000000000000;

        predicttheblockhashChallenge.lockInGuess{value: 1 ether}(guess3);

        vm.roll(initialBlock + 1 + 257);

        predicttheblockhashChallenge.settle();

            // console.log('preguess');
            // console.logBytes32(preguess);

            // vm.roll(block.number + 1);

        // }

        assertEq( predicttheblockhashChallenge.isComplete(), true);
        assertEq( address(predicttheblockhashChallenge).balance, 0 ether);
       
        vm.stopPrank(  );
    }

}