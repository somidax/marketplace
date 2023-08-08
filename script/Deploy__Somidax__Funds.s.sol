// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SomidaxFunds} from "../src/Somidax__Funds.sol";

contract DeploySomidaxFunds is Script {
    constructor() {}

    SomidaxFunds _smdxfunds;

    function run() external returns (SomidaxFunds _smdxAddr) {
        vm.startBroadcast();
        _smdxfunds = new SomidaxFunds();
        vm.stopBroadcast();
        return _smdxfunds;
    }
}
