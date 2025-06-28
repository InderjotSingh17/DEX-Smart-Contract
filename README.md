# 🪙 MyToken & SimpleDEX - A Basic Decentralized Exchange

This repository contains two Solidity smart contracts:

1. `MyToken.sol` — A custom ERC-20 token called **Ether (ETH)**
2. `SimpleDEX.sol` — A simple decentralized exchange (DEX) that allows users to:
   - Add and remove liquidity
   - Swap ETH for tokens and vice versa

## 📦 Contracts Overview

### 1. `MyToken.sol` (ERC-20 Token)
A minimal implementation of an ERC-20 token with the following features:
- Token name: `Ether`
- Symbol: `ETH`
- Initial supply assigned to the contract deployer
- Ability to:
  - Transfer tokens
  - Approve and transferFrom (for allowances)
  - Mint new tokens (onlyOwner)
  - Burn tokens

#### Key Functions:
- `transfer(to, amount)`
- `approve(spender, amount)`
- `transferFrom(from, to, amount)`
- `mint(to, amount)` — owner only
- `burn(amount)`

---

### 2. `SimpleDEX.sol` (Decentralized Exchange)

A basic constant product market maker (CPMM) that:
- Accepts ETH and `MyToken` to provide liquidity
- Allows users to swap between ETH and `MyToken`
- Maintains pool ratio using `x * y = k` invariant
- Charges 0.3% fee on swaps (Uniswap V2 style)

#### Key Functions:
- `addLiquidity(tokenAmount)` — Add ETH and token to pool
- `removeLiquidity(liquidityAmount)` — Withdraw proportional ETH & tokens
- `swapEthToToken()` — Swap ETH for tokens
- `swapTokenToEth(tokenAmount)` — Swap tokens for ETH
- `getPrice()` — Returns current reserves (ETH, token)

---
👨‍💻 Authors & Contributors
Inderjot Singh
Solidity Developer | Smart Contracts Enthusiast
GitHub: @InderjotSingh17

📝 License
This project is licensed under the MIT License.
