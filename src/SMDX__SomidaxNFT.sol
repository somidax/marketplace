// SPDX-License-Identifier: MIT
// Author: Jaydenomidax
pragma solidity ^0.8.18;

// Importing necessary contracts from OpenZeppelin, a library for secure smart contract development.
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/Counters.sol";

// The contract inherits from the ERC721, ERC721URIStorage, ERC721Burnable, and Ownable contracts.
contract SomidaxNFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    // Using the Counters library for managing token IDs.
    using Counters for Counters.Counter;

    // A counter for generating unique token IDs.
    Counters.Counter private _tokenIdCounter;

    // The constructor sets the name and symbol of the token using the ERC721 constructor.
    constructor() ERC721("Somidax", "SMDX") {}

    // Function to mint a new NFT. The function takes the recipient address and the token URI as parameters.
    function mint(address to, string memory uri) public returns (uint256) {
        // Getting the current token ID.
        uint256 tokenId = _tokenIdCounter.current();
        // Incrementing the token ID counter.
        _tokenIdCounter.increment();
        // Minting the new token and assigning it to the recipient.
        _safeMint(to, tokenId);
        // Setting the token URI of the minted token.
        _setTokenURI(tokenId, uri);

        // Returning the token ID of the minted token.
        return tokenId;
    }

    // Overriding the _burn function from the ERC721 contract to be able to burn tokens.
    function _burn(
        uint256 tokenId
    ) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // Overriding the tokenURI function from the ERC721 contract to return the URI of a specific token.
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // Function to get the current token ID.
    function getCurrentTokenId() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
