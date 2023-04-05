// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "../AddressHelper.sol";

contract Proposal is AddressHelper {

  address public origin;
  address public factory;
  mapping(address => bool) public voteStatus;

  modifier onlyAvailableVote() {
    require (voteStatus[msg.sender] = true, "Already Voted!");
    _;
  }

  constructor(address _addressVault) AddressHelper(_addressVault) {
    factory = msg.sender;
  }
}