// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity  ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Counters.sol";

contract GameItem is ERC721 {
   using Counters for Counters.Counter;
   Counters.Counter private _tokenIds;
   
      // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

   constructor() public ERC721("GameItem", "ITM") {}

   function addItem(address player, string memory tokenURI)
       public
       returns (uint256)
   {
       _tokenIds.increment();

       uint256 newItemId = _tokenIds.current();
       _mint(player, newItemId);
       _setTokenURI(newItemId, tokenURI);

       return newItemId;
   }
   
   function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
}