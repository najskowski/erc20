// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "./ERC20.sol";
import "./SafeMath.sol";

contract Token is ERC20 {
    address owner;
    bool public paused;
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only owner of the contract can call this function"
        );
        _;
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
    }

    string public constant name = "PepeCoin";
    string public constant symbol = "PEPE";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) {
        owner = msg.sender;
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return balances[_owner];
    }

    // safely increase allowance for a spender
    function increaseAllowance(
        address _spender,
        uint256 _addedValue
    ) public returns (bool) {
        require(_spender != address(0), "Invalid spender");
        allowed[msg.sender][_spender] = SafeMath.safeAdd(
            allowed[msg.sender][_spender],
            _addedValue
        );
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    // safely decrease allowance for a spender
    function decreaseAllowance(
        address _spender,
        uint256 _subtractedValue
    ) public returns (bool) {
        require(_spender != address(0), "Invalid spender");
        allowed[msg.sender][_spender] = SafeMath.safeSub(
            allowed[msg.sender][_spender],
            _subtractedValue
        );
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view override returns (uint256) {
        return allowed[_owner][_spender];
    }

    // Warning: Using approve directly may allow front-running. Prefer increaseAllowance/decreaseAllowance for safer allowance updates.
    function approve(
        address _spender,
        uint256 _value
    ) public override returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function calculateBurnFee(uint256 _value) private pure returns (uint256) {
        if (_value == 0) {
            return 0;
        }
        uint256 burnFee = _value / 100; // 1% burn fee
        // set min. burn fee of 0.01
        if (burnFee < 1e16) {
            burnFee = 1e16;
        }
        return burnFee;
    }

    function transfer(
        address _to,
        uint256 _value
    ) public override returns (bool) {
        require(!paused, "Can't perform this action right now");
        require(_value <= balances[msg.sender], "Insufficient balance");
        require(_to != address(0), "Invalid recipient");

        uint256 burnFee = calculateBurnFee(_value);
        uint256 transferAmount = SafeMath.safeSub(_value, burnFee);

        balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);
        balances[_to] = SafeMath.safeAdd(balances[_to], transferAmount);

        // reduce total supply
        totalSupply_ = SafeMath.safeSub(totalSupply_, burnFee);

        emit Transfer(msg.sender, address(0), burnFee);
        emit Transfer(msg.sender, _to, transferAmount);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool) {
        require(!paused, "Can't perform this action right now");
        require(_value <= balances[_from], "Insufficient balance");
        require(_value <= allowed[_from][msg.sender], "Insufficient allowance");
        require(_to != address(0), "Invalid recipient");

        uint256 burnFee = calculateBurnFee(_value);
        uint256 transferAmount = SafeMath.safeSub(_value, burnFee);

        balances[_from] = SafeMath.safeSub(balances[_from], _value);
        balances[_to] = SafeMath.safeAdd(balances[_to], transferAmount);

        // reduce total supply
        totalSupply_ = SafeMath.safeSub(totalSupply_, burnFee);

        allowed[_from][msg.sender] = SafeMath.safeSub(
            allowed[_from][msg.sender],
            _value
        );

        emit Transfer(_from, address(0), burnFee);
        emit Transfer(_from, _to, transferAmount);
        return true;
    }
}
