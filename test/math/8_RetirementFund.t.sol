// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployRetirementFundScript} from "@script/math/8_DeployRetirementFund.s.sol";
import {RetirementFundChallenge} from "@main/math/RetirementFund.sol";
import {RetirementFundAttacker} from "@main/math/RetirementFundAttacker.sol";

contract RetirementFundTest is Test, DeployRetirementFundScript {
    string mnemonic = "test test test test test test test test test test test junk";

    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);

    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
    address attacker = vm.addr(attackerPrivateKey);

    RetirementFundAttacker retirementfundAttacker;

    function setUp() public {

        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

        vm.deal(deployer, 1 ether);
        vm.deal(attacker, 2 ether);

        DeployRetirementFundScript.run();
    }

    function test_isSolved() public {
        vm.startPrank(attacker);

        assertEq(retirementfundChallenge.isComplete(), false);

        retirementfundAttacker = new RetirementFundAttacker{value : 1 ether}(address(retirementfundChallenge));
        retirementfundAttacker.attack();
        retirementfundChallenge.collectPenalty();

        assertEq(retirementfundChallenge.isComplete(), true);
        assertEq(address(retirementfundChallenge).balance, 0 ether);

        vm.stopPrank();
    }
}
