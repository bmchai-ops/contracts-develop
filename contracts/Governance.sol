// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./AddressHelper.sol";
import "./interfaces/ITimechain.sol";

contract Governance is ERC20, AddressHelper {
    constructor(
        address _addressVault,
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol) AddressHelper(_addressVault) {}

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);

        // update Timechain
        ITimechain(addressVault.timechain()).updateBalance(
            owner,
            balanceOf(owner)
        );
        ITimechain(addressVault.timechain()).updateBalance(to, balanceOf(to));
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);

        // update Timechain
        ITimechain(addressVault.timechain()).updateBalance(
            from,
            balanceOf(from)
        );
        ITimechain(addressVault.timechain()).updateBalance(to, balanceOf(to));
        return true;
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
        ITimechain(addressVault.timechain()).updateBalance(
            account,
            balanceOf(account)
        );
    }

    function burn(address account, uint256 amount) external {
        _burn(account, amount);
        ITimechain(addressVault.timechain()).updateBalance(
            account,
            balanceOf(account)
        );
    }
}
