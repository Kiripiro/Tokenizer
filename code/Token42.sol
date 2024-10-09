// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title  Token42 - Custom ERC20 token implementation with specific functionalities
/// @author atourret
/// @notice This contract implements an ERC20 token with a fixed supply and a burn function reserved for the owner.
/// @dev    This contract does not use OpenZeppelin libraries.

contract Token42 {

    // Token information
    string public name = "Token42";
    string public symbol = "TK42";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    // Owner address
    address public owner;

    // Mappings for balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // ERC20 standard events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Burn(address indexed burner, uint256 value);

    // Modifier to restrict access to owner-only functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    /// @notice Constructor that initializes the contract with the initial supply
    /// @param initialSupply The initial supply of tokens (without decimals)
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;

        // Emit a Transfer event from the zero address (creation of tokens)
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @notice Transfers tokens to a specific address
    /// @param to The recipient's address
    /// @param value Amount to transfer (in smallest units)
    /// @return success Indicates if the transfer was successful
    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Transfer to the zero address is prohibited");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    /// @notice Approves an address to spend tokens on your behalf
    /// @param spender The address authorized to spend
    /// @param value The maximum amount they can spend
    /// @return success Indicates if the approval was successful
    function approve(address spender, uint256 value) public returns (bool success) {
        require(spender != address(0), "Approval to the zero address is prohibited");

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);
        return true;
    }

    /// @notice Transfers tokens from one address to another using allowance
    /// @param from The source address
    /// @param to The destination address
    /// @param value The amount to transfer
    /// @return success Indicates if the transfer was successful
    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(to != address(0), "Transfer to the zero address is prohibited");
        require(balanceOf[from] >= value, "Insufficient balance in source account");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    /// @notice Increases the allowance granted to a spender
    /// @param spender The address authorized to spend
    /// @param addedValue Additional amount to authorize
    /// @return success Indicates if the operation was successful
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool success) {
        require(spender != address(0), "Increase allowance for the zero address is prohibited");

        allowance[msg.sender][spender] += addedValue;

        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    /// @notice Decreases the allowance granted to a spender
    /// @param spender The address authorized to spend
    /// @param subtractedValue Amount to subtract from the allowance
    /// @return success Indicates if the operation was successful
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool success) {
        require(spender != address(0), "Decrease allowance for the zero address is prohibited");
        require(allowance[msg.sender][spender] >= subtractedValue, "Decreased allowance below zero");

        allowance[msg.sender][spender] -= subtractedValue;

        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    /// @notice Allows the owner to burn a specific amount of tokens
    /// @param value The amount of tokens to burn
    function burn(uint256 value) public onlyOwner {
        require(balanceOf[msg.sender] >= value, "Insufficient balance to burn");

        balanceOf[msg.sender] -= value;
        totalSupply -= value;

        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
    }

    /// @notice Transfers contract ownership to a new address
    /// @param newOwner The new owner's address
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is invalid");

        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice Allows the owner to renounce ownership of the contract
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}
