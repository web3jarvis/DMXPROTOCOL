// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract NFTMarketPlace is ERC1155, Ownable, ERC2981 {

    mapping(uint256 => string) private _tokenURIs;
    
    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {
        _setDefaultRoyalty(initialOwner, 1000);
    }

    function mintNFT(address to, uint256 nft_id, uint256 nft_supply, string memory tokenURI) external onlyOwner {
        _mint(to, nft_id, nft_supply, "");
        _tokenURIs[nft_id] = tokenURI;
    }

    function transferNFT(address from, address to, uint256 nft_id, uint256 amount) external {
        safeTransferFrom(from, to, nft_id, amount, "");
    }

    function getTokenURI(uint256 nft_id) external view returns (string memory) {
        return _tokenURIs[nft_id];
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

    // Future scope - Implement royalty distribution.
    // Future scope - Implement marketplace functions like listing, buying, and bidding on NFTs.