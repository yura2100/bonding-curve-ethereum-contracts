// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ContractOwnership} from "@animoca/ethereum-contracts/contracts/access/ContractOwnership.sol";
import {ERC721} from "@animoca/ethereum-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721Metadata} from "@animoca/ethereum-contracts/contracts/token/ERC721/ERC721Metadata.sol";
import {ERC721MintableOnce} from "@animoca/ethereum-contracts/contracts/token/ERC721/ERC721MintableOnce.sol";
import {ITokenMetadataResolver} from "@animoca/ethereum-contracts/contracts/token/metadata/interfaces/ITokenMetadataResolver.sol";

contract BCNFT is ContractOwnership, ERC721, ERC721Metadata, ERC721MintableOnce {
    constructor(
        ITokenMetadataResolver metadataResolver
    ) ContractOwnership(_msgSender()) ERC721() ERC721Metadata("Bonding Curve NFT", "BCNFT", metadataResolver) ERC721MintableOnce() {}
}
