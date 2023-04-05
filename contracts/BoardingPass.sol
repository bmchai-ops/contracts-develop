// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./AddressHelper.sol";

contract BoardingPass is ERC721, AddressHelper {
    constructor(
        address _addressVault,
        string memory _name,
        string memory _symbol
    ) AddressHelper(_addressVault) ERC721(_name, _symbol) {}
}
