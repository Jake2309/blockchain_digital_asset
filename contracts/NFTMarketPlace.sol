// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./Fino1155Factory.sol";
import "@ganache/console.log/console.sol";

contract NFTMarketPlace is ReentrancyGuard,ERC1155Holder{
    using Counters for Counters.Counter;
    Counters.Counter private _nftsSold;
    Counters.Counter private _nftCount;
    uint256 public LISTING_FEE = 0.0001 ether;
    address payable private _marketOwner;
    mapping(uint256 => NFT) private _idToNFT;

    Fino1155Factory internal _fino1155Factory;

    address payable public marketowner;

    enum State { Created, Release, Inactive }
    event NFTListed(
        address nftContract,
        uint256 tokenId,
        address seller,
        address owner,
        uint256 price,
        uint256 quantity
    );
    event NFTSold(
        address nftContract,
        uint256 tokenId,
        address seller,
        address owner,
        uint256 price,
        uint256 quantity
    );

    struct NFT {
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        uint256 quantity;
        bool isListed;
    }

    constructor(address factoryAddress) {
        _marketOwner = payable(msg.sender);
        _fino1155Factory = Fino1155Factory(factoryAddress);
    }

    // List the NFT on the marketplace
    function listNft(address _nftContract, uint256 _tokenId, uint256 _quantity, uint256 _price) public payable nonReentrant {
        require(_price > 0, "Price must be at least 1 wei");
        require(msg.value <= LISTING_FEE, "Not enough ether for listing fee");

        // Transfer 1155 token to market place address
        console.log("got here");
        console.log(msg.sender);
        console.log(_nftContract);
        // ERC1155(_nftContract).setApprovalForAll(msg.sender, true);
        // Fino1155Token(_nftContract).transferToken(msg.sender, address(this), _tokenId, _quantity, "");
        _fino1155Factory.transferToken(msg.sender, address(this), _tokenId, _quantity);
        // IERC1155(_nftContract).safeTransferFrom(msg.sender, address(this), _tokenId, _quantity, "");
        _marketOwner.transfer(LISTING_FEE);
        _nftCount.increment();

        _idToNFT[_tokenId] = NFT(
            _nftContract,
            _tokenId, 
            payable(msg.sender),
            payable(address(this)),
            _price,
            _quantity,
            true
        );

        emit NFTListed(_nftContract, _tokenId, msg.sender, address(this), _price, _quantity);
    }

    // Buy an NFT
    function buyNft(address _nftContract, uint256 _tokenId, uint256 _quantity) public payable nonReentrant {
        NFT storage nft = _idToNFT[_tokenId];
        require(msg.value >= nft.price, "Not enough ether to cover asking price");

        address payable buyer = payable(msg.sender);
        payable(nft.seller).transfer(msg.value);
        IERC1155(_nftContract).safeTransferFrom(address(this), buyer, _tokenId, _quantity, "");
        nft.owner = buyer;
        nft.quantity -= _quantity;
        if(nft.quantity == 0){
            nft.isListed = false;
            _nftsSold.increment();
        }

        // 
        emit NFTSold(_nftContract, nft.tokenId, nft.seller, buyer, msg.value, nft.quantity);
    }

    // Resell an NFT purchased from the marketplace
    function resellNft(address _nftContract, uint256 _tokenId, uint256 _price, uint256 _quantity) public payable nonReentrant {
        require(_price > 0, "Price must be at least 1 wei");
        require(msg.value == LISTING_FEE, "Not enough ether for listing fee");

        IERC1155(_nftContract).safeTransferFrom(msg.sender, address(this), _tokenId, _quantity, "");

        NFT storage nft = _idToNFT[_tokenId];
        nft.seller = payable(msg.sender);
        nft.owner = payable(address(this));
        nft.price = _price;
        nft.quantity += _quantity;
        if(nft.isListed == false){
            _nftsSold.decrement();
        }
        nft.isListed = true;
        
        emit NFTListed(_nftContract, _tokenId, msg.sender, address(this), _price, _quantity);
    }

    function getListedNfts() public view returns (NFT[] memory) {
        uint256 nftCount = _nftCount.current();
        uint256 unsoldNftsCount = nftCount - _nftsSold.current();

        NFT[] memory nfts = new NFT[](unsoldNftsCount);
        uint nftsIndex = 0;
        for (uint i = 0; i < nftCount; i++) {
            if (_idToNFT[i + 1].isListed) {
                nfts[nftsIndex] = _idToNFT[i + 1];
                nftsIndex++;
            }
        }
        return nfts;
    }

    function getMyNfts() public view returns (NFT[] memory) {
        uint nftCount = _nftCount.current();
        uint myNftCount = 0;
        for (uint i = 0; i < nftCount; i++) {
            if (_idToNFT[i + 1].owner == msg.sender) {
                myNftCount++;
            }
        }

        NFT[] memory nfts = new NFT[](myNftCount);
        uint nftsIndex = 0;
        for (uint i = 0; i < nftCount; i++) {
            if (_idToNFT[i + 1].owner == msg.sender) {
                nfts[nftsIndex] = _idToNFT[i + 1];
                nftsIndex++;
            }
        }
        return nfts;
    }

    function getMyListedNfts() public view returns (NFT[] memory) {
        uint nftCount = _nftCount.current();
        uint myListedNftCount = 0;
        for (uint i = 0; i < nftCount; i++) {
            if (_idToNFT[i + 1].seller == msg.sender && _idToNFT[i + 1].isListed) {
                myListedNftCount++;
            }
        }

        NFT[] memory nfts = new NFT[](myListedNftCount);
        uint nftsIndex = 0;
        for (uint i = 0; i < nftCount; i++) {
            if (_idToNFT[i + 1].seller == msg.sender && _idToNFT[i + 1].isListed) {
                nfts[nftsIndex] = _idToNFT[i + 1];
                nftsIndex++;
            }
        }
        return nfts;
    }
}