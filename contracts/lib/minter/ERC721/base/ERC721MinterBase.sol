// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC721Minter} from "../interfaces/IERC721Minter.sol";
import {ERC721MinterStorage} from "../libraries/ERC721MinterStorage.sol";

/// @title ERC721 Minter contract for minting ERC721 tokens with a maximum token ID limit.
/// @dev This contract is to be used via inheritance in a proxied implementation.
/// @dev Note: This contract requires ERC165 (Interface Detection Standard).
abstract contract ERC721MinterBase is IERC721Minter {
    using ERC721MinterStorage for ERC721MinterStorage.Layout;

    /// @inheritdoc IERC721Minter
    function mint(address to) public virtual {
        ERC721MinterStorage.layout().mint(to);
    }

    /// @inheritdoc IERC721Minter
    function currentTokenId() public view returns (uint256 tokenId) {
        return ERC721MinterStorage.layout().currentId();
    }

    /// @inheritdoc IERC721Minter
    function maxTokenId() public view returns (uint256 tokenId) {
        return ERC721MinterStorage.layout().maxId();
    }
}
