// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint amount) external returns (bool);
    function transferFrom(address from, address to, uint amount) external returns (bool);
    function balanceOf(address user) external view returns (uint);
}

contract SimpleDEX {
    IERC20 public token;
    uint public totalLiquidity;
    mapping(address => uint) public liquidity;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function addLiquidity(uint tokenAmount) public payable returns (uint) {
        require(tokenAmount > 0 && msg.value > 0, "Invalid inputs");

        if (totalLiquidity == 0) {
            // First provider sets the pool ratio
            totalLiquidity = address(this).balance;
            liquidity[msg.sender] = totalLiquidity;
        } 
        else {
            uint ethReserve = address(this).balance - msg.value;
            uint tokenReserve = token.balanceOf(address(this));
            uint requiredToken = (msg.value * tokenReserve) / ethReserve;
            require(tokenAmount >= requiredToken, "Token amount too low");

            uint share = (msg.value * totalLiquidity) / ethReserve;
            liquidity[msg.sender] += share;
            totalLiquidity += share;
        }

        token.transferFrom(msg.sender, address(this), tokenAmount);
        return liquidity[msg.sender];
    }

    function removeLiquidity(uint amount) public returns (uint ethOut, uint tokenOut) {
        require(liquidity[msg.sender] >= amount, "Insufficient liquidity");

        uint ethBalance = address(this).balance;
        uint tokenBalance = token.balanceOf(address(this));

        ethOut = (amount * ethBalance) / totalLiquidity;
        tokenOut = (amount * tokenBalance) / totalLiquidity;

        liquidity[msg.sender] -= amount;
        totalLiquidity -= amount;

        payable(msg.sender).transfer(ethOut);
        token.transfer(msg.sender, tokenOut);
    }

    function swapEthToToken() public payable returns (uint tokenOut) {
        require(msg.value > 0, "Send ETH to swap");

        uint ethReserve = address(this).balance - msg.value;
        uint tokenReserve = token.balanceOf(address(this));

        uint ethInWithFee = msg.value * 997;
        tokenOut = (ethInWithFee * tokenReserve) / (ethReserve * 1000 + ethInWithFee);

        token.transfer(msg.sender, tokenOut);
    }

    function swapTokenToEth(uint tokenIn) public returns (uint ethOut) {
        require(tokenIn > 0, "Send tokens to swap");

        uint ethReserve = address(this).balance;
        uint tokenReserve = token.balanceOf(address(this));

        uint tokenInWithFee = tokenIn * 997;
        ethOut = (tokenInWithFee * ethReserve) / (tokenReserve * 1000 + tokenInWithFee);

        token.transferFrom(msg.sender, address(this), tokenIn);
        payable(msg.sender).transfer(ethOut);
    }

    function getPrice() public view returns (uint ethReserve, uint tokenReserve) {
        return (address(this).balance, token.balanceOf(address(this)));
    }

    receive() external payable {}
}
