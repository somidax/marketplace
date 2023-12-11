// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

// /**
//  * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
//  * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
//  * DO NOT USE THIS CODE IN PRODUCTION.
//  */
 interface ISomidaxNFT {
     function mint(address to, string memory uri) external returns (uint256);
     function _burn(uint256 tokenId) external;
     function tokenURI(uint256 tokenId) external view returns (string memory);
     function getCurrentTokenId() external view returns (uint256);
     function supportsInterface(bytes4 interfaceId) external view returns (bool);
 }

 contract DestinationMinter is CCIPReceiver {
     ISomidaxNFT nft;

     event MintCallSuccessfull();

     constructor(address router, address nftAddress) CCIPReceiver(router) {
         nft = ISomidaxNFT(nftAddress);
     }

     function _ccipReceive(
        Client.Any2EVMMessage memory message
     ) internal override {
         (bool success, ) = address(nft).call(message.data);
         require(success);
        emit MintCallSuccessfull();
     }
}
