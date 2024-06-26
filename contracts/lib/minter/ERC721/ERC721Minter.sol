// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {InterfaceDetection} from "@animoca/ethereum-contracts/contracts/introspection/InterfaceDetection.sol";
import {IERC721Mintable} from "@animoca/ethereum-contracts/contracts/token/ERC721/interfaces/IERC721Mintable.sol";
import {ERC721MinterBase} from "./base/ERC721MinterBase.sol";
import {ERC721MinterStorage} from "./libraries/ERC721MinterStorage.sol";

/// @title ERC721 Minter contract (immutable version).
abstract contract ERC721Minter is ERC721MinterBase, InterfaceDetection {
    using ERC721MinterStorage for ERC721MinterStorage.Layout;

    /// @notice Initializes the storage with the maximum token ID and the ERC721 token contract.
    /// @dev Reverts with {ERC721MinterZeroMaxTokenId} if the `maxTokenId` is zero.
    /// @dev Reverts with {ERC721MinterZeroTokenAddress} if the `token` is the zero address.
    /// @dev Reverts with {ERC721MinterUnsupportedContractType} if the `token` does not support the IERC721Mintable interface.
    /// @param maxTokenId The maximum token ID that can be minted.
    /// @param token The ERC721 token contract.
    constructor(uint256 maxTokenId, IERC721Mintable token) {
        ERC721MinterStorage.layout().constructorInit(maxTokenId, token);
    }
}
