// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./Fino721Token.sol";
import "./Fino1155Token.sol";
import "./StringUtils.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";
// import "@ganache/console.log/console.sol";
import "./structs/LandInformation.sol";
// import "truffle/console.sol";

// Contract definitions for Management token: Create new token, burn, transfer, revaluation
contract TokenFactory{
    mapping (address => Fino721Token) public mappingItems;
    Fino721Token[] public lands;

    // mapping(address => Land1155Token) public mappingLands;
    Fino1155Token[] public listToken1155; //an array that contains different ERC1155 tokens deployed
    mapping(uint256 => address) public indexToContract; //index to contract address mapping
    mapping(uint256 => address) public indexToOwner; //index to ERC1155 owner address

    event ERC1155Created(address owner, address tokenContract); //emitted when ERC1155 token is deployed
    event ERC1155Minted(address owner, address tokenContract, uint amount); //emmited when ERC1155 token is minted

    event ERC721TokenCreated(address tokenAddress);
    event ERC721TokenTransfered(Fino721Token tokenInfo);
    // event ERC721SetLandInfo(LandNFTToken tokenInfo);
    
    // Create new token with provided address 
    function deployERC721(
        string memory _name, 
        string memory _symbol,
        string memory _uri,
        uint256 _max
    ) public returns (address){
        // require((address(_ownerAddress) != address(0)), "Invalid token address");
        require(!StringUtils.isEmpty(_name), "Invalid token name");
        require(!StringUtils.isEmpty(_symbol), "Invalid token symbol");

        Fino721Token newToken = new Fino721Token({
            _name: _name,
            _symbol: _symbol,
            _uri: _uri,
            _max: _max
        });

        // newToken.setLandInfo(_name, _symbol, "Test description", "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.remove.bg%2Fsample_images&psig=AOvVaw3wqP4d_in77GDIzgKd8Xx-&ust=1680105421395000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCOi3_Mf-_v0CFQAAAAAdAAAAABAE", 1000000000, 1000);
        
        address deployedAddress = address(newToken);

        // string memory addressStr = Strings.toHexString(uint256(uint160(deployedAddress)), 20);

        // newToken.safeMint(deployedAddress, "http://localhost:3001");

        mappingItems[deployedAddress] = newToken;
        lands.push(newToken);

        // newToken.safeMint("http://localhost:8080");

        emit ERC721TokenCreated(deployedAddress);

        return deployedAddress;
    }

    function transfer721Token(
        address _from,
        address _to,
        string memory _uri
    ) public returns(bool) {
        mappingItems[_from].safeMint(_to, _uri);
        return true;
    }

    function getDeployedTokenByAddress(
        address deployedAddress
    ) public view returns (string memory){
        return mappingItems[deployedAddress].name();
    }

}