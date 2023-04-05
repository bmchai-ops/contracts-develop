import { parseEther } from "ethers/lib/utils";
import { ethers } from "hardhat";
import getDeployer from "./deploy_new_wallet.local";

async function main() {
  if (
    !process.env.MARKETPLACE_ADDRESS ||
    !process.env.HARDHAT_PRIVATE_KEY ||
    !process.env.DEPLOYER_PRIVATE_KEY ||
    !process.env.DEPLOYER_ADDRESS
  ) {
    throw new Error("Require env");
  }

  const deployer = await getDeployer();

  // KYC
  const KYC = await ethers.getContractFactory("KYCBitkubChainV2");
  const kyc = await KYC.deploy(process.env.DEPLOYER_ADDRESS);
  console.log(`KYC Address: ${kyc.address}`);

  // KKUB
  const KKUB = await ethers.getContractFactory("KKUB");
  const kkub = await KKUB.deploy(process.env.DEPLOYER_ADDRESS, kyc.address);
  console.log(`KKUB address: ${kkub.address}`);

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
    kkub.address,
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
  console.log("DAO created..............");
  const vaultAddress = await daoFactory.addressVaultOf(
    await daoFactory.currentDaoId()
  );
  console.log(`Vaultaddress: ${vaultAddress}`);

  // const response = await tx.wait();
  // console.log(response);

  const addressVault = await ethers.getContractAt("AddressVault", vaultAddress);
  console.log(`DAOCore: ${await addressVault.daoCore()}`);
  console.log(`TimeChain: ${await addressVault.timechain()}`);
  console.log(`Governance: ${await addressVault.governance()}`);
  console.log(`BoardingPass: ${await addressVault.boardingpass()}`);
  console.log(`Proposal Factory: ${await addressVault.proposalFactory()}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
