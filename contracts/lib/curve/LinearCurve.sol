// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {InterfaceDetection} from "@animoca/ethereum-contracts/contracts/introspection/InterfaceDetection.sol";
import {ContractOwnership} from "@animoca/ethereum-contracts/contracts/access/ContractOwnership.sol";
import {LinearCurveBase} from "./base/LinearCurveBase.sol";
import {LinearCurveStorage} from "./libraries/LinearCurveStorage.sol";

/// @title Linear Curve contract (immutable version).
/// @dev This contract is to be used via inheritance in an immutable (non-proxied) implementation.
abstract contract LinearCurve is LinearCurveBase, InterfaceDetection, ContractOwnership {
    using LinearCurveStorage for LinearCurveStorage.Layout;

    /// @notice Initializes the storage with an initial price, slope numerator, and slope denominator.
    /// @notice Initializes the contract ownership with `initialOwner` as the initial contract owner.
    /// @dev Emits an {InitialPriceSet}.
    /// @dev Emits a {SlopeNumeratorSet} if `numerator` is not zero.
    /// @dev Emits a {SlopeDenominatorSet} if `denominator` is not zero.
    /// @param initialOwner The address to receive the contract ownership.
    /// @param price The initial price.
    /// @param numerator The slope numerator.
    /// @param denominator The slope denominator.
    constructor(address initialOwner, uint256 price, uint256 numerator, uint256 denominator) ContractOwnership(initialOwner) {
        LinearCurveStorage.layout().constructorInit(price, numerator, denominator, _msgSender());
    }
}
