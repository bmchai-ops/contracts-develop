// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./Governance.sol";
import "./BoardingPass.sol";

contract TokenFactory {
    address public mothership;
    uint256 currentDaoId;
    uint256 public constant ADDRESS_VAULT_CONTRACT_CODE = 100;
    address public marketplace;
    address public kkub;
    address public proposalFactory;
    address public owner;


    modifier onlyMothership {
      require(msg.sender == mothership, "permission: only DAOFactory");
      _;
    }
    modifier onlyOwner {
      require(msg.sender == owner, "permission: only owner");
      _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setMothership(address _mothership) external onlyOwner returns (address) {
        mothership = _mothership;
        return mothership;
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
        uint256 id,
        address addressVaultAddress,
        string calldata _govName,
        string calldata _govSymbol,
        string calldata _boardingpassName,
        string calldata _boardingpassSymbol
    ) onlyMothership external returns (address governance, address boardingpass) {
        // receive only KKUB creation fee

        bytes32 salt;
        uint256 code;
        address governanceAddress;
        address boardingpassAddress;

        // deploy Governance
        code = 102;
        salt = keccak256(abi.encodePacked(id, code));
        governanceAddress = address(
            new Governance{salt: salt}(
                addressVaultAddress,
                _govName,
                _govSymbol
            )
        );

        // deploy BoardingPass
        code = 103;
        salt = keccak256(abi.encodePacked(id, code));
        boardingpassAddress = address(
            new BoardingPass{salt: salt}(
                addressVaultAddress,
                _boardingpassName,
                _boardingpassSymbol
            )
        );
      return (
        governanceAddress,
        boardingpassAddress
      );
    }
}
