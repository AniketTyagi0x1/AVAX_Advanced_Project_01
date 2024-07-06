// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Vault {
    IERC20 public immutable token;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    event Deposit(address indexed user, uint amount, uint shares);
    event Withdraw(address indexed user, uint shares, uint amount);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function _mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }

    function approve(uint _amount) external {
        require(_amount > 0, "Amount must be greater than zero");
        require(token.approve(address(this), _amount), "Approval failed");
        emit Approval(msg.sender, address(this), _amount);
    }

    function deposit(uint _amount) external {
        require(_amount > 0, "Amount must be greater than zero");
        require(token.allowance(msg.sender, address(this)) >= _amount, "Allowance not sufficient");
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient token balance");

        uint shares;
        uint tokenBalance = token.balanceOf(address(this));
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            require(tokenBalance > 0, "Token balance must be greater than zero");
            shares = (_amount * totalSupply) / tokenBalance;
        }

        _mint(msg.sender, shares);
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        emit Deposit(msg.sender, _amount, shares);
    }

    function withdraw(uint _shares) external {
        require(_shares > 0, "Shares must be greater than zero");
        require(balanceOf[msg.sender] >= _shares, "Insufficient shares");

        uint tokenBalance = token.balanceOf(address(this));
        require(tokenBalance > 0, "Token balance must be greater than zero");

        uint amount = (_shares * tokenBalance) / totalSupply;
        _burn(msg.sender, _shares);
        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit Withdraw(msg.sender, _shares, amount);
    }
}
