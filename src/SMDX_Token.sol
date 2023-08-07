// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract SMDX_Token is ERC20 {
    constructor() ERC20("SMDX_Token", "SMDX") {
        _mint(msg.sender, 1000 * (10 ** 18));
    }
}
