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

        // Execute the migration
        migrate();

        // End the broadcast
        vm.stopBroadcast();
    }

    function migrate() public {
        // Deploy the contract being tested
        migrator = new WagumiMigrator();

        // Approve the migration contract to transfer the NFTs
        IERC721(migrator.NFT_CONTRACT_ADDRESS()).setApprovalForAll(address(migrator), true);

        // Execute the migration
        migrator.migrate{value: (migrator.ORIGIN_SAFE_ADDRESS()).balance}();
    }
}
