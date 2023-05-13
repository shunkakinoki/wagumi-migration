// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import "forge-std/console2.sol";

import {IERC721} from "../src/IERC721.sol";
import {WagumiMigrator} from "../src/WagumiMigrator.sol";

contract WagumiMigratorTest is Test {
    // The contract being tested
    WagumiMigrator migrator;

    // The fork of the Ethereum mainnet
    uint256 mainnetFork;

    // The RPC URL of the Ethereum mainnet
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    function setUp() public {
        // Deploy the contract being tested
        migrator = new WagumiMigrator();

        // Log the address of the contract being tested
        console2.log("WagumiMigrator address: %s", address(migrator));

        // Make the contract being tested persistent
        vm.makePersistent(address(migrator));
    }

    // Test that the migration contract works as expected
    // by simulating a fork of the Ethereum mainnet on foundry.
    function test_fork_simulation() public {
        // Create a fork of the Ethereum mainnet
        mainnetFork = vm.createFork(MAINNET_RPC_URL);

        // Select the mainnet fork
        vm.selectFork(mainnetFork);

        // Get the before balances of the origin safe address
        uint256 beforeOriginSafeAddressBalance = (migrator.ORIGIN_SAFE_ADDRESS()).balance;
        uint256 beforeDestinationSafeAddressBalance = (migrator.DESTINATION_SAFE_ADDRESS()).balance;

        // Set the sender to the origin safe address
        vm.startPrank(migrator.ORIGIN_SAFE_ADDRESS());

        // Approve the migration contract to transfer the NFTs
        IERC721(migrator.NFT_CONTRACT_ADDRESS()).setApprovalForAll(address(migrator), true);

        // Execute the migration
        migrator.migrate{value: beforeOriginSafeAddressBalance}();

        // Assert that the destination safe address has received the NFTs
        // and the contract has received the ETH
        assertEq((migrator.ORIGIN_SAFE_ADDRESS()).balance, 0);
        assertEq((address(migrator)).balance, 0);
        assertEq(
            ((migrator.DESTINATION_SAFE_ADDRESS()).balance),
            beforeOriginSafeAddressBalance + beforeDestinationSafeAddressBalance
        );

        // Assert that the NFTs have been transferred correctly
        for (uint256 i = 0; i < 10; i++) {
            assertEq(IERC721(migrator.NFT_CONTRACT_ADDRESS()).ownerOf(i), migrator.DESTINATION_SAFE_ADDRESS());
        }

        // End the prank
        vm.stopPrank();
    }
}
