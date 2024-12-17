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

contract MintChainly is ERC721Enumerable, Ownable {
    uint256 public maxSupply;
    uint256 public mintPrice;
    mapping(uint256 => string) private _tokenURIs;

    struct RoyaltyInfo {
        address recipient;
        uint256 percentage; // Royalty percentage (out of 10000, e.g., 500 = 5%)
    }

    mapping(uint256 => RoyaltyInfo) private _royalties;

    constructor(string memory name, string memory symbol, uint256 _maxSupply, uint256 _mintPrice) ERC721(name, symbol) {
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
    }

    function mint(string memory tokenURI) public payable {
        require(totalSupply() < maxSupply, "Max supply reached");
        require(msg.value >= mintPrice, "Insufficient funds");

        uint256 tokenId = totalSupply() + 1;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function batchMint(string[] memory tokenURIs) public payable {
        require(totalSupply() + tokenURIs.length <= maxSupply, "Max supply exceeded");
        require(msg.value >= mintPrice * tokenURIs.length, "Insufficient funds");

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            uint256 tokenId = totalSupply() + 1;
            _mint(msg.sender, tokenId);
            _setTokenURI(tokenId, tokenURIs[i]);
        }
    }

    function setRoyalty(uint256 tokenId, address recipient, uint256 percentage) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can set royalties");
        require(percentage <= 1000, "Royalty percentage too high");
        _royalties[tokenId] = RoyaltyInfo(recipient, percentage);
    }

    function royaltyInfo(uint256 tokenId) public view returns (address, uint256) {
        RoyaltyInfo memory info = _royalties[tokenId];
        return (info.recipient, info.percentage);
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal virtual {
        require(_exists(tokenId), "URI set of nonexistent token");
        _tokenURIs[tokenId] = tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // Marketplace integration
    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings;

    function listToken(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can list the token");
        require(price > 0, "Price must be greater than zero");

        listings[tokenId] = Listing(msg.sender, price);
        approve(address(this), tokenId); // Approve the marketplace to transfer the token
    }

    function buyToken(uint256 tokenId) public payable {
        Listing memory listing = listings[tokenId];
        require(listing.price > 0, "Token is not listed for sale");
        require(msg.value >= listing.price, "Insufficient funds");

        address seller = listing.seller;
        _transfer(seller, msg.sender, tokenId);

        // Handle royalties
        RoyaltyInfo memory royalty = _royalties[tokenId];
        uint256 royaltyAmount = (msg.value * royalty.percentage) / 10000;
        if (royalty.recipient != address(0) && royaltyAmount > 0) {
            payable(royalty.recipient).transfer(royaltyAmount);
        }

        payable(seller).transfer(msg.value - royaltyAmount);

        delete listings[tokenId];
    }

    function cancelListing(uint256 tokenId) public {
        require(listings[tokenId].seller == msg.sender, "Only the seller can cancel the listing");
        delete listings[tokenId];
    }
}
