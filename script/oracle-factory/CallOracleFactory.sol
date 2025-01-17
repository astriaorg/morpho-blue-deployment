// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import {MorphoChainlinkOracleV2Factory} from
    "../../lib/morpho-blue-oracles/src/morpho-chainlink/MorphoChainlinkOracleV2Factory.sol";
import {AggregatorV3Interface} from "../../lib/morpho-blue-oracles/src/morpho-chainlink/libraries/ChainlinkDataFeedLib.sol";

import "../../lib/morpho-blue-oracles/src/morpho-chainlink/interfaces/IERC4626.sol";

// to deploy `OracleFactory` with anvil:
// `yarn deploy:oracle-factory custom --broadcast --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`

contract CallOracleFactory is Script {
    function setUp() public {}

    function deployOracle() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        MorphoChainlinkOracleV2Factory oracleFactory = MorphoChainlinkOracleV2Factory(vm.envAddress("ORACLE_FACTORY_ADDRESS"));
        AggregatorV3Interface aggregatorA = AggregatorV3Interface(vm.envAddress("AGGREGATOR_A_CONTRACT_ADDRESS"));  
        AggregatorV3Interface aggregatorB = AggregatorV3Interface(vm.envAddress("AGGREGATOR_B_CONTRACT_ADDRESS"));
        uint8 baseTokenDecimals = aggregatorA.decimals();
        uint8 quoteTokenDecimals = aggregatorB.decimals();
        oracleFactory.createMorphoChainlinkOracleV2(
            IERC4626(address(0)), // baseVault
            1, // baseVaultConversionSample
            aggregatorA, // baseFeed1
            AggregatorV3Interface(address(0)), // baseFeed2
            baseTokenDecimals, // baseTokenDecimals
            IERC4626(address(0)), // quoteVault
            1, // quoteVaultConversionSample
            aggregatorB, // quoteFeed1
            AggregatorV3Interface(address(0)), // quoteFeed2
            quoteTokenDecimals, // quoteTokenDecimals
            0 // salt
        );
        vm.stopBroadcast();
    }
}
