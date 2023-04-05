// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./AddressHelper.sol";
import "./interfaces/IMarketplace.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IKAP20.sol";
import "./interfaces/IGovernance.sol";

import "./interfaces/IProposalFactory.sol";

contract DAOCore is AddressHelper {
    uint256 _daoTotalBalance;
    address public currentProposal;
    uint256 public currentProposalExpire;
    mapping(address => uint256) _balanceTracker;

    IMarketplace internal marketplace;
    IKAP20 internal kkub;

    modifier onlyNoProposalOpened() {
        require(
            currentProposalExpire < block.timestamp,
            "timestamp: proposal still running"
        );
        _;
    }

    //events
    event depositLiq(address depositor, uint256 value);

    constructor(address _addressVault) AddressHelper(_addressVault) {
        marketplace = IMarketplace(addressVault.marketplace());
    }

    function goBuyingNFT(uint256 _listingId, uint256 _proposedAmount) public {
        marketplace.buyWithToken(_listingId, _proposedAmount);
    }

    function goSellingNFT(
        address _nftContract,
        uint256 _tokenId,
        address _exchangeToken,
        uint256 _price,
        bool isKAP1155
    ) public {
        marketplace.sellingItem(
            _nftContract,
            _tokenId,
            _exchangeToken,
            _price,
            isKAP1155
        );
    }

    function depositLiquidity(uint256 value) external {
        require(msg.sender != address(0), "cannot address 0");

        _balanceTracker[msg.sender] += value;
        _daoTotalBalance += value;
        kkub.transferFrom(msg.sender, address(this), value);
        IGovernance x = IGovernance(addressVault.governance());
        x.mint(msg.sender, value);

        emit depositLiq(msg.sender, value);
    }

    function createBuyProposal(uint256 tokenID, uint256 price)
        external
        onlyNoProposalOpened
        returns (address)
    {
        IERC20 gov = IERC20(addressVault.governance());
        require(gov.balanceOf(msg.sender) > 0, "permission: only DAO members");
        address proposal = IProposalFactory(addressVault.proposalFactory())
            .deployBuy(tokenID, price, address(addressVault));
        _updateCurrentProposal(proposal);
        return proposal;
    }

    function createSellProposal(
        address tokenBeingSold,
        uint256 tokenID,
        uint256 price
    ) external onlyNoProposalOpened returns (address) {
        IERC20 gov = IERC20(addressVault.governance());
        require(gov.balanceOf(msg.sender) > 0, "permission: only DAO members");
        address proposal = IProposalFactory(addressVault.proposalFactory())
            .deploySell(tokenBeingSold, tokenID, price, address(addressVault));
        _updateCurrentProposal(proposal);
        return proposal;
    }

    function _updateCurrentProposal(address _newProposal) private {
        currentProposal = _newProposal;
        currentProposalExpire = block.timestamp + 86400;
    }
}
