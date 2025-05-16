const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

const contractAddress = "<DEPLOYED_CONTRACT_ADDRESS>"; // Replace this with your actual deployed contract address
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

// Save API key to localStorage
document.querySelector(".card form").addEventListener("submit", (e) => {
  e.preventDefault();
  const apiKey = document.getElementById("api-key").value;
  localStorage.setItem("nftStorageApiKey", apiKey);
  alert("API Key saved.");
});

// Mint NFT
document.getElementById("mint-form").addEventListener("submit", async (e) => {
  e.preventDefault();
  const status = document.getElementById("status");
  status.innerText = "Minting in progress...";

  try {
    const mintPrice = await nftContract.mintPrice();
    const tx = await nftContract.mintNFT({ value: mintPrice });
    await tx.wait();
    status.innerText = "✅ NFT Minted Successfully!";
  } catch (error) {
    console.error(error);
    status.innerText = "❌ Minting Failed! See console for details.";
  }
});
