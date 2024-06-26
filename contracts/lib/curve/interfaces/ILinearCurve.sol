// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title Linear Curve interface for calculating the price of a token.
/// @dev The curve is defined by the price function `calculatePrice` in {ICurve} interface.
/// @dev Note: The ERC-165 identifier for this interface is 0x0e098596.
interface ILinearCurve {
    /// @notice Returns the initial price of the curve.
    /// @return price The initial price.
    function initialPrice() external view returns (uint256 price);

    /// @notice Returns the slope numerator of the curve.
    /// @return numerator The slope numerator.
    function slopeNumerator() external view returns (uint256 numerator);

    /// @notice Returns the slope denominator of the curve.
    /// @return denominator The slope denominator.
    function slopeDenominator() external view returns (uint256 denominator);

    /// @notice Sets the initial price of the curve.
    /// @dev Emits a {InitialPriceSet} event.
    /// @param price The initial price.
    function setInitialPrice(uint256 price) external;

    /// @notice Sets the slope numerator of the curve.
    /// @dev Reverts if `numerator` is zero.
    /// @dev Emits a {SlopeNumeratorSet} event.
    /// @param numerator The slope numerator.
    function setSlopeNumerator(uint256 numerator) external;

    /// @notice Sets the slope denominator of the curve.
    /// @dev Reverts if `denominator` is zero.
    /// @dev Emits a {SlopeDenominatorSet} event.
    /// @param denominator The slope denominator.
    function setSlopeDenominator(uint256 denominator) external;
}
