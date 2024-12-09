// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMintingPlatform is ERC721URIStorage, Ownable {
    uint256 public mintPrice;
    uint256 public maxSupply;
    uint256 public totalSupply;

    constructor(uint256 _mintPrice, uint256 _maxSupply) ERC721("MyNFT", "MNFT") {
        mintPrice = _mintPrice;
        maxSupply = _maxSupply;
        totalSupply = 0;
    }

    function mintNFT(string memory tokenURI) public payable {
        require(totalSupply < maxSupply, "Max supply reached");
        require(msg.value == mintPrice, "Incorrect minting fee");

        uint256 newTokenId = totalSupply + 1;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        totalSupply++;
    }

    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
