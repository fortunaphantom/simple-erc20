// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract GiladToken {
    using SafeMath for uint256;
    
    string public constant name = "Star";
    string public constant symbol = "Star";
    uint8 public constant decimals = 128;
    
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    
    // set total token's supply count
    uint256 _totalSupply;
    constructor(uint256 total) {
       _totalSupply = total;
       balances[msg.sender] = _totalSupply;
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public returns (bool) {
        require(tokens <= balances[msg.sender]);
        
        balances[msg.sender].sub(tokens);
        balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function approve(address spender, uint tokens)  public returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public view returns (uint) {
        return allowed[tokenOwner][spender];
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool) {
        require(tokens <= balances[from]);
        require(tokens <= allowed[from][msg.sender]);
        
        allowed[from][msg.sender].sub(tokens);
        balances[from].sub(tokens);
        balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true; 
    }
    
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
}