// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Somidax__MarketPlace} from "../src/Somidax__MarketPlace.sol";

contract Deploy__Somidax__MarketPlace is Script {
    constructor() {}

    Somidax__MarketPlace somidax__marketPlace;

    function run() external returns (Somidax__MarketPlace smdx_addr) {
        vm.startBroadcast();
        somidax__marketPlace = new Somidax__MarketPlace();
        vm.stopBroadcast();
        return somidax__marketPlace;
    }
}
