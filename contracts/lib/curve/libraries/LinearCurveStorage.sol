// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {InterfaceDetectionStorage} from "@animoca/ethereum-contracts/contracts/introspection/libraries/InterfaceDetectionStorage.sol";
import {ProxyInitialization} from "@animoca/ethereum-contracts/contracts/proxy/libraries/ProxyInitialization.sol";
import {ICurve} from "../interfaces/ICurve.sol";
import {ILinearCurve} from "../interfaces/ILinearCurve.sol";
import {InitialPriceSet, SlopeNumeratorSet, SlopeDenominatorSet} from "../events/LinearCurveEvents.sol";
import {LinearCurveZeroNumerator, LinearCurveZeroDenominator} from "../errors/LinearCurveErrors.sol";

library LinearCurveStorage {
    using LinearCurveStorage for LinearCurveStorage.Layout;
    using InterfaceDetectionStorage for InterfaceDetectionStorage.Layout;

    struct Layout {
        uint256 price;
        uint256 numerator;
        uint256 denominator;
    }

    bytes32 internal constant LAYOUT_STORAGE_SLOT = bytes32(uint256(keccak256("yura2100.curve.LinearCurve.storage")) - 1);
    bytes32 internal constant PROXY_INIT_PHASE_SLOT = bytes32(uint256(keccak256("yura2100.curve.LinearCurve.phase")) - 1);

    /// @notice Initializes the storage with an initial price, slope numerator, and slope denominator (immutable version).
    /// @notice Marks the following ERC165 interface(s) as supported: ICurve, ILinearCurve.
    /// @dev Note: This function should be called ONLY in the constructor of an immutable (non-proxied) contract.
    /// @dev Emits an {InitialPriceSet}.
    /// @dev Emits a {SlopeNumeratorSet} if `numerator` is not zero.
    /// @dev Emits a {SlopeDenominatorSet} if `denominator` is not zero.
    /// @param price The initial price.
    /// @param numerator The slope numerator.
    /// @param denominator The slope denominator.
    /// @param operator The address of the operator performing the initialization.
    function constructorInit(Layout storage s, uint256 price, uint256 numerator, uint256 denominator, address operator) internal {
        s.setInitialPrice(price, operator);
        s.setSlopeNumerator(numerator, operator);
        s.setSlopeDenominator(denominator, operator);
        InterfaceDetectionStorage.layout().setSupportedInterface(type(ICurve).interfaceId, true);
        InterfaceDetectionStorage.layout().setSupportedInterface(type(ILinearCurve).interfaceId, true);
    }

    /// @notice Initializes the storage with an initial price, slope numerator, and slope denominator (proxied version).
    /// @notice Sets the proxy initialization phase to `1`.
    /// @notice Marks the following ERC165 interface(s) as supported: ICurve, ILinearCurve.
    /// @dev Note: This function should be called ONLY in the init function of a proxied contract.
    /// @dev Reverts with {InitializationPhaseAlreadyReached} if the proxy initialization phase is set to `1` or above.
    /// @dev Emits an {InitialPriceSet}.
    /// @dev Emits a {SlopeNumeratorSet} if `numerator` is not zero.
    /// @dev Emits a {SlopeDenominatorSet} if `denominator` is not zero.
    /// @param price The initial price.
    /// @param numerator The slope numerator.
    /// @param denominator The slope denominator.
    function proxyInit(Layout storage s, uint256 price, uint256 numerator, uint256 denominator, address operator) internal {
        ProxyInitialization.setPhase(PROXY_INIT_PHASE_SLOT, 1);
        s.constructorInit(price, numerator, denominator, operator);
    }

    /// @notice Sets the initial price of the curve.
    /// @dev Emits a {InitialPriceSet} event.
    /// @param price The initial price.
    /// @param operator The address of the operator performing the operation.
    function setInitialPrice(Layout storage s, uint256 price, address operator) internal {
        s.price = price;
        emit InitialPriceSet(price, operator);
    }

    /// @notice Sets the slope numerator of the curve.
    /// @dev Reverts with {LinearCurveZeroNumerator} if `numerator` is zero.
    /// @dev Emits a {SlopeNumeratorSet} event.
    /// @param numerator The slope numerator.
    /// @param operator The address of the operator performing the operation.
    function setSlopeNumerator(Layout storage s, uint256 numerator, address operator) internal {
        if (numerator == 0) {
            revert LinearCurveZeroNumerator();
        }

        s.numerator = numerator;
        emit SlopeNumeratorSet(numerator, operator);
    }

    /// @notice Sets the slope denominator of the curve.
    /// @dev Reverts with {LinearCurveZeroDenominator} if `denominator` is zero.
    /// @dev Emits a {SlopeDenominatorSet} event.
    /// @param denominator The slope denominator.
    /// @param operator The address of the operator performing the operation.
    function setSlopeDenominator(Layout storage s, uint256 denominator, address operator) internal {
        if (denominator == 0) {
            revert LinearCurveZeroDenominator();
        }

        s.denominator = denominator;
        emit SlopeDenominatorSet(denominator, operator);
    }

    /// @notice Calculates the price of a token given the total supply and the amount to mint.
    /// @param totalSupply The total supply of the tokens.
    /// @param amount The amount to mint.
    /// @return price The price of the token.
    function calculatePrice(Layout storage s, uint256 totalSupply, uint256 amount) internal view returns (uint256 price) {
        uint256 newSupply = totalSupply + amount - 1;
        return s.price + (newSupply * s.numerator) / s.denominator;
    }

    /// @notice Returns the initial price of the curve.
    /// @return price The initial price.
    function initialPrice(Layout storage s) internal view returns (uint256 price) {
        return s.price;
    }

    /// @notice Returns the slope numerator of the curve.
    /// @return numerator The slope numerator.
    function slopeNumerator(Layout storage s) internal view returns (uint256 numerator) {
        return s.numerator;
    }

    /// @notice Returns the slope denominator of the curve.
    /// @return denominator The slope denominator.
    function slopeDenominator(Layout storage s) internal view returns (uint256 denominator) {
        return s.denominator;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 position = LAYOUT_STORAGE_SLOT;
        assembly {
            s.slot := position
        }
    }
}
