// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../AddressHelper.sol";
import "./BuyProposal.sol";
import "./SellProposal.sol";
import "./LendProposal.sol";

contract ProposalFactory {
    uint256 nonce = 1;
    event deploy(address addr);
    bytes32 public saltString;

    constructor() {
        saltString = keccak256(
            abi.encodePacked(block.number, block.timestamp, msg.sender)
        );
    }

    function deploySell(
        IERC721 tokenBeingSold,
        uint256 tokenID,
        uint256 price,
        address daoAddressVault
    ) external returns (address) {
        address _contract = address(
            new SellProposal{salt: getSalt(saltString)}(
                daoAddressVault,
                tokenBeingSold,
                tokenID,
                price
            )
        );
        emit deploy(address(_contract));
        return _contract;
    }

    function deployBuy(
        uint256 tokenID,
        uint256 price,
        address daoAddressVault
    ) external returns (address) {
        address _contract = address(
            new BuyProposal{salt: getSalt(saltString)}(
                daoAddressVault,
                tokenID,
                price
            )
        );
        emit deploy(address(_contract));
        return _contract;
    }

    // function deployRent(
    //     IERC721 tokenBeingSold,
    //     uint256 tokenID,
    //     uint256 price,
    //     IERC20 paymentToken
    // ) external {
    //     LendProposal _contract = new LendProposal{salt: getSalt(saltString)}(
    //         tokenBeingSold,
    //         tokenID,
    //         price,
    //         msg.sender,
    //         paymentToken
    //     );
    //     emit deploy(address(_contract));
    // }

    function getSalt(bytes32 x) public returns (bytes32) {
        bytes memory hash = abi.encodePacked(abi.encode(x), nonce);
        nonce++;
        return bytes32(hash);
    }
}
