# ERC20 Token

## What It Does

- **ERC20 Standard**: All the usual stuff—`transfer`, `approve`, `balanceOf`, etc.
- **Burn Fee**: Burns 1% of every transfer (min 0.01 tokens) to reduce total supply.
- **Pause Feature**: Owner can pause/unpause transfers for control.
- **Safe Math**: Uses `SafeMath` to avoid overflow/underflow bugs.
- **Allowance Safety**: `increaseAllowance` and `decreaseAllowance` to dodge front-running issues.

## Setup

1. Clone the repo:

   ```bash
   git clone <my-repo-url>
   cd dawgcoin
   ```

2. Install stuff:

   ```bash
   pnpm i
   ```

3. Compile contracts:

   ```bash
   npx hardhat compile
   ```

## Tools used

- **Node.js**
- **Hardhat**
- **Solidity**
- **Ethers.js & Chai**