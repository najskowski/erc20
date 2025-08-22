# ERC20 Token

## What It Does

- **ERC20 Standard**
- **Burn Fee**: Burns 1% of every transfer (min 0.01 tokens) to reduce total supply.
- **Pause Feature**: Owner can pause/unpause transfers for control.
- **Safe Math**: Uses `SafeMath` to avoid overflow/underflow bugs.
- **Allowance Safety**: `increaseAllowance` and `decreaseAllowance` to dodge front-running issues.

## Setup

1. Clone the repo:

   ```bash
   git clone https://github.com/najskowski/erc20
   cd erc20
   ```

2. Install dependencies:

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