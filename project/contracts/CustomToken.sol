// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract CustomToken is ERC20 {
    
    constructor(string memory name, string memory symbol, uint256 initialSupply, address creator) ERC20(name, symbol) {
        _mint(creator, initialSupply);
    }
}