// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ICurve} from "../interfaces/ICurve.sol";
import {ILinearCurve} from "../interfaces/ILinearCurve.sol";
import {LinearCurveStorage} from "../libraries/LinearCurveStorage.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {ContractOwnershipStorage} from "@animoca/ethereum-contracts/contracts/access/libraries/ContractOwnershipStorage.sol";

/// @title Linear Curve contract for calculating the price of a token.
/// @dev The curve is defined by the price function `calculatePrice` in {ICurve} interface.
/// @dev This contract is to be used via inheritance in a proxied implementation.
/// @dev Note: This contract requires ERC165 (Interface Detection Standard).
abstract contract LinearCurveBase is ICurve, ILinearCurve, Context {
    using LinearCurveStorage for LinearCurveStorage.Layout;
    using ContractOwnershipStorage for ContractOwnershipStorage.Layout;

    /// @inheritdoc ILinearCurve
    function setInitialPrice(uint256 price) external {
        address operator = _msgSender();
        ContractOwnershipStorage.layout().enforceIsContractOwner(operator);
        LinearCurveStorage.layout().setInitialPrice(price, operator);
    }

    /// @inheritdoc ILinearCurve
    function setSlopeNumerator(uint256 numerator) external {
        address operator = _msgSender();
        ContractOwnershipStorage.layout().enforceIsContractOwner(operator);
        LinearCurveStorage.layout().setSlopeNumerator(numerator, operator);
    }

    /// @inheritdoc ILinearCurve
    function setSlopeDenominator(uint256 denominator) external {
        address operator = _msgSender();
        ContractOwnershipStorage.layout().enforceIsContractOwner(operator);
        LinearCurveStorage.layout().setSlopeDenominator(denominator, operator);
    }

    /// @inheritdoc ICurve
    function calculatePrice(uint256 totalSupply, uint256 amount) external view returns (uint256 price) {
        return LinearCurveStorage.layout().calculatePrice(totalSupply, amount);
    }

    /// @inheritdoc ILinearCurve
    function initialPrice() external view returns (uint256 price) {
        return LinearCurveStorage.layout().initialPrice();
    }

    /// @inheritdoc ILinearCurve
    function slopeNumerator() external view returns (uint256 numerator) {
        return LinearCurveStorage.layout().slopeNumerator();
    }

    /// @inheritdoc ILinearCurve
    function slopeDenominator() external view returns (uint256 denominator) {
        return LinearCurveStorage.layout().slopeDenominator();
    }
}
