// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

// import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract Fino1155Wallet is AccessControl, ERC1155Holder{
    IERC1155 internal token;
    address public walletOwner;

    bytes32 internal constant ISSUER_ROLE = keccak256("ISSUER_ROLE");
    constructor(address _owner, IERC1155 _token){
        walletOwner = _owner;
        token = _token;
    }

    function setIssuer() external {
        _grantRole(ISSUER_ROLE, walletOwner);
    }

    function transferToken(
        address _to,
        uint256 _tokenId,
        uint256 _amount
    ) public {
        uint256 totalAmount = token.balanceOf(walletOwner, _tokenId);
        require(totalAmount >= _amount, "Not enough amount!");
        token.safeTransferFrom(walletOwner, _to, _tokenId, _amount, "");
    }

    function getBalance(uint256 _tokenId) public view returns (uint256){
        require(walletOwner == msg.sender, "Only owner");
        return token.balanceOf(walletOwner, _tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155Receiver, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // function onERC1155Received(
    //     address operator, 
    //     address from, 
    //     uint256 id, 
    //     uint256 value, 
    //     bytes memory data
    // ) public override returns (bytes4) {

    //     bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    // }

    // function onERC1155BatchReceived(
    //     address operator, 
    //     address from, 
    //     uint256[] memory ids, 
    //     uint256[] memory values, 
    //     bytes memory data
    // ) public override returns (bytes4) {

    //     bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    // }
}