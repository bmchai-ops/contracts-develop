// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.15;

// import "./Proposal.sol";
// import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// contract LendProposal is Proposal {
//     address _owner;
//     IERC721 _tokenBeingRented;
//     IERC20 _paymentToken;
//     address payable _from;
//     address _to;
//     uint256 _tokenID;
//     uint256 _RentalPrice;
//     uint256 yes = 0;
//     uint256 no = 0;
//     mapping(uint256 => address) private _tokenApprovals;

//     constructor(
//         IERC721 tokenBeingRented,
//         uint256 tokenID,
//         uint256 RentalPrice,
//         address owner,
//         IERC20 paymentToken
//     ) {
//         _tokenBeingRented = tokenBeingRented;
//         _tokenID = tokenID;
//         _RentalPrice = RentalPrice;
//         _owner = owner;
//         _paymentToken = paymentToken;
//     }

//     function rent(
//         address toWho,
//         uint256 price,
//         address tokenBeingRented
//     ) public {
//         require(yes > no, "not enough votes");
//         _tokenBeingRented.transferFrom(msg.sender, _to, _tokenID);
//     }

//     function _approve(address to, uint256 tokenId) internal virtual {
//         _tokenApprovals[tokenId] = to;
//     }

//     function payRent() external payable {
//         require(msg.value == _RentalPrice, "not enough rent");
//         _paymentToken.transferFrom(msg.sender, _owner, _RentalPrice);
//     }

//     function voteYes() external payable {
//         yes += uint256(msg.value);
//     }

//     function voteNo() external payable {
//         no += uint256(msg.value);
//     }
// }
