// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title DataNFT
 * @notice 赛博回收数据 NFT 合约
 * @dev 实现数据所有权 NFT + 自动版税分配（Web4.0 数据主权）
 */
contract DataNFT is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct DataMetadata {
        string ipfsCID;
        string dataType;
        uint256 qualityLevel;
        address originalOwner;
        uint256 royaltyPercent;
        bool isSanitized;
        bytes zkProof;
        uint256 createdAt;
    }

    mapping(uint256 => DataMetadata) public dataMetadata;
    mapping(uint256 => address) public currentOwner;
    mapping(address => uint256[]) public ownerTokens;

    event DataMinted(uint256 indexed tokenId, address indexed minter, string dataType, uint256 qualityLevel);
    event DataTransferred(uint256 indexed tokenId, address indexed from, address indexed to, uint256 royaltyPaid);
    event RoyaltyDistributed(uint256 indexed tokenId, address indexed originalOwner, uint256 amount);

    constructor() ERC721("CyberRecycleData", "CRD") {}

    function mintData(
        string memory ipfsCID,
        string memory dataType,
        uint256 qualityLevel,
        bytes memory zkProof
    ) public returns (uint256) {
        require(qualityLevel >= 1 && qualityLevel <= 5, "Invalid quality level");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        
        _safeMint(msg.sender, tokenId);
        
        dataMetadata[tokenId] = DataMetadata({
            ipfsCID: ipfsCID,
            dataType: dataType,
            qualityLevel: qualityLevel,
            originalOwner: msg.sender,
            royaltyPercent: 2000,
            isSanitized: true,
            zkProof: zkProof,
            createdAt: block.timestamp
        });
        
        currentOwner[tokenId] = msg.sender;
        ownerTokens[msg.sender].push(tokenId);
        
        emit DataMinted(tokenId, msg.sender, dataType, qualityLevel);
        return tokenId;
    }

    function transferWithRoyalty(uint256 tokenId, address to) public payable {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        require(to != address(0), "Invalid address");
        require(msg.value > 0, "No payment");
        
        address originalOwner = dataMetadata[tokenId].originalOwner;
        address currentSeller = msg.sender;
        uint256 price = msg.value;
        uint256 royalty = (price * dataMetadata[tokenId].royaltyPercent) / 10000;
        uint256 sellerAmount = price - royalty;
        
        (bool royaltySuccess, ) = payable(originalOwner).call{value: royalty}("");
        require(royaltySuccess, "Royalty transfer failed");
        
        (bool sellerSuccess, ) = payable(currentSeller).call{value: sellerAmount}("");
        require(sellerSuccess, "Seller payment failed");
        
        currentOwner[tokenId] = to;
        _transfer(currentSeller, to, tokenId);
        
        emit RoyaltyDistributed(tokenId, originalOwner, royalty);
        emit DataTransferred(tokenId, currentSeller, to, royalty);
    }

    function getDataMetadata(uint256 tokenId) public view returns (DataMetadata memory) {
        require(_ownerOf(tokenId) != address(0), "Token does not exist");
        return dataMetadata[tokenId];
    }

    function getOwnerTokens(address owner) public view returns (uint256[] memory) {
        return ownerTokens[owner];
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
