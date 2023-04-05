// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IMarketplace {

    function sellingItem(address _nftContract, uint256 _tokenId, address _exchangeToken, uint256 _price, bool isKAP1155) external;

    function buyWithToken(uint256 _listingIdx, uint256 _submitAmount) external;

    function lendingItem() external;
}