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
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract SomidaxAuction is Ownable {
    constructor() {}

    //////////////////////
    ////Struct     ///
    ////////////////
    struct AuctionNFT {
        address nft;
        uint256 tokenId;
        address creator;
        address payToken;
        uint256 initialPrice;
        uint256 minBid;
        uint256 startTime;
        uint256 endTime;
        address lastBidder;
        uint256 heighestBid;
        address winner;
        bool success;
    }

    struct BiderDetails {
        address biderAddress;
        uint256 timeBided;
        uint256 amountBided;
    }
    // user balance to each of the token

    //////////////////////
    ////Mappings     ///
    ////////////////

    // nft => tokenId => acuton struct
    mapping(address => mapping(uint256 => AuctionNFT)) private _auctionNfts;

    // auciton index => bidding counts => bidder address => bid price
    mapping(uint256 => mapping(uint256 => mapping(address => uint256)))
        private _bidPrices;
    mapping(uint256 => BiderDetails[]) private _biders;

    //////////////////////
    ////Events     ///
    ////////////////
    event CreatedAuction(
        address indexed nft,
        uint256 indexed tokenId,
        address payToken,
        uint256 price,
        uint256 minBid,
        uint256 startTime,
        uint256 endTime,
        address indexed creator,
        uint256 chainid
    );
    event PlacedBid(
        address indexed nft,
        uint256 indexed tokenId,
        address payToken,
        uint256 bidPrice,
        address indexed bidder,
        uint256 chainid
    );

    event ResultedAuction(
        address indexed nft,
        uint256 indexed tokenId,
        address creator,
        address indexed winner,
        uint256 price,
        address caller,
        uint256 chainid
    );

    //////////////////////
    ////Modifiers     ///
    ////////////////
    modifier isAuction(address _nft, uint256 _tokenId) {
        _isAuction(_nft, _tokenId);
        _;
    }

    modifier isNotAuction(address _nft, uint256 _tokenId) {
        _isNotAuction(_nft, _tokenId);
        _;
    }

    //////////////////////
    ////Functions     ///
    ////////////////
    // @notice Create autcion
    function createAuction(
        address _nft,
        uint256 _tokenId,
        address _payToken,
        uint256 _price,
        uint256 _minBid,
        uint256 _startTime,
        uint256 _endTime
    ) external isNotAuction(_nft, _tokenId) {
        // Get the NFT contract instance
        IERC721 nft = IERC721(_nft);

        // Check if the caller is the NFT owner (auction creator)
        require(
            nft.ownerOf(_tokenId) == msg.sender,
            "You are not the NFT owner"
        );

        // Check if the auction end time is greater than the start time
        require(_endTime > _startTime, "Invalid end time");

        // Transfer the NFT to the contract to be held during the auction
        nft.transferFrom(msg.sender, address(this), _tokenId);

        // Store the auction details in the mapping
        _auctionNfts[_nft][_tokenId] = AuctionNFT({
            nft: _nft,
            tokenId: _tokenId,
            creator: msg.sender,
            payToken: _payToken,
            initialPrice: _price,
            minBid: _minBid,
            startTime: _startTime,
            endTime: _endTime,
            lastBidder: address(0),
            heighestBid: _price,
            winner: address(0),
            success: false
        });

        // Emit the CreatedAuction event to notify about the successful auction creation
        emit CreatedAuction(
            _nft,
            _tokenId,
            _payToken,
            _price,
            _minBid,
            _startTime,
            _endTime,
            msg.sender,
            block.chainid
        );
    }

    function cancelAuction(
        address _nft,
        uint256 _tokenId
    ) external isAuction(_nft, _tokenId) {
        AuctionNFT memory auction = _auctionNfts[_nft][_tokenId];
        require(auction.creator == msg.sender, "not auction creator");
        require(block.timestamp < auction.startTime, "auction already started");
        require(auction.lastBidder == address(0), "already have bidder");

        IERC721 nft = IERC721(_nft);
        nft.transferFrom(address(this), msg.sender, _tokenId);
        delete _auctionNfts[_nft][_tokenId];
        delete _biders[_tokenId];
    }

    // @notice Bid place auction
    function bidPlace(
        address _nft,
        uint256 _tokenId,
        uint256 _bidPrice
    ) external isAuction(_nft, _tokenId) {
        require(
            block.timestamp >= _auctionNfts[_nft][_tokenId].startTime,
            "auction not start"
        );
        require(
            block.timestamp <= _auctionNfts[_nft][_tokenId].endTime,
            "auction ended"
        );
        require(
            _bidPrice >=
                _auctionNfts[_nft][_tokenId].heighestBid +
                    _auctionNfts[_nft][_tokenId].minBid,
            "less than min bid price"
        );

        AuctionNFT storage auction = _auctionNfts[_nft][_tokenId];
        IERC20 payToken = IERC20(auction.payToken);
        payToken.transferFrom(msg.sender, address(this), _bidPrice);

        if (auction.lastBidder != address(0)) {
            address lastBidder = auction.lastBidder;
            uint256 lastBidPrice = auction.heighestBid;

            // Transfer back to last bidder
            payToken.transfer(lastBidder, lastBidPrice);
        }

        // Set new heighest bid price
        auction.lastBidder = msg.sender;
        auction.heighestBid = _bidPrice;

        BiderDetails[] storage bidersAddressesForTokenId = _biders[_tokenId];
        bidersAddressesForTokenId.push(
            BiderDetails(msg.sender, block.timestamp, _bidPrice)
        );

        emit PlacedBid(
            _nft,
            _tokenId,
            auction.payToken,
            _bidPrice,
            msg.sender,
            block.chainid
        );
    }

    // @notice Result auction, can call by auction creator, heighest bidder, or marketplace owner only!
    function resultAuction(address _nft, uint256 _tokenId) external {
        require(!_auctionNfts[_nft][_tokenId].success, "already resulted");
        require(
            msg.sender == owner() ||
                msg.sender == _auctionNfts[_nft][_tokenId].creator ||
                msg.sender == _auctionNfts[_nft][_tokenId].lastBidder,
            "not creator, winner, or owner"
        );
        require(
            block.timestamp > _auctionNfts[_nft][_tokenId].endTime,
            "auction not ended"
        );

        AuctionNFT storage auction = _auctionNfts[_nft][_tokenId];
        IERC20 payToken = IERC20(auction.payToken);
        IERC721 nft = IERC721(auction.nft);

        auction.success = true;
        auction.winner = auction.lastBidder;

        uint256 heighestBid = auction.heighestBid;
        uint256 totalPrice = heighestBid;

        // uint256 platformFeeTotal = calculatePlatformFee(heighestBid);
        // payToken.transfer(feeRecipient, platformFeeTotal);

        // Transfer to auction creator
        payToken.transfer(auction.creator, totalPrice);

        // Transfer NFT to the winner
        nft.transferFrom(address(this), auction.lastBidder, auction.tokenId);

        emit ResultedAuction(
            _nft,
            _tokenId,
            auction.creator,
            auction.lastBidder,
            auction.heighestBid,
            msg.sender,
            block.chainid
        );
    }

    function _isNotAuction(address _nft, uint256 _tokenId) private view {
        AuctionNFT memory auction = _auctionNfts[_nft][_tokenId];
        require(
            auction.nft == address(0) || auction.success,
            "auction already created"
        );
    }

    function _isAuction(address _nft, uint256 _tokenId) private view {
        AuctionNFT memory auction = _auctionNfts[_nft][_tokenId];
        require(
            auction.nft != address(0) && !auction.success,
            "auction already created"
        );
    }

    //////////////////////////////////////
    ///GETTERS: VIEW AND PURE Functions///////
    ///////////////////////////////////////
    function getBidders(
        uint256 _tokenId
    ) public view returns (BiderDetails[] memory) {
        return _biders[_tokenId];
    }
}
