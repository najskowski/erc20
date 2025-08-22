// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

library SafeMath {

  function safeSub(uint256 a, uint256 b) internal pure returns(uint256) {
    require(b <= a, "safeSub: underflow error");
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns(uint256) {
    uint256 c = a + b;
    require(c >= a, "safeAdd: overflow error");
    return c;
  }

}