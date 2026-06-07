// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DMXToken is ERC20, Ownable {

    constructor(address initialOwner) ERC20("DMX Protocol Token", "DMX") Ownable(initialOwner) {

        _mint(initialOwner, 10000 * (10 ** 18));
    }

    function mintToUser(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}