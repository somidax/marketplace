// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Somidax__Funds} from "../src/Somidax__Funds.sol";

contract Deploy__Somidax__Funds is Script {
    constructor() {}

    Somidax__Funds smdx_funds;

    function run() external returns (Somidax__Funds smdx_addr) {
        vm.startBroadcast();
        smdx_funds = new Somidax__Funds();
        vm.stopBroadcast();
        return smdx_funds;
    }
}
