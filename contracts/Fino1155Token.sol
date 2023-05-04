// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Fino1155Token is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public maxSupply;
    uint256 internal _currentSupply = 0;
    // uint256 public tokenId;
    string[] public names; //string array of name
    uint[] public ids; //uint array of ids
    string public baseMetadataURI; //the token metadata URI
    string public name; //the token mame
    address public nftOwner;
    uint public mintFee = 0 wei; //mintfee, 0 by default. only used in mint function, not batch.

    mapping(string => uint) public nameToId; //name to id mapping
    mapping(uint => string) public idToName; //id to name mapping

    constructor(
        address _nftOwner,
        string memory _symbol,
        uint256 _id,
        string memory _uri,
        uint256 _maxSupply
    ) ERC1155(_uri) {
        nftOwner = _nftOwner;
        ids.push(_id);
        maxSupply = _maxSupply;
        name = _symbol;
        names.push(_symbol);
        setURI(_uri);
        baseMetadataURI = _uri;
        nameToId[_symbol] = _id;
        idToName[_id] = _symbol;
        mint(_nftOwner, _id, _maxSupply);

        // transfer nft to creator, by default nft holded by contract address
        // transferOwnership(tx.origin);
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /*
    set a mint fee. only used for mint, not batch.
    */
    function setFee(uint _fee) public onlyOwner {
        mintFee = _fee;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    /* Mint new amount of token to address provide with token id type */
    function mint(address to, uint256 tokenId, uint256 amount)
        public
        payable 
    {
        require(msg.value == mintFee, 'Fee does not match');
        _currentSupply += amount;
        require(_currentSupply <= maxSupply, "All tokens are minted!");
        _mint(to, tokenId, amount, "");
        // _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory _ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, _ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory _ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, _ids, amounts, data);
    }

    function approveToken(address to, bool approved) external {
        _setApprovalForAll(address(this), to, approved);
    }

    function transferToken(address from, address to, uint256 tokenId, uint256 amount) external {
        _safeTransferFrom(from, to, tokenId, amount, "");
    }

    function lendingAsset() external {}

    function settleContract() external {}
}