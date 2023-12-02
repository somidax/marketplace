// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {SomidaxNFT} from "../../src/SMDX__SomidaxNFT.sol";
import {SomidaxMarketPlace} from "../../src/Somidax__MarketPlace.sol";
import {SMDXToken} from "../../src/SMDX_Token.sol";
import {SomidaxFunds} from "../../src/Somidax__Funds.sol";

contract SMDXNFTTest is Test {
    SomidaxNFT _somidaxNFT;
    SomidaxMarketPlace _marketplace;
    SMDXToken _token;
    SomidaxFunds _funds;

    address public collins = makeAddr("collins");
    address public david = makeAddr("david");

    string _uri = "https://chat.openai.com";
    uint256 constant _PRICE = 100000000000000000;

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

    function setUp() public {
        _somidaxNFT = new SomidaxNFT();
        _marketplace = new SomidaxMarketPlace();
        _token = new SMDXToken();
        _funds = new SomidaxFunds();
    }

    function testOwnerOf() public {
        vm.prank(collins);
        _somidaxNFT.mint(collins, _uri);

        address owner = _somidaxNFT.ownerOf(0);
        assertEq(address(collins), owner);
    }

    function testMintAndApproveNFT() public {
        vm.prank(collins);
        _somidaxNFT.mint(collins, _uri);

        vm.prank(collins);
        _somidaxNFT.approve(address(_marketplace), 0);

        console.log("minted and approve");

        // Address to check for approval
        address toCheck = address(_marketplace); // The address you want to check

        // Get the approved address for a specific NFT token
        address approvedAddress = _somidaxNFT.getApproved(0); // Replace tokenId with the NFT's token ID

        // Perform assertions
        assertEq(approvedAddress, toCheck);
    }

    function testListNft() public {
        vm.prank(collins);
        _somidaxNFT.mint(collins, _uri);

        vm.prank(collins);
        _somidaxNFT.approve(address(_marketplace), 0);

        vm.expectEmit(false, false, false, false);

        emit ListedNFT(
            address(_marketplace),
            0,
            address(_token),
            _PRICE,
            address(collins)
        );
        vm.prank(collins);
        _marketplace.listNFT(address(_somidaxNFT), 0, address(_token), _PRICE);
    }

    function testBuyNft() public {
        vm.prank(collins);
        _somidaxNFT.mint(collins, _uri);

        vm.prank(collins);
        _somidaxNFT.approve(address(_marketplace), 0);

        vm.prank(collins);
        _marketplace.listNFT(address(_somidaxNFT), 0, address(_token), _PRICE);

        // TRANSFER FUNCTION
        // _token.tran.(address(david), 100);

        vm.expectEmit(false, false, false, false);

        emit BoughtNFT(
            address(_somidaxNFT),
            0,
            address(_token),
            _PRICE,
            address(collins),
            address(david)
        );

        vm.prank(david);
        _marketplace.buyNFT(
            _PRICE,
            0,
            address(_somidaxNFT),
            address(_token),
            address(_funds)
        );
    }

    // function test
}
