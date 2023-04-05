// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface ITimechain {
    function getGovernanceBalanceChain(address _address)
        external
        view
        returns (uint256 balance, uint256 blockNumber);

    function balanceAt(uint256 _blockNumber, address _address)
        external
        view
        returns (uint256);

    function updateBalance(address _address, uint256 _balance)
        external
        returns (bool);
}
