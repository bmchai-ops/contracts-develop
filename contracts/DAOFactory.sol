// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./interfaces/IAddressVault.sol";
import "./AddressVault.sol";
import "./DAOCore.sol";
import "./Timechain.sol";

import "./interfaces/ITokenFactory.sol";

contract DAOFactory {
    uint256 public currentDaoId;
    uint256 public constant ADDRESS_VAULT_CONTRACT_CODE = 100;
    address public marketplace;
    address public kkub;
    address public proposalFactory;
    address public tokenFactory;

    constructor(
        address _marketplace,
        address _kkub,
        address _proposalFactory,
        address _tokenFactory
    ) {
        marketplace = _marketplace;
        kkub = _kkub;
        proposalFactory = _proposalFactory;
        tokenFactory = _tokenFactory;
    }

    /* @dev create function deploy these contracts below respectively
     *
     * CONTRACT NAME        CONTRACT CODE
     * - AddressVault       (100)
     * - DAOCore            (101)
     * - Governance         (102)
     * - BoardingPass       (103)
     * - Timechain          (104)
     *
     * Parameter `salt` of each contract is calculated by using keccak256(daoId, contract_code)
     */

    function create(
        string calldata _govName,
        string calldata _govSymbol,
        string calldata _boardingpassName,
        string calldata _boardingpassSymbol
    ) external returns (uint256){
        currentDaoId += 1;
        address vault = _create(currentDaoId);
        (
            address governanceAddress,
            address boardingpassAddress
        ) = _createToken(currentDaoId, vault, _govName, _govSymbol, _boardingpassName, _boardingpassSymbol);

        IAddressVault addressVault = IAddressVault(vault);
        addressVault.setGovernance(governanceAddress);
        addressVault.setBoardingPass(boardingpassAddress);
        return currentDaoId;
    }

    function _create(uint256 id) private returns (address) {
        // receive onlyKKUB creation fee

        address result;
        IAddressVault addressVault;
        address addressVaultAddress;
        bytes32 salt;
        uint256 code;

        // deploy AddressVault
        code = 100;
        salt = keccak256(abi.encodePacked(id, code));
        addressVaultAddress = address(new AddressVault{salt: salt}());
        addressVault = IAddressVault(addressVaultAddress);
        addressVault.setLeader(msg.sender);

        // Set marketplace and kkub

        addressVault.setMarketplace(marketplace);
        addressVault.setProposalFactory(proposalFactory);
        addressVault.setKKUB(kkub);

        // deploy DAOCore
        code = 101;
        salt = keccak256(abi.encodePacked(id, code));
        result = address(new DAOCore{salt: salt}(addressVaultAddress));
        addressVault.setDaoCore(result);

        

        // deploy Timechain
        code = 104;
        salt = keccak256(abi.encodePacked(id, code));
        result = address(new Timechain{salt: salt}(addressVaultAddress));
        addressVault.setTimechain(result);
        return addressVaultAddress;
    }

    function _createToken(
        uint256 id,
        address addressVaultAddress,
        string memory _govName,
        string memory _govSymbol,
        string memory _boardingpassName,
        string memory _boardingpassSymbol
    ) private returns (address, address) {
        return
            ITokenFactory(tokenFactory).create(
                id,
                addressVaultAddress,
                _govName,
                _govSymbol,
                _boardingpassName,
                _boardingpassSymbol
            );
    }

    function addressVaultOf(uint256 daoId) external view returns (address) {
        return _addressVaultOf(daoId);
    }

    function _addressVaultOf(uint256 daoId) internal view returns (address) {
        bytes32 salt = keccak256(
            abi.encodePacked(daoId, ADDRESS_VAULT_CONTRACT_CODE)
        );
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(type(AddressVault).creationCode)
            )
        );
        return address(uint160(uint256(hash)));
    }
}
