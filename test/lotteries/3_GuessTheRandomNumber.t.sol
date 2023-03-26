// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Test} from "@forge-std/Test.sol";

import {DeployGuessTheRandomNumberScript} from "@script/lotteries/3_DeployGuessTheRandomNumber.s.sol";
import {GuessTheRandomNumberChallenge} from "@main/lotteries/3_GuessTheRandomNumber.sol";

interface IGuessTheNumber {
    function answer() external returns(uint8);
}

contract GuessTheRandomNumberTest is Test, DeployGuessTheRandomNumberScript {

    address public deployer;
    address public attacker = address(11);

    function setUp() public {

        deployer = msg.sender;

        vm.deal(deployer, 2 ether);
        vm.deal(attacker, 2 ether);

        vm.label(deployer, "Deployer");
        vm.label(attacker, "Attacker");

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

        uint8 answer = uint8(
            uint256(  
                vm.load(address(guesstherandomnumberChallenge), 0)
            )
        );

        guesstherandomnumberChallenge.guess{value: 1 ether}(answer);

        assertEq( guesstherandomnumberChallenge.isComplete(), true);
       
        vm.stopPrank(  );
    }


}