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
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error SomidaxFundsNotEnoughAmountSent(
    uint256 amount,
    address sender,
    string receiver
);
error Somidax__Funds__AmountMustBeMorethan0(uint256 amount);

contract SomidaxFunds is Ownable(msg.sender) {
    constructor() {}

    /////////////////////
    // STRUCTS //
    /////////////////////

    /////////////////////
    // MAPPING //
    /////////////////////
    mapping(address token => mapping(address userAddress => uint256)) _balance;
    /////////////////////
    // EVENTS //
    /////////////////////ba

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
        uint256 senderBalance = _balance[payToken][msg.sender];
        require(senderBalance >= amount, "Insufficient balance");

        // Update sender and receiver balances
        _balance[payToken][msg.sender] -= amount;
        _balance[payToken][receiver] += amount;

        // Emit the Transfer event with details of the transaction
        emit Transfer(receiver, msg.sender, amount, payToken);
    }

    // Add functions for deposit, withdraw, and buying coffee as needed.

    function depositEth() external payable {
        require(msg.value > 0, "Amount must be greater than 0");
        address payToken = 0x0000000000000000000000000000000000000000;

        // Transfer Ether to the contract address
        (bool sent, ) = address(this).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        // Update the user's Ether balance in the mapping
        _balance[payToken][msg.sender] += msg.value;

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
        _balance[payToken][msg.sender] += amount;
        // Emit the Deposit event with details of the transaction
        emit Deposit(msg.sender, payToken, amount);
    }

    function withdrawEth(uint256 amount) public {
        uint256 etherBalance = _balance[address(0)][msg.sender];
        // Check if the user has sufficient Ether balance
        require(etherBalance >= amount, "Insufficient Ether balance");

        // Transfer the Ether to the user
        require(amount > 0, "Amount must be greater than 0");
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send Ether");

        // Update the user's Ether balance after the withdrawal
        _balance[address(0)][msg.sender] -= amount;
        // Emit the Withdraw event with details of the transaction
        emit Withdraw(msg.sender, amount);
    }

    function withdrawToken(uint256 amount, address payToken) external {
        // Function to withdraw tokens or Ether (payToken == address(0))

        // Withdraw ERC-20 tokens
        uint256 tokenBalance = _balance[payToken][msg.sender];
        require(amount > 0, "Amount must be greater than 0");
        require(tokenBalance >= amount, "Insufficient token balance");

        // Transfer the tokens to the sender
        IERC20 token = IERC20(payToken);

        require(token.transfer(msg.sender, amount), "Token transfer failed");

        // Update the balance
        _balance[payToken][msg.sender] -= amount;

        // Emit the Withdraw event with details of the transaction
        emit Withdraw(msg.sender, amount);
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
            _balance[payToken][receiverAddr] += amount;

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
            _balance[payToken][receiverAddr] += amount;

            // Emit the BuyCoffee event with details of the transaction
            emit BuyCoffee(receiverAddr, msg.sender, amount);
        }
    }

    function increaseUserFunds(
        address token,
        address userAddress,
        uint256 amount
    ) external {
        require(_balance[userAddress][token] >= amount, "Not enough funds");
        if (amount <= 0) {
            revert Somidax__Funds__AmountMustBeMorethan0(amount);
        }
        _balance[token][userAddress] += amount;
    }
 
    function decreaseUserFunds(
        address token,
        address userAddress,
        uint256 amount
    ) external {

        if (amount <= 0) {
            revert Somidax__Funds__AmountMustBeMorethan0(amount);
        }
        _balance[token][userAddress] -= amount;
    }

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    ////////////////////////////
    //GETTERS VIEW AND PURE FUNCTIONS  ////
    ////////////////////////////
    function getUserBalance(address token) external view returns (uint256) {
        // Function to get the Tokens in the Contract
        return _balance[token][msg.sender];
    }
}
