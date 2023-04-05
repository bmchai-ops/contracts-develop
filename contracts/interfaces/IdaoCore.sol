// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IdaoCore {
    function goBuyingNFT(uint256 _listingId, uint256 _proposedAmount) external;

    function goSellingNFT(
        address _nftContract,
        uint256 _tokenId,
        address _exchangeToken,
        uint256 _price,
        bool isKAP1155
    ) external;

    function depositLiquidity(uint256 value) external;
}
