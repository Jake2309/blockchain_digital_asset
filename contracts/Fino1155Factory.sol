// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./Fino1155Token.sol";

// Contract definitions for Management token: Create new token, burn, transfer, revaluation
contract Fino1155Factory{
    mapping(address => Fino1155Token) public tokenMap; // a mapping list with key is address and value is tokenId
    mapping(uint256 => address) public idToTokenAddress;

    event ERC1155Created(address owner, address tokenContract); //emitted when ERC1155 token is deployed
    event ERC1155Minted(address owner, address tokenContract, uint amount); //emmited when ERC1155 token is minted

    function deployERC1155(
        string memory _contractName, 
        string memory _uri,
        uint256 _tokenId,
        uint256 _maxSupply
    ) public returns (address) {
        Fino1155Token t = new Fino1155Token(_contractName, _tokenId, _uri, _maxSupply);
        tokenMap[address(t)] = t;
        idToTokenAddress[_tokenId] = address(t);
        
        emit ERC1155Created(msg.sender,address(t));
        return address(t);
    }

    function getAddressById(uint256 tokenId) public view returns (address tokenAddress){
        return idToTokenAddress[tokenId];
    }

    function mintERC1155(address to, uint tokenId, uint256 amount) public {
        tokenMap[idToTokenAddress[tokenId]].mint(to, tokenId, amount);
        emit ERC1155Minted(to, idToTokenAddress[tokenId], amount);
    }

    function getERC1155token(address owner, address tokenAddress, uint256 tokenId) public view returns (
        address _contract,
        address _owner,
        string memory _uri,
        uint supply
    ){
            return (
                address(tokenMap[tokenAddress]), 
                tokenMap[tokenAddress].owner(), 
                tokenMap[tokenAddress].uri(tokenId), 
                tokenMap[tokenAddress].balanceOf(owner, tokenId));
    }
}