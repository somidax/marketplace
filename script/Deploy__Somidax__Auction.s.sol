// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SomidaxAuction} from "../src/Somidax__Auction.sol";

contract DeploySMDXAuction is Script {
    constructor() {}

    SomidaxAuction _somidaxauction;

    function run() external returns (SomidaxAuction smdxaddr) {
        vm.startBroadcast();
        _somidaxauction = new SomidaxAuction();
        vm.stopBroadcast();
        return _somidaxauction;
    }
}
