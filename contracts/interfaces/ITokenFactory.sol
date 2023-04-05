// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


interface ITokenFactory {
   function create(
        uint256 id,
        address addressVaultAddress,
        string calldata _govName,
        string calldata _govSymbol,
        string calldata _boardingpassName,
        string calldata _boardingpassSymbol
    ) external returns (address governance, address boardingpass);
}
