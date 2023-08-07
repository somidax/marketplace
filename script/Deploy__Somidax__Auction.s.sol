// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Somidax__Auction} from "../src/Somidax__Auction.sol";

contract Deploy__SMDX_Auction is Script {
    constructor() {}

    Somidax__Auction somidax__auction;

    function run() external returns (Somidax__Auction smdx_addr) {
        vm.startBroadcast();
        somidax__auction = new Somidax__Auction();
        vm.stopBroadcast();
        return somidax__auction;
    }
}
