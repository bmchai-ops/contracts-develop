// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface IKYC {
    function kycsLevel(address _addr) external view returns (uint256);
}