import { ethers } from "hardhat";

async function main() {

  if (!process.env.MARKETPLACE_ADDRESS || !process.env.KKUB_ADDRESS) {
    throw new Error("Require env");
  }

  // Proposal Factory ///////////////////////////////////////////////////////
  const ProposalFactory = await ethers.getContractFactory("ProposalFactory");
  const proposalFactory = await ProposalFactory.deploy();

  await proposalFactory.deployed();

  console.log(`ProposalFactory: ${proposalFactory.address}`)

  // Token Factory ///////////////////////////////////////////////////////
  const TokenFactory = await ethers.getContractFactory("TokenFactory");
  const tokenFactory = await TokenFactory.deploy();

  await tokenFactory.deployed();

  console.log(`TokenFactory: ${tokenFactory.address}`);
  
  // Dao Factory ///////////////////////////////////////////////////////
  const DAOFactory = await ethers.getContractFactory("DAOFactory");
  const daoFactory = await DAOFactory.deploy(
    process.env.MARKETPLACE_ADDRESS, 
    process.env.KKUB_ADDRESS,
    proposalFactory.address,
    tokenFactory.address
  );

  await daoFactory.deployed();

  console.log(`DAOFactory: ${daoFactory.address}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
