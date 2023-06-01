// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {IERC721} from "./IERC721.sol";
import {WagumiNFTMigrator} from "./WagumiNFTMigrator.sol";

/**
 * @title WagumiMigrator
 * @dev Migrates Wagumi Cats NFTs and ETH from one safe address to another
 * @author Shun Kakinoki
 */
contract WagumiMigrator {
    // Destination safe address
    address public constant DESTINATION_SAFE_ADDRESS = 0xa0350575a5Fbe6df3343038e138Dee3f5Beb2Fff;
    // Origin safe address
    address public constant ORIGIN_SAFE_ADDRESS = 0xDCE4694e268bD83EA41B335320Ed11A684a1d7dB;

    function migrate() public payable {
        WagumiNFTMigrator nftMigrator = new WagumiNFTMigrator();

        // Approve the Wagumi NFT Migrator contract to transfer all NFTs of id #1-10
        IERC721(nftMigrator.NFT_CONTRACT_ADDRESS()).setApprovalForAll(address(this), true);

        // Transfer all NFTs of id #1-10 to the destination safe address
        nftMigrator.migrate(DESTINATION_SAFE_ADDRESS);

        // Transfer all ETH to the destination safe address
        (bool success,) = payable(DESTINATION_SAFE_ADDRESS).call{value: msg.value}("");

        require(success, "Transfer failed.");
    }
}
