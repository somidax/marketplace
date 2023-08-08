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

import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ISomidax__Funds} from "./Interfaces/ISomidax__Funds.sol";

error SomidaxMarketPlace__NFTAlreadySold();

contract SomidaxMarketPlace is Ownable {
    constructor() {}

    ///////////////
    //// STRUCT ////
    ///////////////
    struct ListNFT {
        address nft;
        uint256 tokenId;
        address seller;
        address payToken;
        uint256 price;
        bool sold;
    }

    ///////////////
    //// Mapping ////
    ///////////////
    mapping(address => mapping(uint256 => ListNFT)) internal _listNfts;

    ///////////////
    //// Events ////
    ///////////////

    event ListedNFT(
        address indexed nft,
        uint256 indexed tokenId,
        address payToken,
        uint256 price,
        address indexed seller
    );
    event BoughtNFT(
        address indexed nft,
        uint256 indexed tokenId,
        address payToken,
        uint256 price,
        address seller,
        address indexed buyer
    );

    event TransferNFT(
        address indexed nft,
        uint256 indexed tokenId,
        address indexed sender,
        address receiver
    );

    ///////////////
    //// Functions ////
    ///////////////
    function listNFT(
        address _nft,
        uint256 _tokenId,
        address _payToken,
        uint256 _price
    ) public {
        IERC721 nft = IERC721(_nft);
        require(nft.ownerOf(_tokenId) == msg.sender, "not nft owner");
        nft.transferFrom(msg.sender, address(this), _tokenId);

        _listNfts[_nft][_tokenId] = ListNFT({
            nft: _nft,
            tokenId: _tokenId,
            seller: msg.sender,
            payToken: _payToken,
            price: _price,
            sold: false
        });

        emit ListedNFT(_nft, _tokenId, _payToken, _price, msg.sender);
    }

    function buyNFT(
        uint256 _price,
        uint256 _tokenId,
        address _nft,
        address _payToken,
        address somidaxFundAddr
    ) public {
        // Retrieve the NFT listing from the mapping using contract address and token ID
        ListNFT storage listNft = _listNfts[_nft][_tokenId];

        // Check if the payToken is valid and matches the NFT listing
        require(
            _payToken != address(0) && _payToken == listNft.payToken,
            "Invalid pay token"
        );

        // Check if the amount sent is sufficient to purchase the NFT
        require(listNft.price >= _price, "Not sufficient amount sent");

        // Check if the NFT is not already sold
        require(listNft.sold != true, "NFT already sold");

        // Transfer the payment to the NFT seller using the somidaxFundAddr contract
        ISomidax__Funds(somidaxFundAddr).increaseUserFunds(
            _payToken,
            listNft.seller,
            _price
        );

        // Transfer the NFT to the buyer
        IERC721(listNft.nft).safeTransferFrom(
            address(this),
            msg.sender,
            listNft.tokenId
        );

        // Mark the NFT as sold
        listNft.sold = true;

        // Emit the BoughtNFT event to notify about the successful purchase
        emit BoughtNFT(
            listNft.nft,
            listNft.tokenId,
            listNft.payToken,
            _price,
            listNft.seller,
            msg.sender
        );

        // Delete the NFT listing from the marketplace after the event is emitted
        delete _listNfts[_nft][_tokenId];
    }

    function cancelListing(uint256 _tokenId, address _nft) public {
        ListNFT memory listedNft = _listNfts[msg.sender][_tokenId];
        if (listedNft.sold == true) {
            revert SomidaxMarketPlace__NFTAlreadySold();
        }
        IERC721 nft = IERC721(_nft);
        require(
            nft.ownerOf(_tokenId) == msg.sender,
            "Only Owners can cancel NFT"
        );

        delete _listNfts[msg.sender][_tokenId];
    }

    function transferNFT(
        uint256 _tokenId,
        address _nft,
        address receiver
    ) public {
        IERC721 nft = IERC721(_nft);
        address owner = nft.ownerOf(_tokenId);
        require(owner == msg.sender, "Only Owners can Transfer Their NFT");
        require(
            receiver != address(0),
            "Cant Not Transfer NFT to a zero address"
        );
        require(owner != owner, "Cant Not Transfer NFT to Your self");

        nft.transferFrom(msg.sender, receiver, _tokenId);

        emit TransferNFT(_nft, _tokenId, msg.sender, receiver);
    }

    //////////////////////////////////////
    //// GETTERS: view and pure functions ////
    //////////////////////////////////////
}
