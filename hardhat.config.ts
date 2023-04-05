import { HardhatUserConfig } from "hardhat/config";
import { config as dotEnvConfig } from 'dotenv';
import { resolve } from 'path';
import "hardhat-contract-sizer";
import "@nomicfoundation/hardhat-toolbox";


dotEnvConfig({ path: resolve(__dirname, './.env') });

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    bkcTestnet: {
      chainId: 25925,
      url: "https://rpc-testnet.bitkubchain.io",
      accounts: [process.env.DEPLOYER_PRIVATE_KEY as string],
    },
    localhost: {
      chainId: 31337,
      url: "http://127.0.0.1:8545",
      accounts: [process.env.DEPLOYER_PRIVATE_KEY as string],
    }
  
  },
}

export default config;


