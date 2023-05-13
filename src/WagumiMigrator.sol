// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {IERC721} from "./IERC721.sol";

contract WagumiMigrator {
    address public constant NFT_CONTRACT_ADDRESS = 0x6144D927EE371de7e7f8221b596F3432E7A8e6D9;
    address public constant DESTINATION_SAFE_ADDRESS = 0xa0350575a5Fbe6df3343038e138Dee3f5Beb2Fff;

    function migrate() external {
        // Get the Wagumi Cats NFT contract
        IERC721 nftContract = IERC721(NFT_CONTRACT_ADDRESS);

        // Transfer all NFTs of id #1-10 to the destination safe address
        for (uint256 i = 0; i < 10; i++) {
            nftContract.transferFrom(msg.sender, DESTINATION_SAFE_ADDRESS, i);
        }

        // Transfer all ETH to the destination safe address
        payable(DESTINATION_SAFE_ADDRESS).transfer(address(this).balance);
    }
}
