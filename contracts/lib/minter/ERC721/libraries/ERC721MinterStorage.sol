// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// solhint-disable-next-line max-line-length
import {ERC721MinterZeroMaxTokenId, ERC721MinterUnsupportedContractType, ERC721MinterMaxTokenIdExceeded, ERC721MinterZeroTokenAddress} from "../errors/ERC721MinterErrors.sol";
import {InterfaceDetectionStorage} from "@animoca/ethereum-contracts/contracts/introspection/libraries/InterfaceDetectionStorage.sol";
import {IERC165} from "@animoca/ethereum-contracts/contracts/introspection/interfaces/IERC165.sol";
import {IERC721Mintable} from "@animoca/ethereum-contracts/contracts/token/ERC721/interfaces/IERC721Mintable.sol";
import {ProxyInitialization} from "@animoca/ethereum-contracts/contracts/proxy/libraries/ProxyInitialization.sol";
import {IERC721Minter} from "../interfaces/IERC721Minter.sol";

library ERC721MinterStorage {
    using ERC721MinterStorage for ERC721MinterStorage.Layout;
    using InterfaceDetectionStorage for InterfaceDetectionStorage.Layout;

    struct Layout {
        uint256 currentTokenId;
        uint256 maxTokenId;
        IERC721Mintable token;
    }

    bytes32 internal constant LAYOUT_STORAGE_SLOT = bytes32(uint256(keccak256("yura2100.token.ERC721.ERC721Minter.storage")) - 1);
    bytes32 internal constant PROXY_INIT_PHASE_SLOT = bytes32(uint256(keccak256("yura2100.token.ERC721.ERC721Minter.phase")) - 1);

    /// @notice Initializes the storage with the maximum token ID and the ERC721 token contract.
    /// @notice Marks the following ERC165 interfaces as supported: ERC721Minter.
    /// @dev Note: This function should be called ONLY in the constructor of an immutable (non-proxied) contract.
    /// @dev Reverts with {ERC721MinterZeroMaxTokenId} if the `maxTokenId` is zero.
    /// @dev Reverts with {ERC721MinterZeroTokenAddress} if the `token` is the zero address.
    /// @dev Reverts with {ERC721MinterUnsupportedContractType} if the `token` does not support the IERC721Mintable interface.
    /// @param maxTokenId The maximum token ID that can be minted.
    /// @param token The ERC721 token contract.
    function constructorInit(Layout storage s, uint256 maxTokenId, IERC721Mintable token) internal {
        if (maxTokenId == 0) {
            revert ERC721MinterZeroMaxTokenId();
        }
        if (address(token) == address(0)) {
            revert ERC721MinterZeroTokenAddress();
        }

        if (!IERC165(address(token)).supportsInterface(type(IERC721Mintable).interfaceId)) {
            revert ERC721MinterUnsupportedContractType(address(token));
        }
        s.maxTokenId = maxTokenId;
        s.token = token;
        InterfaceDetectionStorage.layout().setSupportedInterface(type(IERC721Minter).interfaceId, true);
    }

    /// @notice Initializes the storage with the maximum token ID and the ERC721 token contract.
    /// @notice Sets the proxy initialization phase to `1`.
    /// @notice Marks the following ERC165 interfaces as supported: ERC721Minter.
    /// @dev Note: This function should be called ONLY in the init function of a proxied contract.
    /// @dev Reverts with {InitializationPhaseAlreadyReached} if the proxy initialization phase is set to `1` or above.
    /// @param maxTokenId The maximum token ID that can be minted.
    /// @param token The ERC721 token contract.
    function proxyInit(Layout storage s, uint256 maxTokenId, IERC721Mintable token) internal {
        ProxyInitialization.setPhase(PROXY_INIT_PHASE_SLOT, 1);
        s.constructorInit(maxTokenId, token);
    }

    /// @notice Mints a token to the specified address.
    /// @dev Reverts with {ERC721MinterMaxTokenIdExceeded} if the current token ID exceeds the maximum token ID.
    /// @param to The address to which the token will be minted.
    function mint(Layout storage s, address to) internal {
        uint256 nextId = s.currentTokenId + 1;
        if (nextId > s.maxTokenId) {
            revert ERC721MinterMaxTokenIdExceeded();
        }
        s.token.mint(to, nextId);
        s.currentTokenId = nextId;
    }

    /// @notice Returns the current token ID.
    /// @return tokenId The current token ID.
    function currentId(Layout storage s) internal view returns (uint256 tokenId) {
        return s.currentTokenId;
    }

    /// @notice Returns the maximum token ID.
    /// @return tokenId The maximum token ID.
    function maxId(Layout storage s) internal view returns (uint256 tokenId) {
        return s.maxTokenId;
    }

    function layout() internal pure returns (Layout storage s) {
        bytes32 position = LAYOUT_STORAGE_SLOT;
        assembly {
            s.slot := position
        }
    }
}
