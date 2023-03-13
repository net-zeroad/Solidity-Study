// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TestToken {
    mapping(address => uint256) public balances;
    string public name = "dog";
    string public symbol = "DG";
    uint8 public decimals = 18;
    uint256 public totalSupply = 1000 * 10 ** decimals; // 1000 DG

    constructor(string memory _symbol) {
        balances[msg.sender] = totalSupply;
        symbol = _symbol;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(balances[msg.sender] >= _value);

        balances[msg.sender] -= _value;

        balances[_to] += _value;
        return true;
    }
}
