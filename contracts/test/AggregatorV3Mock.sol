// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/mocks/MockAggregator.sol";

contract AggregatorV3Mock is MockAggregator {
    constructor() {
        setLatestAnswer(1 * 10 ** 8);
    }

    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80) {
        return (1, latestAnswer(), 1, 1, 1);
    }
}