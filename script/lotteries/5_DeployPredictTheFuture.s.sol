// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Script} from "@forge-std/Script.sol";
import {PredictTheFutureChallenge} from "@main/lotteries/PredictTheFuture.sol";
import {PredictTheFutureSolver} from "@main/lotteries/PredictTheFutureSolver.sol";

contract DeployPredictTheFutureScript is Script {
    PredictTheFutureChallenge predictthefutureChallenge;
    PredictTheFutureSolver solver;

    function run() public {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // string memory mnemonic = vm.envString("MNEMONIC");

        // address is already funded with ETH
        string memory mnemonic = "test test test test test test test test test test test junk";
        uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

        vm.startBroadcast(deployerPrivateKey);
        predictthefutureChallenge = new PredictTheFutureChallenge{value: 1 ether}();
        vm.stopBroadcast();

        uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC

        vm.startBroadcast(attackerPrivateKey);
        solver = new PredictTheFutureSolver{value: 1 ether}(address(predictthefutureChallenge), 7);
        vm.stopBroadcast();
    }
}
