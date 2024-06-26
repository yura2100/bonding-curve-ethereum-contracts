// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ERC721 Minter interface for minting ERC721 tokens.
/// @dev Note: The ERC-165 identifier for this interface is 0x4f859546.
interface IERC721Minter {
    /// @notice Returns the current token ID.
    /// @return tokenId The current token ID.
    function currentTokenId() external view returns (uint256 tokenId);

    /// @notice Returns the maximum token ID.
    /// @return tokenId The maximum token ID.
    function maxTokenId() external view returns (uint256 tokenId);

    /// @notice Mints a token to the specified address.
    /// @param to The address to receive the token.
    function mint(address to) external;
}
