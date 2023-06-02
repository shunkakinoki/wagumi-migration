// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {Test} from "forge-std/Test.sol";
import "forge-std/console2.sol";

import {IERC721} from "../src/IERC721.sol";
import {WagumiMigrator} from "../src/WagumiMigrator.sol";
import {WagumiMigratorScript} from "../script/WagumiMigratorScript.s.sol";

contract WagumiMigratorTest is WagumiMigratorScript, Test {
    // The fork of the Ethereum mainnet
    uint256 mainnetFork;

    // The RPC URL of the Ethereum mainnet
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    // Test that the migration contract works as expected
    // by simulating a fork of the Ethereum mainnet on foundry.
    function test_fork_simulation() public {
        // Create a fork of the Ethereum mainnet
        mainnetFork = vm.createFork(MAINNET_RPC_URL);

        // Select the mainnet fork
        vm.selectFork(mainnetFork);

        // Deploy the migration contract being tested
        init();

        // Get the before balances of the origin safe address
        uint256 beforeOriginSafeAddressBalance = (migrator.ORIGIN_SAFE_ADDRESS()).balance;
        uint256 beforeDestinationSafeAddressBalance = (migrator.DESTINATION_SAFE_ADDRESS()).balance;

        // Assert that the origin safe address has the expected balance
        assertEq(beforeOriginSafeAddressBalance, 258030032601721082);

        // Assert that the NFTs belong to origin safe address
        for (uint256 i = 0; i < 11; i++) {
            assertEq(IERC721(migrator.CATS_CONTRACT_ADDRESS()).ownerOf(i), migrator.ORIGIN_SAFE_ADDRESS());
        }

        // Assert that the ENS name belongs to origin safe address
        assertEq(
            IERC721(migrator.ENS_CONTRACT_ADDRESS()).ownerOf(migrator.ENS_WAGUMI_ID()), migrator.ORIGIN_SAFE_ADDRESS()
        );

        // Set the sender to the origin safe address
        vm.startPrank(address(0xDCE4694e268bD83EA41B335320Ed11A684a1d7dB));

        // Execute the migration
        migrate();

        // Assert that the destination safe address has received the NFTs
        // and the contract has received the ETH
        assertEq((migrator.ORIGIN_SAFE_ADDRESS()).balance, 0);
        assertEq((address(migrator)).balance, 0);
        assertEq(
            ((migrator.DESTINATION_SAFE_ADDRESS()).balance),
            beforeOriginSafeAddressBalance + beforeDestinationSafeAddressBalance
        );

        // Assert that the NFTs have been transferred correctly
        for (uint256 i = 0; i < 11; i++) {
            assertEq(IERC721(migrator.CATS_CONTRACT_ADDRESS()).ownerOf(i), migrator.DESTINATION_SAFE_ADDRESS());
        }

        // Assert that the ENS name has been transferred correctly
        assertEq(
            IERC721(migrator.ENS_CONTRACT_ADDRESS()).ownerOf(migrator.ENS_WAGUMI_ID()),
            migrator.DESTINATION_SAFE_ADDRESS()
        );

        // End the prank
        vm.stopPrank();
    }
}
