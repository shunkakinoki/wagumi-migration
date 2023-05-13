// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// Minimal ERC721 interface
interface IERC721 {
    function transferFrom(address from, address to, uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns (address);
    function setApprovalForAll(address operator, bool approved) external;
}
