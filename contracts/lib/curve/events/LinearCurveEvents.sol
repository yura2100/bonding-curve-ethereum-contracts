// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Emitted when the initial price of the curve is set.
/// @param price The initial price.
/// @param operator The address setting the initial price.
event InitialPriceSet(uint256 indexed price, address indexed operator);

/// @notice Emitted when the slope numerator of the curve is set.
/// @param numerator The slope numerator.
/// @param operator The address setting the slope numerator.
event SlopeNumeratorSet(uint256 indexed numerator, address indexed operator);

/// @notice Emitted when the slope denominator of the curve is set.
/// @param denominator The slope denominator.
/// @param operator The address setting the slope denominator.
event SlopeDenominatorSet(uint256 indexed denominator, address indexed operator);
