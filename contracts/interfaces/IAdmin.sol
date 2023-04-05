// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IAdmin {
    function isSuperAdmin(address _addr) external view returns (bool);

    function isAdmin(address _addr) external view returns (bool);
}