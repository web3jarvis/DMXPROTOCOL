// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AMMPool is ReentrancyGuard {
    IERC20 public DMX;
    IERC20 public USDC;

    uint256 public reserveDMX;
    uint256 public reserveUSDC;

    constructor(address _DMX, address _USDC) {
        DMX = IERC20(_DMX);
        USDC = IERC20(_USDC);
    }

    function addLiquidity(uint256 amountDMX, uint256 amountUSDC) external nonReentrant {
        require(amountDMX > 0 && amountUSDC > 0, "Amounts must be greater than zero");
        require(DMX.transferFrom(msg.sender, address(this), amountDMX), "DMX transfer failed");
        require(USDC.transferFrom(msg.sender, address(this), amountUSDC), "USDC transfer failed");
        
        reserveDMX += amountDMX;
        reserveUSDC += amountUSDC;
    }

    function swapDMXforUSDC(uint amountDMX) public nonReentrant returns (uint){
        uint amountUSDC = (amountDMX * reserveUSDC) / (reserveDMX + amountDMX);
        require(amountUSDC > 0, "Insufficient output amount");
        require(DMX.transferFrom(msg.sender, address(this), amountDMX), "Transfer failed");
        require(USDC.transfer(msg.sender, amountUSDC), "Transfer failed");
        
        reserveDMX += amountDMX;
        reserveUSDC -= amountUSDC;
        
        return amountUSDC;
    }

    function swapUSDCforDMX(uint amountUSDC) public nonReentrant returns (uint){
        uint amountDMX = (amountUSDC * reserveDMX) / (reserveUSDC + amountUSDC);
        require(amountDMX > 0, "Insufficient output amount");
        require(USDC.transferFrom(msg.sender, address(this), amountUSDC), "Transfer failed");
        require(DMX.transfer(msg.sender, amountDMX), "Transfer failed");
        
        reserveUSDC += amountUSDC;
        reserveDMX -= amountDMX;
        
        return amountDMX;
    }
}
// Future scope - Implement liquidity provider tokens to track shares in the pool and enable liquidity removal.
// Future scope - Implement fee mechanism for swaps to incentivize liquidity providers and maintain pool health.