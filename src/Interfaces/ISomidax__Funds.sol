// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface ISomidax__Funds {
    function increaseUserFunds(
        address token,
        address userAddress,
        uint256 amount
    ) external;
}
