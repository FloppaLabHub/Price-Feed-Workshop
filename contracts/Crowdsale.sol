// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdsale {
    AggregatorV3Interface private immutable _PRICEFEED;
    IERC20 private immutable _TOKEN;

    uint256 private constant _RATE = 10;

    constructor(address _aggregator, address _token) {
        _PRICEFEED = AggregatorV3Interface(_aggregator);
        _TOKEN = IERC20(_token);
    }

    function buyTokens() external payable {
        uint256 _usd = _getConversionRate(msg.value);
        uint256 _tokensTotransfer = _usd * _RATE;
        _TOKEN.transfer(msg.sender, _tokensTotransfer);
    }

    function _getPrice() private view returns (uint256) {
        (,int256 _price,,,) = _PRICEFEED.latestRoundData();
        return uint256(_price * (1 * 10 ** 10));
    }

    function _getConversionRate(uint256 _value) private view returns (uint256) {
        uint256 _eth = _getPrice();
        uint256 _ethUSD = (_eth * _value) / (1 * 10 ** 18);
        return _ethUSD;
    }
}