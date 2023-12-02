// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity ^0.8.7;

contract SomidaxGame {
    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }

    ////// STRUCT /////
    struct Player {
        address player;
        uint256 amount;
    }

    ////// STATE DECLARATIONS //////////////////
    uint256 private winnersCount = 0;
    uint256 private totalMoneyEarned = 0;

    /////////// EVENTS ///////////////////
    event RecentWinner(string, address, uint256, address);
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    /////////// MAPPINGS ///////////////////
    mapping(string => Player[]) recentWiinners;
    mapping(string => uint256) noOfPlayers;
    mapping(string => Player[]) players;

    constructor() {}

    function addPlayer(
        uint256 _price,
        string memory _type
    ) public {
        Player[] storage _players = players[_type];
        _players.push(Player({player: msg.sender, amount: _price}));
        noOfPlayers[_type]++;
    }

    function recentWiinner(
        string memory typeGame,
        address somidaxFundAddr,
        uint256 _price,
        address _payToken
    ) external {
        // add the user to the winners array
        // add money to the user account

        Player[] storage winners = recentWiinners[typeGame];
        winners.push(Player({player: msg.sender, amount: _price}));
        winnersCount++;
        totalMoneyEarned += _price;
        emit RecentWinner(typeGame, somidaxFundAddr, _price, _payToken);
    }

    /////////// GETTERS (PURE AND VIEW) ///////////////////
    function getTotalMoneyEarned() external view returns (uint256) {
        return totalMoneyEarned;
    }

    function getTotalWinners() external view returns (uint256) {
        return winnersCount;
    }

    function getNoOfPlayers(
                string memory _type
    ) external view returns (uint256) {
        return noOfPlayers[_type];
    }

    function getPlayers(
                string memory _type
    ) external view returns (Player[] memory _players) {
        return players[_type];
    }

    function getWinners(
        string memory _type
    ) external view returns (Player[] memory _players) {
        return recentWiinners[_type];
    }
}

interface ISomidax__Funds {
    function increaseUserFunds(
        address token,
        address userAddress,
        uint256 amount
    ) external;

    function decreaseUserFunds(
        address token,
        address userAddress,
        uint256 amount
    ) external;
}
