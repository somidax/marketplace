// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SMDX_Token} from "../src/SMDX_Token.sol";

contract Deploy__SMDX_Tokens is Script {
    constructor() {}

    SMDX_Token smdx_Token;

    function run() public returns (SMDX_Token smdx_addr) {
        vm.startBroadcast();
        smdx_Token = new SMDX_Token();
        vm.stopBroadcast();
        return smdx_Token;
    }
}
