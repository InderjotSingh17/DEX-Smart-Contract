// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    string public name = "Ether";
    string public symbol = "ETH";
    uint public totalsupply;
    address public owner;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    constructor(uint _initialsupply) {
        owner = msg.sender;
        totalsupply = _initialsupply;
        balanceOf[msg.sender] = totalsupply;
    }

    modifier onlyowner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function transfer(address _to, uint _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Not allowed");

        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function mint(address _to, uint _value) public onlyowner returns (bool) {
        balanceOf[_to] += _value;
        totalsupply += _value;
        return true;
    }

    function burn(uint _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Not enough tokens to burn");
        balanceOf[msg.sender] -= _value;
        totalsupply -= _value;
        return true;
    }
}
