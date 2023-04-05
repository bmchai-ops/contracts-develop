// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Proposal.sol";
import "../AddressHelper.sol";
import "../interfaces/IdaoCore.sol";
import "../interfaces/IGovernance.sol";

import "../interfaces/IKAP20.sol";
contract BuyProposal is Proposal {
    uint256 _tokenID;
    uint256 _price;
    uint256 public yes = 0;
    uint256 public no = 0;
    IKAP20 govToken;

    constructor(
        address _addressVault,
        uint256 tokenID,
        uint256 price
    ) Proposal(_addressVault) {
        _price = price;
        _tokenID = tokenID;
        govToken = IKAP20(addressVault.governance());
    }

    function buy(uint256 _listingId, uint256 _proposedAmount) external {
        uint256 totalSupply = govToken.totalSupply();
        require((yes + no) == totalSupply, "voting not finished");
        require(yes > no, "not enough people voted yes");
        IdaoCore x = IdaoCore(addressVault.daoCore());
        x.goBuyingNFT(_listingId, _proposedAmount);
    }

    function voteYes() external onlyAvailableVote {
        yes += govToken.balanceOf(msg.sender);
        voteStatus[msg.sender] = false;
    }

    function voteNo() external onlyAvailableVote {
        no += govToken.balanceOf(msg.sender);
        voteStatus[msg.sender] = false;
    }
        
}
