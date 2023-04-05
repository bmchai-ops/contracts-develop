// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IProposalFactory {
    function deploySell(
        address tokenBeingSold,
        uint256 tokenID,
        uint256 price,
        address daoAddressVault
    ) external returns (address);

    function deployBuy(
        uint256 tokenID,
        uint256 price,
        address daoAddressVault
    ) external  returns (address);
}
