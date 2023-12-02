// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {SomidaxNFT} from "../src/SMDX__SomidaxNFT.sol";

contract DeploySomidaxNFT is Script {
    constructor() {}

    SomidaxNFT _somidaxNFT;

    function run() external returns (SomidaxNFT smdxaddr) {
        vm.startBroadcast();
        _somidaxNFT = new SomidaxNFT();
        vm.stopBroadcast();
        return _somidaxNFT;
    }
}
