// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./interfaces/IAddressVault.sol";

/// @title AddressHelper is like an address book for the contract ecosystem.
/// @notice Inherit this contract if the top-level contract need to interact with other contracts in ecosystem.
/// @dev Explain to a developer any extra details
/// @custom:example `addressVault.timechain()` return Timechain's contract address.

contract AddressHelper {
    IAddressVault internal addressVault;

    constructor(address _addressVault) {
        addressVault = IAddressVault(_addressVault);
    }
}
