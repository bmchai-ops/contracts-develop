// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "../AddressHelper.sol";
import "./Proposal.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../interfaces/IdaoCore.sol";

contract SellProposal is Proposal {
    IERC721 _tokenBeingSold;
    uint256 _tokenID;
    uint256 _price;
    uint256 yes = 0;
    uint256 no = 0;

    constructor(
        address _addressVault,
        IERC721 tokenBeingSold,
        uint256 tokenID,
        uint256 price
    ) Proposal(_addressVault) {
        _tokenBeingSold = tokenBeingSold;
        _tokenID = tokenID;
        _price = price;
    }

    function sell(bool isKAP1155) external {
        // require(msg.value > _price, "Insufficient fund");
        require(yes > no, "not enough votes");
        IdaoCore x = IdaoCore(addressVault.daoCore());
        x.goSellingNFT(
            address(_tokenBeingSold),
            _tokenID,
            addressVault.kkub(),
            _price,
            isKAP1155
        );
    }

    function voteYes() external payable {
        yes += uint256(msg.value);
    }

    function voteNo() external payable {
        no += uint256(msg.value);
    }
}
