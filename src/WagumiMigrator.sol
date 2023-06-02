// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {IERC721} from "./IERC721.sol";

/**
 * @title WagumiMigrator
 * @dev Migrates Wagumi Cats NFTs and ETH from one safe address to another
 * @author Shun Kakinoki
 */
contract WagumiMigrator {
    // Wagumi Cats NFT contract address
    address public constant CATS_CONTRACT_ADDRESS = 0x6144D927EE371de7e7f8221b596F3432E7A8e6D9;

    // Destination safe address
    address public constant DESTINATION_SAFE_ADDRESS = 0xa0350575a5Fbe6df3343038e138Dee3f5Beb2Fff;
    // Origin safe address
    address public constant ORIGIN_SAFE_ADDRESS = 0xDCE4694e268bD83EA41B335320Ed11A684a1d7dB;

    // ENS namehash of the origin safe address
    address public constant ENS_CONTRACT_ADDRESS = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;
    // ID of wagumi.eth
    uint256 public constant ENS_WAGUMI_ID =
        18019805752382518475808758214599099996488809401149089142030556561887882232265;

    function migrate() public payable {
        // Get the Wagumi Cats NFT contract
        IERC721 wagumiCatsContract = IERC721(CATS_CONTRACT_ADDRESS);

        // Transfer all NFTs of id #1-10 to the destination safe address
        for (uint256 i = 0; i < 11; i++) {
            wagumiCatsContract.transferFrom(msg.sender, DESTINATION_SAFE_ADDRESS, i);
        }

        IERC721(ENS_CONTRACT_ADDRESS).transferFrom(msg.sender, DESTINATION_SAFE_ADDRESS, ENS_WAGUMI_ID);

        // Transfer all ETH to the destination safe address
        (bool success,) = payable(DESTINATION_SAFE_ADDRESS).call{value: msg.value}("");

        require(success, "Transfer failed.");
    }
}
