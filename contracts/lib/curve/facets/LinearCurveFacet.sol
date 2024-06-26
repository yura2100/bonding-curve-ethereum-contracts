// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {ForwarderRegistryContextBase} from "@animoca/ethereum-contracts/contracts/metatx/base/ForwarderRegistryContextBase.sol";
import {IForwarderRegistry} from "@animoca/ethereum-contracts/contracts/metatx/interfaces/IForwarderRegistry.sol";
import {ProxyAdminStorage} from "@animoca/ethereum-contracts/contracts/proxy/libraries/ProxyAdminStorage.sol";
import {LinearCurveBase} from "../base/LinearCurveBase.sol";
import {LinearCurveStorage} from "../libraries/LinearCurveStorage.sol";

/// @title Linear Curve (facet version).
/// @dev This contract is to be used as a diamond facet (see ERC2535 Diamond Standard https://eips.ethereum.org/EIPS/eip-2535).
/// @dev Note: This facet depends on {ProxyAdminFacet}, {InterfaceDetectionFacet} and {ContractOwnershipFacet}.
contract LinearCurveFacet is LinearCurveBase, ForwarderRegistryContextBase {
    using LinearCurveStorage for LinearCurveStorage.Layout;
    using ProxyAdminStorage for ProxyAdminStorage.Layout;

    constructor(IForwarderRegistry forwarderRegistry) ForwarderRegistryContextBase(forwarderRegistry) {}

    /// @notice Initializes the storage with the initial price and slope of the curve.
    /// @notice Sets the proxy initialization phase to `1`.
    /// @notice Marks the following ERC165 interfaces as supported: LinearCurve.
    /// @dev Reverts with {NotProxyAdmin} if the sender is not the proxy admin.
    /// @dev Reverts with {InitializationPhaseAlreadyReached} if the proxy initialization phase is set to `1` or above.
    /// @dev Reverts with {LinearCurveZeroNumerator} if the `numerator` is zero.
    /// @dev Reverts with {LinearCurveZeroDenominator} if the `denominator` is zero.
    /// @dev Emits an {InitialPriceSet} event.
    /// @dev Emits a {SlopeNumeratorSet} event.
    /// @dev Emits a {SlopeDenominatorSet} event.
    /// @param price The initial price of the curve.
    /// @param numerator The numerator of the slope of the curve.
    /// @param denominator The denominator of the slope of the curve.
    function initLinearCurveStorage(uint256 price, uint256 numerator, uint256 denominator) external {
        address operator = _msgSender();
        ProxyAdminStorage.layout().enforceIsProxyAdmin(operator);
        LinearCurveStorage.layout().proxyInit(price, numerator, denominator, operator);
    }

    /// @inheritdoc ForwarderRegistryContextBase
    function _msgSender() internal view virtual override(Context, ForwarderRegistryContextBase) returns (address) {
        return ForwarderRegistryContextBase._msgSender();
    }

    /// @inheritdoc ForwarderRegistryContextBase
    function _msgData() internal view virtual override(Context, ForwarderRegistryContextBase) returns (bytes calldata) {
        return ForwarderRegistryContextBase._msgData();
    }
}
