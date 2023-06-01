// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {IERC721} from "./IERC721.sol";

/**
 * @title Cats
 * @dev Migrates Wagumi Cats NFTs and wagumi.eth ENS from one safe address to another
 * @author Shun Kakinoki
 */
contract WagumiNFTMigrator {
    // Wagumi Cats NFT contract address
    address public constant NFT_CONTRACT_ADDRESS = 0x6144D927EE371de7e7f8221b596F3432E7A8e6D9;

    function migrate(address destination) public payable {
        // Get the Wagumi Cats NFT contract
        IERC721 nftContract = IERC721(NFT_CONTRACT_ADDRESS);

        // Transfer all NFTs of id #1-10 to the destination safe address
        for (uint256 i = 0; i < 10; i++) {
            nftContract.transferFrom(msg.sender, destination, i);
        }

        // Transfer all ETH to the destination safe address
        (bool success,) = payable(destination).call{value: msg.value}("");

        require(success, "Transfer failed.");
    }
}
