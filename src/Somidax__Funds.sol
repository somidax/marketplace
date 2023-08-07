// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

error Somidax__Funds__NotEnoughAmountSent(
    uint256 amount,
    address sender,
    string receiver
);
error Somidax__Funds__AmountMustBeMorethan0(uint256 amount);

contract Somidax__Funds is Ownable {
    constructor() {}

    /////////////////////
    // STRUCTS //
    /////////////////////

    /////////////////////
    // MAPPING //
    /////////////////////
    mapping(address token => mapping(address userAddress => uint256)) balance;
    /////////////////////
    // EVENTS //
    /////////////////////

    event Transfer(
        address indexed receiver,
        address indexed sender,
        uint256 amount,
        address payToken
    );
    event Deposit(
        address indexed depositAddress,
        address payToken,
        uint256 amount
    );
    event Withdraw(address indexed withdrawalAddress, uint256 amount);

    event BuyCoffee(
        address indexed userAddress,
        address indexed sender,
        uint256 smdxAmout
    );

    ////////////////////////////
    //PUBLIC FUNCTIONS  ////
    ////////////////////////////

    function transfer(
        address receiver,
        uint256 amount,
        address payToken
    ) external {
        require(amount > 0, "Amount must be greater than 0");

        // Check if the sender has sufficient balance
        uint256 senderBalance = balance[payToken][msg.sender];
        require(senderBalance >= amount, "Insufficient balance");

        // Update sender and receiver balances
        balance[payToken][msg.sender] -= amount;
        balance[payToken][receiver] += amount;

        // Emit the Transfer event with details of the transaction
        emit Transfer(receiver, msg.sender, amount, payToken);
    }

    // Add functions for deposit, withdraw, and buying coffee as needed.

    function depositEth(address payToken) external payable {
        require(msg.value > 0, "Amount must be greater than 0");

        // Transfer Ether to the contract address
        (bool sent, ) = payable(address(this)).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        // Update the user's Ether balance in the mapping
        balance[payToken][msg.sender] += msg.value;

        // Emit the Deposit event with details of the transaction
        emit Deposit(msg.sender, payToken, msg.value);
    }

    function depositTokens(uint256 amount, address payToken) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer tokens from the sender to the contract address
        IERC20 token = IERC20(payToken);
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );

        // Update the user's token balance in the mapping
        balance[payToken][msg.sender] += amount;
        // Emit the Deposit event with details of the transaction
        emit Deposit(msg.sender, payToken, amount);
    }

    function withdrawEth(uint256 amount) external {
        uint256 etherBalance = balance[address(0)][msg.sender];
        // Check if the user has sufficient Ether balance
        require(etherBalance >= amount, "Insufficient Ether balance");

        // Transfer the Ether to the user
        require(amount > 0, "Amount must be greater than 0");
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send Ether");

        // Update the user's Ether balance after the withdrawal
        balance[address(0)][msg.sender] -= amount;
        // Emit the Withdraw event with details of the transaction
        emit Withdraw(msg.sender, amount);
    }

    function withdrawToken(uint256 amount, address payToken) external {
        // Function to withdraw tokens or Ether (payToken == address(0))

        if (payToken == address(0)) {
            // Withdraw Ether (ETH)
            uint256 etherBalance = balance[payToken][msg.sender];
            require(etherBalance >= amount, "Insufficient Ether balance");

            // Transfer the Ether to the sender
            require(amount > 0, "Amount must be greater than 0");
            (bool sent, ) = payable(msg.sender).call{value: amount}("");
            require(sent, "Failed to send Ether");

            // Update the balance
            balance[payToken][msg.sender] -= amount;
            // Emit the Withdraw event with details of the transaction
            emit Withdraw(msg.sender, amount);
        } else {
            // Withdraw ERC-20 tokens
            uint256 tokenBalance = balance[payToken][msg.sender];
            require(amount > 0, "Amount must be greater than 0");
            require(tokenBalance >= amount, "Insufficient token balance");

            // Transfer the tokens to the sender
            IERC20 token = IERC20(payToken);

            require(
                token.transfer(msg.sender, amount),
                "Token transfer failed"
            );

            // Update the balance
            balance[payToken][msg.sender] -= amount;

            // Emit the Withdraw event with details of the transaction
            emit Withdraw(msg.sender, amount);
        }
    }

    function buyCoffee(
        address receiverAddr,
        uint256 amount,
        address payToken
    ) public {
        if (payToken == address(0)) {
            // Send Ether (ETH) to the contract address
            require(amount > 0, "Amount must be greater than 0");
            (bool sent, ) = payable(address(this)).call{value: amount}("");
            require(sent, "Failed to send Ether");

            // Increase the ETH balance of the receiver
            balance[payToken][receiverAddr] += amount;

            // Emit the BuyCoffee event with details of the transaction
            emit BuyCoffee(receiverAddr, msg.sender, amount);
        } else {
            // Transfer tokens from the sender to the contract address
            IERC20 token = IERC20(payToken);
            require(amount > 0, "Amount must be greater than 0");
            require(
                token.transferFrom(msg.sender, address(this), amount),
                "Token transfer failed"
            );

            // Increase the token balance of the receiver
            balance[payToken][receiverAddr] += amount;

            // Emit the BuyCoffee event with details of the transaction
            emit BuyCoffee(receiverAddr, msg.sender, amount);
        }
    }

    function increaseUserFunds(
        address token,
        address userAddress,
        uint256 amount
    ) external {
        if (amount <= 0) {
            revert Somidax__Funds__AmountMustBeMorethan0(amount);
        }
        balance[token][userAddress] += amount;
    }

    ////////////////////////////
    //GETTERS VIEW AND PURE FUNCTIONS  ////
    ////////////////////////////
    function getUserBalance(address token) external view returns (uint256) {
        // Function to get the Tokens in the Contract
        return balance[token][msg.sender];
    }
}
