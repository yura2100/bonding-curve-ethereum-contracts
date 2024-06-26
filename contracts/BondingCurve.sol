// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {LinearCurve} from "./lib/curve/LinearCurve.sol";

contract BondingCurve is LinearCurve {
    constructor(uint256 price, uint256 numerator, uint256 denominator) LinearCurve(_msgSender(), price, numerator, denominator) {}
}
