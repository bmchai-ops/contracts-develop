import { ethers } from "hardhat";

async function main() {

  if (!process.env.MARKETPLACE_ADDRESS || !process.env.KKUB_ADDRESS) {
    throw new Error("Require env");
  }
  
  const Governance = await ethers.getContractFactory("Governance");
  const governance = await Governance.deploy(
    ethers.constants.AddressZero,
    "NXTTest",
    "NXT",
  );

  await governance.deployed();
  console.log(`Governance has been deployed to ${governance.address}`)
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
