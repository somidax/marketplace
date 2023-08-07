// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Deploy__SMDX_Tokens} from "../../script/Deploy__SMDX_Tokens.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract SMDX_TokenTest is Test {
    Deploy__SMDX_Tokens smdxToken;

    function setUp() external {
        Deploy__SMDX_Tokens deploy = new Deploy__SMDX_Tokens();
        smdxToken = deploy.run();
    }
}
