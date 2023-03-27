// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Script} from "@forge-std/Script.sol";
import {GuessTheNumberChallenge} from "@main/lotteries/1_GuessTheNumber.sol";

contract SolveGuessTheNumberScript is Script {
    GuessTheNumberChallenge  guessthenumberChallenge = GuessTheNumberChallenge( payable(address(0x8464135c8F25Da09e49BC8782676a84730C318bC)) );

    function run() public {
        // uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        // string memory mnemonic = vm.envString("MNEMONIC");

        // address is already funded with ETH
        string memory mnemonic ="test test test test test test test test test test test junk";
        uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8

        vm.startBroadcast(deployerPrivateKey);

        string[] memory inputs = new string[](4);
        inputs[0] = "cast";
        inputs[1] = "storage";
        inputs[2] = "0x8464135c8f25da09e49bc8782676a84730c318bc";
        inputs[3] = "0";

        bytes memory res = vm.ffi(inputs);
        bytes32 output = abi.decode(res, (bytes32));  

        uint8 answer = uint8(
            uint256(  
                output
            )
        ); 


        guessthenumberChallenge.guess{value: 1 ether}(answer);

        vm.stopBroadcast();
    }
}
