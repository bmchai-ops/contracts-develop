// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IGovernance {
    function mint(address account, uint256 amount) external;

    function burn(address account, uint256 amount) external;

    function totalSupply() external view returns (uint256);
}
