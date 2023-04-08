// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test} from "@forge-std/Test.sol";

import {DeployRetirementFundScript} from "@script/math/8_DeployRetirementFund.s.sol";
import {RetirementFundChallenge} from "@main/math/RetirementFund.sol";
import {RetirementFundAttacker} from "@main/math/RetirementFundAttacker.sol";

contract RetirementFundTest is Test, DeployRetirementFundScript {
    string mnemonic = "test test test test test test test test test test test junk";

    uint256 attackerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 2); //  address = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC
    address attacker = vm.addr(attackerPrivateKey);

    RetirementFundAttacker retirementfundAttacker;

    function setUp() public {
        vm.deal(attacker, 2 ether);
        vm.label(attacker, "Attacker");

        retirementfundChallenge = new RetirementFundChallenge{value: 1 ether}(attacker);
        // comment out due to in-abillity to deploy with sent ether
        // DeployRetirementFundScript.run();
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
