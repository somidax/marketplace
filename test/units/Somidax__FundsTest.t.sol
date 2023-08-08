// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "../../src/Somidax__Funds.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract SomidaxFundsTest is Test {
    SomidaxFunds _funds;

    address public collins = makeAddr("collins");
    address public david = makeAddr("david");

    address public payToken = address(0);
    uint256 public amount = 1 * (10 ** 18);

    function setUp() public {
        _funds = new SomidaxFunds();
    }

    function testAmountMustBeMoreThan0() public {
        vm.expectRevert("Amount must be greater than 0");
        _funds.transfer(david, amount, payToken);
    }

    // Not working
    function testInsufficientBalance() public {
        vm.prank(collins);
        vm.deal(collins, 10 ether);
        _funds.depositEth{value: amount}(payToken);

        console.log(_funds.getUserBalance(payToken));

        vm.expectRevert("Insufficient balance");
        _funds.transfer(david, amount + amount, payToken);
    }
}
