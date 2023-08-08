// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SomidaxMarketPlace} from "../src/Somidax__MarketPlace.sol";

contract DeploySomidaxMarketPlace is Script {
    constructor() {}

    SomidaxMarketPlace _somidaxmarketPlace;

    function run() external returns (SomidaxMarketPlace smdxaddr) {
        vm.startBroadcast();
        _somidaxmarketPlace = new SomidaxMarketPlace();
        vm.stopBroadcast();
        return _somidaxmarketPlace;
    }
}
