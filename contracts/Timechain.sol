// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./AddressHelper.sol";

struct GovernanceBalanceBlock {
    uint256 balance;
    uint256 blockNumber;
}

contract Timechain is AddressHelper {
    modifier onlyGovernance() {
        require(
            msg.sender == addressVault.governance(),
            "permission: only governance"
        );
        _;
    }

    mapping(address => GovernanceBalanceBlock[]) public governanceBalanceChain;
    mapping(uint256 => uint256) public governanceTotalSupplyChain;

    constructor(address _addressVault) AddressHelper(_addressVault) {}

    // functions for governanceBalanceChain

    function getGovernanceBalanceChain(address _address)
        external
        view
        returns (GovernanceBalanceBlock[] memory)
    {
        return governanceBalanceChain[_address];
    }

    function balanceAt(uint256 _blockNumber, address _address) public view returns (uint256) {
        uint256 chainLength = governanceBalanceChain[_address].length;
        if (chainLength == 0) {
            return 0;
        }
        for (uint256 i = governanceBalanceChain[_address].length - 1; i >= 0; i--) {
            if (governanceBalanceChain[_address][i].blockNumber < _blockNumber) {
                return governanceBalanceChain[_address][i].balance;
            }
        }
        return 0;
    }

    function updateBalance(address _address, uint256 _balance)
        external
        onlyGovernance
        returns (bool)
    {
        return _appendGovernanceBalance(_address, _balance);
    }

    function _appendGovernanceBalance(address _address, uint256 _balance)
        private
        returns (bool)
    {
        governanceBalanceChain[_address].push(
            GovernanceBalanceBlock(_balance, block.number)
        );
        return true;
    }
}
