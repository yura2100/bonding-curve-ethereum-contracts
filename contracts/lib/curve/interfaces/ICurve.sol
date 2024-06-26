// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Curve interface for calculating the price of a token.
/// @dev The curve is defined by the price function `calculatePrice`.
/// @dev Note: The ERC-165 identifier for this interface is 0xa6413a27.
interface ICurve {
    /// @notice Calculates the price of a token given the total supply and the amount to mint.
    /// @dev The price is calculated based on bonding curve mathematical function.
    /// @param totalSupply The total supply of the tokens.
    /// @param amount The amount of tokens to mint.
    function calculatePrice(uint256 totalSupply, uint256 amount) external view returns (uint256 price);
}
