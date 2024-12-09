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
