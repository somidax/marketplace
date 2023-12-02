// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SMDXToken} from "../../src/SMDX_Token.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract SMDXTokenTest is Test {
    SMDXToken _smdxToken;

    address public deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;
    address public collins = makeAddr("collins");

    function setUp() external {
        _smdxToken = new SMDXToken();
    }

    function testNameAndSymbol() public {
        string memory name = "SMDX_Token";
        string memory token = "SMDX";

        assertEq(_smdxToken.name(), name);
        assertEq(_smdxToken.symbol(), token);
    }

    function testTotalSupply() public {
        uint256 totalSupply = 1000 * (10 ** 18);

        assertEq(_smdxToken.totalSupply(), totalSupply);
    }

    function testDeployerAmount() public {
        uint256 balance = 1000 * (10 ** 18);

        assertEq(_smdxToken.balanceOf(address(this)), balance);
    }

    // Not working
    // function testTrFunction() public {
    //     vm.prank(collins);
    //     uint256 trAmount = 20 * (10 ** 18);

    //     _smdxToken.transfer(collins, trAmount);
    //     console.log(_smdxToken.transfer(collins, trAmount));
    //     assertEq(_smdxToken.balanceOf(collins), trAmount);
    // }
}
