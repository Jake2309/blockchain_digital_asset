// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Fino1155Token.sol";

contract Fino1155Factory is Ownable{
    mapping(uint256 => address) internal _token1155Maps;
    event ERC1155Created(address owner, address tokenContract); //emitted when ERC1155 token is deployed

    function create1155Token(
        string memory _contractName, 
        string memory _uri,
        uint256 _tokenId,
        uint256 _maxSupply
    ) external returns (address) {
        Fino1155Token t = new Fino1155Token(msg.sender, _contractName, _tokenId, _uri, _maxSupply);
        t.approveToken(msg.sender, true);
        _token1155Maps[_tokenId] = address(t);

        emit ERC1155Created(msg.sender,address(t));
        return address(t);
    }

    function setApproveAll(uint256 _tokenId, address to) external{
        Fino1155Token(_token1155Maps[_tokenId]).approveToken(to, true);
    }

    function transferToken(address from, address to, uint256 _tokenId, uint256 amount) external {
        Fino1155Token(_token1155Maps[_tokenId]).transferToken(from, to, _tokenId, amount);
    }

    function mintERC1155(
        address to, 
        uint tokenId, 
        uint256 amount
    ) external onlyOwner{
        Fino1155Token(_token1155Maps[tokenId]).mint(to, tokenId, amount);
    }

    function get1155BalanceByAddress (
        address tokenOwner, 
        uint256 tokenId
    ) external view returns (uint256) {
        return Fino1155Token(_token1155Maps[tokenId]).balanceOf(tokenOwner, tokenId);
    }
}