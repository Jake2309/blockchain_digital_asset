// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./structs/LandInformation.sol";

// Contract definitions for NFT land tokens
contract Fino721Token is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 internal _initialSupply;
    string internal _description;
    string internal _images;
    uint256 internal _value;
    string public baseUri;
    uint256 internal _maxSupply;

    struct Revaluation{
        uint256 valuationDate;
        uint256 oldValue;
        uint256 newValue;
    }

    constructor(
        string memory _name, 
        string memory _symbol,
        string memory _uri,
        uint256 _max
    ) public ERC721(_name, _symbol) {
        baseUri = _uri;
        _maxSupply = _max;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setUri(string memory newUri) public onlyOwner {
        baseUri = newUri;
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= _maxSupply, "All token are minted!");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override (ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function getLandInfomation() public view returns (LandInformation memory){
         LandInformation memory landInfo = LandInformation({
            name: this.name(),
            symbol: this.symbol(),
            description: _description,
            images: _images,
            value: _value,
            totalQuantity: _initialSupply
         });

         return landInfo;
    }

    function setLandInfo(
        string memory landDescriptions,
        string memory landImages,
        uint256 landValue,
        uint256 landSupply
    ) external returns (bool){
        _description = landDescriptions;
        _images= landImages;
        _value= landValue;
        _initialSupply = landSupply;

        return true;
    }
}