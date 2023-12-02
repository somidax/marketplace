// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {SomidaxGame} from "../src/Somidax__Game.sol";

contract DeploySomidaxGame is Script {
    constructor() {}

    uint64 public _subscriptionId = 6980;
    address public _cordinatorAddr = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    SomidaxGame _somidaxGame;

    function run() external returns (SomidaxGame smdxGameAddr) {
        vm.startBroadcast();
        _somidaxGame = new SomidaxGame(_subscriptionId);
        vm.stopBroadcast();
        return _somidaxGame;
    }
}
