# MintChainly

<a href="https://mintchainly.netlify.app/">MintChainly</a> is a simple user-friendly NFT minting platform where users can create unique digital assets on the blockchain. It allows minting NFTs with metadata, ensures scarcity through a max supply, and supports viewing and transferring NFTs.

## Features

- Mint unique NFTs by paying a small fee.
- Enforce max supply to create scarcity.
- Simple and intuitive user interface.

## Technologies Used

- <strong>Solidity:</strong> Smart contract development.
- <strong>Hardhat:</strong> Development and testing framework.
- <strong>HTML/CSS:</strong> Responsive frontend design.
- <strong>JavaScript:</strong> Frontend interaction with the blockchain using Ethers.js.

## Running the Project

1. <strong> Set Up the Environment: </strong>

- Install Node.js and Hardhat.

2. <strong>Deploy the Contract:</strong>

   `   npx hardhat run scripts/deploy.js --network <your-network>`

3. <strong>Run the Frontend:</strong>

- Open `index.html` in a browser.

4. <strong>Mint Your NFT:</strong>

- Enter the metadata URI and click "Mint NFT" to create your unique asset.

## License

This project is licensed under the MIT License. Feel free to use and modify it as needed.
