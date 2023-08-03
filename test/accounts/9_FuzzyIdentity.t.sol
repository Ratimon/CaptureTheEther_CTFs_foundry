// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

import {Test, console} from "@forge-std/Test.sol";

import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

import {DeployFuzzyIdentityScript} from "@script/accounts/9_DeployFuzzyIdentity.s.sol";
import {FuzzyIdentityChallenge} from "@main/accounts/FuzzyIdentity.sol";
import {FuzzyIdentityAttacker} from "@main/accounts/FuzzyIdentityAttacker.sol";

contract FuzzyIdentityTest is Test, DeployFuzzyIdentityScript {
    string mnemonic = "test test test test test test test test test test test junk";
    uint256 deployerPrivateKey = vm.deriveKey(mnemonic, "m/44'/60'/0'/0/", 1); //  address = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8
    address deployer = vm.addr(deployerPrivateKey);

    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY_9");
    address public attacker = vm.addr(attackerPrivateKey);

    FuzzyIdentityAttacker fuzzyIdentityAttacker;

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

        // run script to brute forceå
        fuzzyIdentityAttacker = new FuzzyIdentityAttacker();
        console.log('attacker address is ', attacker);
        console.log('contract address is ', address(fuzzyIdentityAttacker));

        // vm.setNonce(attacker, 0);
        fuzzyIdentityAttacker.attack(address(fuzzyIdentityChallenge));
        assertTrue(fuzzyIdentityChallenge.isComplete(), "Challenge is not complete");

        // // EvmError: MemoryLimitOOG
        // uint256 i;
        // while (!fuzzyIdentityChallenge.isComplete()) {


        //     bytes32 salt = bytes32(i);
        //     address attackerAddr = Create2.deploy(0, salt, vm.getCode("FuzzyIdentityAttacker.sol:FuzzyIdentityAttacker"));
        //     // bytes32 codeHash = keccak256(abi.encodePacked(type(FuzzyIdentityAttacker).creationCode));

        //     bool isAddressBadCode = isBadCode(attackerAddr);

        //     if (isAddressBadCode) {
        //         console.log('the salt is bad code!!',i);
        //         console.log('the bad code address is ',attackerAddr);
        //         FuzzyIdentityAttacker(attackerAddr).attack(address(fuzzyIdentityChallenge));
        //     }

        //     console.log('keep finding!! the salt is',i);
            
        //     i++;
        // }


       

        vm.stopPrank();
    }

    // function isBadCode(address _addr) internal pure returns (bool) {
    //     bytes20 addr = bytes20(_addr);
    //     bytes20 id = hex"000000000000000000000000000000000badc0de";
    //     bytes20 mask = hex"000000000000000000000000000000000fffffff";

    //     for (uint256 i = 0; i < 34; i++) {
    //         if (addr & mask == id) {
    //             return true;
    //         }
    //         mask <<= 4;
    //         id <<= 4;
    //     }

    //     return false;
    // }
}
