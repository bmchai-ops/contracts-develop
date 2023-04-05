// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IAdminAsset {
    function isSuperAdmin(address _addr, string calldata _token) external view returns (bool);
}
