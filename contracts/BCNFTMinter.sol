// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {IERC165} from "@animoca/ethereum-contracts/contracts/introspection/interfaces/IERC165.sol";
import {IERC721Mintable} from "@animoca/ethereum-contracts/contracts/token/ERC721/interfaces/IERC721Mintable.sol";
import {ERC721Minter} from "./lib/minter/ERC721/ERC721Minter.sol";
import {ICurve} from "./lib/curve/interfaces/ICurve.sol";

contract BCNFTMinter is ERC721Minter, Context {
    using SafeERC20 for IERC20;

    ICurve public curve;
    IERC20 public feeToken;
    address public feeReceiver;

    error InvalidCurveContractType(address curveContract);

    error ZeroAddress();

    constructor(ICurve _curve, IERC20 _feeToken, address _feeReceiver, uint256 maxTokenId, IERC721Mintable token) ERC721Minter(maxTokenId, token) {
        if (!IERC165(address(_curve)).supportsInterface(type(ICurve).interfaceId)) {
            revert InvalidCurveContractType(address(_curve));
        }
        curve = _curve;
        feeToken = _feeToken;
        if (_feeReceiver == address(0)) {
            revert ZeroAddress();
        }
        feeReceiver = _feeReceiver;
    }

    function mint(address to) public override {
        uint256 price = curve.calculatePrice(currentTokenId(), 1);
        feeToken.safeTransferFrom(_msgSender(), feeReceiver, price);
        super.mint(to);
    }
}
