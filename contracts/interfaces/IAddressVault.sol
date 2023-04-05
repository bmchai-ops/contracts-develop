// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IAddressVault {
    function setLeader(address _new) external;

    function setDaoFactory(address _new) external;

    function setDaoCore(address _new) external;

    function setGovernance(address _new) external;

    function setBoardingPass(address _new) external;

    function setTimechain(address _new) external;

    function setProposalFactory(address _new) external;

    function setMarketplace(address _new) external;

    function setKKUB(address _new) external;

    function daoFactory() external view returns (address);

    function daoCore() external view returns (address);

    function governance() external view returns (address);

    function boardingpass() external view returns (address);

    function timechain() external view returns (address);

    function proposalFactory() external view returns (address);

    function marketplace() external view returns (address);

    function kkub() external view returns (address);
}
