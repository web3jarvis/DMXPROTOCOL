// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CustomToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract Launchpad is Ownable, ReentrancyGuard {
    IERC20 public DMX;
    uint256 public platformFee;

    constructor(address _DMX, address initialOwner, uint256 _platformFee) Ownable(initialOwner) {
        DMX = IERC20(_DMX);
        platformFee = _platformFee;
    }

    function createToken(string memory name, string memory symbol, uint256 initialSupply) external nonReentrant returns (address) {
        require(DMX.transferFrom(msg.sender, owner(), platformFee), "Fee transfer failed");
        CustomToken newToken = new CustomToken(name, symbol, initialSupply, msg.sender);
        return address(newToken);
    }

    function updateFee(uint256 _newFee) external onlyOwner {
        platformFee = _newFee;
    }
}