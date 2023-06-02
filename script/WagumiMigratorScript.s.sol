// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "forge-std/Script.sol";
import "../src/WagumiMigrator.sol";

contract WagumiMigratorScript is Script {
    // Deploy the contract being tested
    WagumiMigrator migrator;

    function run() public {
        // Start the broadcast
        vm.startBroadcast();

        // Initialize the contract
        init();

        // Execute the migration
        migrate();

        // End the broadcast
        vm.stopBroadcast();
    }

    function init() public {
        // Deploy the contract being tested
        migrator = new WagumiMigrator();
    }

    function migrate() public {
        // Approve the migration contract to transfer the Wagumi Cats NFTs
        IERC721(migrator.CATS_CONTRACT_ADDRESS()).setApprovalForAll(address(migrator), true);

        // Approve the migration contract to transfer the wagumi.eth ENS NFT
        IERC721(migrator.ENS_CONTRACT_ADDRESS()).setApprovalForAll(address(migrator), true);

        // Execute the migration
        migrator.migrate{value: (migrator.ORIGIN_SAFE_ADDRESS()).balance}();
    }
}
