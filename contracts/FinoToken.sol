pragma solidity >=0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// This token is base cash of system, using exchange with asset tokens
contract FinoToken is ERC20, ERC20Burnable, Ownable {
    constructor()
        public
        // uint256 initialSupply
        ERC20Burnable()
        ERC20("FinoToken", "FCT")
    {
        _mint(msg.sender, 230900);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }
}
