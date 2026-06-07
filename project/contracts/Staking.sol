// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DMXStaking is ReentrancyGuard {
    IERC20 public DMX;
    mapping(address => uint256) public stakeBalance;
    mapping(address => uint256) public stakeTime;
    mapping(address => uint256) public rewardAmount;
    uint256 public rewardRate = 10 ** 16; // 0.01 DMX per second

    constructor(address _DMX) {
        DMX = IERC20(_DMX);
    }

    function stake(uint256 _amount) external nonReentrant returns (bool) {
        require(_amount > 0, "Amount must be greater than zero");
        require(DMX.balanceOf(msg.sender) >= _amount, "Insufficient balance");
        if (stakeBalance[msg.sender] > 0) {
            uint256 timeElapsed = block.timestamp - stakeTime[msg.sender];
            rewardAmount[msg.sender] += timeElapsed * rewardRate;
        }
        require(DMX.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        stakeBalance[msg.sender] += _amount;
        stakeTime[msg.sender] = block.timestamp;
        return true;
    }

    function unstake(uint256 _amount) external nonReentrant returns (bool) {
        require(stakeBalance[msg.sender] >= _amount, "Insufficient balance");
        uint256 timeElapsed = block.timestamp - stakeTime[msg.sender];
        rewardAmount[msg.sender] += timeElapsed * rewardRate;

        stakeBalance[msg.sender] -= _amount;
        stakeTime[msg.sender] = block.timestamp;

        require(DMX.transfer(msg.sender, _amount), "Transfer failed");
        return true;
    }

    function claimReward() external nonReentrant {
        uint256 timeElapsed = block.timestamp - stakeTime[msg.sender];
        uint256 reward = rewardAmount[msg.sender] + (timeElapsed * rewardRate);
        
        require(reward > 0, "No rewards to claim");

        rewardAmount[msg.sender] = 0;
        stakeTime[msg.sender] = block.timestamp;

        require(DMX.transfer(msg.sender, reward), "Reward transfer failed");
    }
    
    // Future scope - Implement dynamic APY based on total value locked (TVL) in the pool.
}