import { ethers } from "hardhat";

async function main() {
  if (
    !process.env.MARKETPLACE_ADDRESS ||
    !process.env.KKUB_ADDRESS ||
    !process.env.DEPLOYER_PRIVATE_KEY
  ) {
    throw new Error("Require env");
  }

  const provider = new ethers.providers.JsonRpcProvider(
    "http://127.0.0.1:8545"
  );

  const deployer = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY).connect(
    provider
  );

  // Proposal Factory ///////////////////////////////////////////////////////
  const ProposalFactory = await ethers.getContractFactory("ProposalFactory");
  const proposalFactory = await ProposalFactory.deploy();

  await proposalFactory.deployed();

  console.log(`ProposalFactory: ${proposalFactory.address}`);

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
  console.log(`DAOFactory: ${daoFactory.address}`);

  console.log("Setting Mothership...");
  await tokenFactory.connect(deployer).setMothership(daoFactory.address);
  console.log(`Mothership is set to ${await tokenFactory.mothership()}`);

  /// Create DAO

  const tx = await daoFactory
    .connect(deployer)
    .create("GOVTEST", "GOVTEST", "BPTEST", "BPTEST");
  
  const vaultAddress = await daoFactory.addressVaultOf(await daoFactory.currentDaoId());
  console.log(vaultAddress)
  

  // const response = await tx.wait();
  // console.log(response);

  const addressVault = await ethers.getContractAt("AddressVault", vaultAddress);
  console.log(await addressVault.daoCore())
  console.log(await addressVault.timechain())
  console.log(await addressVault.governance())
  console.log(await addressVault.boardingpass())
  console.log(await addressVault.proposalFactory())

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});