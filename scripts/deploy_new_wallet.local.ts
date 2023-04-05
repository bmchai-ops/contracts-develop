import { parseEther } from "ethers/lib/utils";
import { ethers } from "hardhat";

const getDeployer = async () => {
  if (
    !process.env.MARKETPLACE_ADDRESS ||
    !process.env.HARDHAT_PRIVATE_KEY ||
    !process.env.DEPLOYER_PRIVATE_KEY ||
    !process.env.DEPLOYER_ADDRESS
  ) {
    throw new Error("Require env");
  }

  const provider = new ethers.providers.JsonRpcProvider(
    "http://127.0.0.1:8545"
  );
  // const deployer = new ethers.Wallet(process.env.DEPLOYER_PRIVATE_KEY).connect(
  const deployer = new ethers.Wallet(process.env.HARDHAT_PRIVATE_KEY).connect(
    provider
  );

  await deployer.sendTransaction({
    to: process.env.DEPLOYER_ADDRESS,
    value: parseEther("9000"),
  });
  console.log("Fetch Ether already!")

  return deployer;
};

export default getDeployer;
