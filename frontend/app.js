const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

const contractAddress = "<DEPLOYED_CONTRACT_ADDRESS>";
const contractABI = [
  {
    inputs: [
      { internalType: "uint256", name: "_mintPrice", type: "uint256" },
      { internalType: "uint256", name: "_maxSupply", type: "uint256" },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "mintNFT",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
];

const nftContract = new ethers.Contract(contractAddress, contractABI, signer);

document.getElementById("mint-form").addEventListener("submit", async (e) => {
  e.preventDefault();

  const tokenURI = document.getElementById("tokenURI").value;

  try {
    const mintPrice = await nftContract.mintPrice();
    const tx = await nftContract.mintNFT(tokenURI, { value: mintPrice });
    await tx.wait();

    document.getElementById("status").innerText = "NFT Minted Successfully!";
  } catch (error) {
    console.error(error);
    document.getElementById("status").innerText = "Minting Failed!";
  }
});
