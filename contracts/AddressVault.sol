// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract AddressVault {
    modifier onlyDaoFactory() {
        require(msg.sender == daoFactory, "permission: only daoFactory");
        _;
    }

    event SetDaoFactory(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetDaoCore(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetGovernance(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetBoardingPass(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetTimechain(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetProposalFactory(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetLeader(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetMarketplace(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );
    event SetKKUB(
        address indexed _caller,
        address indexed _old,
        address indexed _new
    );

    address public daoFactory;
    address public daoCore;
    address public governance;
    address public boardingpass;
    address public timechain;
    address public proposalFactory;
    address public leader;
    address public marketplace;
    address public kkub;

    constructor() {
        daoFactory = msg.sender;
    }

    function setLeader(address _new) external onlyDaoFactory {
        address old = leader;
        leader = _new;
        emit SetLeader(msg.sender, old, leader);
    }

    function setDaoFactory(address _new) external onlyDaoFactory {
        address old = daoFactory;
        daoFactory = _new;
        emit SetDaoFactory(msg.sender, old, daoFactory);
    }

    function setDaoCore(address _new) external onlyDaoFactory {
        address old = daoCore;
        daoCore = _new;
        emit SetDaoCore(msg.sender, old, daoCore);
    }

    function setGovernance(address _new) external onlyDaoFactory {
        address old = governance;
        governance = _new;
        emit SetGovernance(msg.sender, old, governance);
    }

    function setBoardingPass(address _new) external onlyDaoFactory {
        address old = boardingpass;
        boardingpass = _new;
        emit SetBoardingPass(msg.sender, old, boardingpass);
    }

    function setTimechain(address _new) external onlyDaoFactory {
        address old = timechain;
        timechain = _new;
        emit SetTimechain(msg.sender, old, timechain);
    }

    function setProposalFactory(address _new) external onlyDaoFactory {
        address old = proposalFactory;
        proposalFactory = _new;
        emit SetProposalFactory(msg.sender, old, proposalFactory);
    }

    function setMarketplace(address _new) external onlyDaoFactory {
        address old = marketplace;
        marketplace = _new;
        emit SetProposalFactory(msg.sender, old, marketplace);
    }

    function setKKUB(address _new) external onlyDaoFactory {
        address old = kkub;
        kkub = _new;
        emit SetProposalFactory(msg.sender, old, kkub);
    }
}
