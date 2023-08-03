// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployFuzzyIdentityScript} from "@script/accounts/9_DeployFuzzyIdentity.s.sol";
import {FuzzyIdentityChallenge} from "@main/accounts/FuzzyIdentity.sol";

contract FuzzyIdentityTest is Test, DeployFuzzyIdentityScript {
    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);
    address public attacker = address(11);

    function setUp() public {
        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 1 ether);

        DeployFuzzyIdentityScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(fuzzyIdentityChallenge.isComplete(), false);



        // assertTrue(fuzzyIdentityChallenge.isComplete(), "Challenge is not complete");

        vm.stopPrank();
    }
}
