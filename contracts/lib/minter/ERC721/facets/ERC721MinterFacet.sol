// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ForwarderRegistryContextBase} from "@animoca/ethereum-contracts/contracts/metatx/base/ForwarderRegistryContextBase.sol";
import {IForwarderRegistry} from "@animoca/ethereum-contracts/contracts/metatx/interfaces/IForwarderRegistry.sol";
import {ProxyAdminStorage} from "@animoca/ethereum-contracts/contracts/proxy/libraries/ProxyAdminStorage.sol";
import {IERC721Mintable} from "@animoca/ethereum-contracts/contracts/token/ERC721/interfaces/IERC721Mintable.sol";
import {ERC721MinterBase} from "../base/ERC721MinterBase.sol";
import {ERC721MinterStorage} from "../libraries/ERC721MinterStorage.sol";

/// @title ERC721 Minter (facet version).
/// @dev This contract is to be used as a diamond facet (see ERC2535 Diamond Standard https://eips.ethereum.org/EIPS/eip-2535).
/// @dev Note: This facet depends on {ProxyAdminFacet} and {InterfaceDetectionFacet}.
contract ERC721MinterFacet is ERC721MinterBase, ForwarderRegistryContextBase {
    using ERC721MinterStorage for ERC721MinterStorage.Layout;
    using ProxyAdminStorage for ProxyAdminStorage.Layout;

    constructor(IForwarderRegistry forwarderRegistry) ForwarderRegistryContextBase(forwarderRegistry) {}

    /// @notice Initializes the storage with the maximum token ID and the ERC721 token contract.
    /// @notice Sets the proxy initialization phase to `1`.
    /// @notice Marks the following ERC165 interfaces as supported: ERC721Minter.
    /// @dev Reverts with {NotProxyAdmin} if the sender is not the proxy admin.
    /// @dev Reverts with {InitializationPhaseAlreadyReached} if the proxy initialization phase is set to `1` or above.
    /// @dev Reverts with {ERC721MinterZeroMaxTokenId} if the `maxTokenId` is zero.
    /// @dev Reverts with {ERC721MinterZeroTokenAddress} if the `token` is the zero address.
    /// @dev Reverts with {ERC721MinterUnsupportedContractType} if the `token` does not support the IERC721Mintable interface.
    /// @param maxTokenId The maximum token ID that can be minted.
    /// @param token The ERC721 token contract.
    function initERC721MinterStorage(uint256 maxTokenId, IERC721Mintable token) external {
        ProxyAdminStorage.layout().enforceIsProxyAdmin(_msgSender());
        ERC721MinterStorage.layout().proxyInit(maxTokenId, token);
    }
}
