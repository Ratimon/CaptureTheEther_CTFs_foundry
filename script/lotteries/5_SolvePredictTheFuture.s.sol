// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Script, console} from "@forge-std/Script.sol";
import {PredictTheFutureChallenge} from "@main/lotteries/PredictTheFuture.sol";
import {PredictTheFutureSolver} from "@main/lotteries/PredictTheFutureSolver.sol";

contract SolvePredictTheFutureScript is Script {
    PredictTheFutureChallenge  predictthefutureChallenge = PredictTheFutureChallenge( payable(address(0x8464135c8F25Da09e49BC8782676a84730C318bC)) );
    PredictTheFutureSolver solver = PredictTheFutureSolver( payable(address(0x663F3ad617193148711d28f5334eE4Ed07016602)) );
    // PredictTheFutureSolver solver;


    function run() public {

        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // string memory mnemonic = vm.envString("MNEMONIC");

        // address is already funded with ETH
        string memory mnemonic ="test test test test test test test test test test test junk";
        uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

        vm.startBroadcast(attackerPrivateKey);

         // make anvil-node
        // solver = new PredictTheFutureSolver{value: 1 ether}(address(predictthefutureChallenge), 7);
        solver.settleChallenge();

        console.log("is Solved? ", predictthefutureChallenge.isComplete());

        vm.stopBroadcast();
    }
}
