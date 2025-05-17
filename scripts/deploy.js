require("@nomiclabs/hardhat-ethers");
require("dotenv").config(); // Loads environment variables from .env

const { ethers } = require("hardhat");

async function main() {
  const MintPrice = ethers.utils.parseEther("0.05"); // 0.05 Ether
  const MaxSupply = 100; // Limit to 100 NFTs

  const NFTMintingPlatform = await ethers.getContractFactory(
    "NFTMintingPlatform"
  );
  const nftPlatform = await NFTMintingPlatform.deploy(MintPrice, MaxSupply);

  await nftPlatform.deployed();
  console.log("NFTMintingPlatform deployed to:", nftPlatform.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

module.exports = {
  solidity: "0.8.20", // Match your contract's Solidity version
  networks: {
    base: {
      url: "https://mainnet.base.org", // Base Mainnet RPC URL
      chainId: 8453,
      accounts: [process.env.PRIVATE_KEY], // Use .env to keep private key secure
    },
  },
};
