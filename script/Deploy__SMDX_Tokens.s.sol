// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SMDXToken} from "../src/SMDX_Token.sol";

contract DeploySMDXTokens is Script {
    constructor() {}

    SMDXToken _smdxToken;

    function run() public returns (SMDXToken smdxaddr) {
        vm.startBroadcast();
        _smdxToken = new SMDXToken();
        vm.stopBroadcast();
        return _smdxToken;
    }
}
