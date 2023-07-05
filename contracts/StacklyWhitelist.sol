// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";

error NotAllowed(address, address, uint256, bytes);
error AlreadyMinted();
error MaxSupplyReached();

contract StacklyWhitelist is ERC721, Ownable {
  using Counters for Counters.Counter;
  
  string private baseURI;
  uint256 public maxSupply;
  Counters.Counter private tokenIdCounter;

  constructor(string memory _name, string memory _symbol, string memory __baseURI) ERC721(_name, _symbol) {
    maxSupply = 1000;
    baseURI = __baseURI;
    tokenIdCounter.increment();
  }

  function getBetaAccess() external {
    if (balanceOf(msg.sender) > 0) {
      revert AlreadyMinted();
    }

    if (totalSupply() >= maxSupply) {
      revert MaxSupplyReached();
    }

    uint256 tokenId = tokenIdCounter.current();
    tokenIdCounter.increment();
    _safeMint(msg.sender, tokenId);
  }

  function mintTo(address to) external onlyOwner {
    uint256 tokenId = tokenIdCounter.current();
    tokenIdCounter.increment();
    _safeMint(to, tokenId);
  }

  function totalSupply() public view returns (uint256) {
    return tokenIdCounter.current() - 1;
  }

  function _baseURI() internal view override returns (string memory) {
    return baseURI;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
      _requireMinted(tokenId);
      return _baseURI();
  }

  function setBaseURI(string memory __baseURI) external onlyOwner {
    baseURI = __baseURI;
  }

  function setMaxSupply(uint256 _maxSupply) external onlyOwner {
    maxSupply = _maxSupply;
  }

  function transferFrom(address from, address to, uint256 tokenId) public virtual override {
    bytes memory data;
    revert NotAllowed(from, to, tokenId, data);
  }

  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
    revert NotAllowed(from, to, tokenId, data);
  }
}
