// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Token42 - Custom implementation of the ERC20 token with specific features and enhanced security measures.
/// @dev This contract includes optimizations for gas efficiency, attack protection, rate limiting, and secure ownership management.

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

    // Mapping to track the last transfer time for rate limiting
    mapping(address => uint256) public lastTransferTime;
    uint256 public transferCooldown = 60; // Cooldown period of 60 seconds between transfers

    // Standard ERC20 events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Burn(address indexed burner, uint256 value);

    // Modifier to restrict access to owner-only functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Modifier to apply rate limiting on transfers
    modifier cooldownPassed(address account) {
        require(block.timestamp >= lastTransferTime[account] + transferCooldown, "Transfer cooldown period not passed");
        _;
    }

    /// @notice Constructor that initializes the contract with the initial supply
    /// @dev Sets the total supply of tokens and assigns them to the owner.
    /// @param initialSupply The initial supply of tokens (without decimals)
    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;

        // Emit a Transfer event from the zero address (token creation)
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /// @notice Transfers tokens to a specific address
    /// @dev Uses the cooldownPassed modifier for rate limiting.
    /// @param to The recipient address
    /// @param value Amount to transfer (in smallest units)
    /// @return success Indicates if the transfer was successful
    function transfer(address to, uint256 value) external cooldownPassed(msg.sender) returns (bool success) {
        require(to != address(0), "Transfer to the zero address is prohibited");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");

        // Update the last transfer time for rate limiting
        lastTransferTime[msg.sender] = block.timestamp;

        // Use the internal function to update balances and emit the event
        _transfer(msg.sender, to, value);
        return true;
    }

    /// @notice Approves an address to spend tokens on your behalf
    /// @dev Sets the allowance for the spender.
    /// @param spender The address authorized to spend
    /// @param value The maximum amount they can spend
    /// @return success Indicates if the approval was successful
    function approve(address spender, uint256 value) external returns (bool success) {
        require(spender != address(0), "Approval to the zero address is prohibited");

        // Use the internal function to handle the approval logic
        _approve(msg.sender, spender, value);
        return true;
    }

    /// @notice Safely approves an allowance only if the current allowance matches the provided value
    /// @dev Prevents race conditions by ensuring the expected allowance matches before updating.
    /// @param spender The address authorized to spend
    /// @param currentValue The current allowance value that must match
    /// @param newValue The new allowance value to set
    /// @return success Indicates if the approval was successful
    function safeApprove(address spender, uint256 currentValue, uint256 newValue) external returns (bool success) {
        require(spender != address(0), "Approval to the zero address is prohibited");
        require(allowance[msg.sender][spender] == currentValue, "Current allowance does not match expected value");

        // Use the internal function to update the allowance
        _approve(msg.sender, spender, newValue);
        return true;
    }

    /// @notice Transfers tokens from one address to another using the allowance
    /// @dev Uses the cooldownPassed modifier for rate limiting and checks the allowance before transferring.
    /// @param from The source address
    /// @param to The destination address
    /// @param value The amount to transfer
    /// @return success Indicates if the transfer was successful
    function transferFrom(address from, address to, uint256 value) external cooldownPassed(from) returns (bool success) {
        require(to != address(0), "Transfer to the zero address is prohibited");
        require(balanceOf[from] >= value, "Insufficient balance");

        uint256 currentAllowance = allowance[from][msg.sender];
        require(currentAllowance >= value, "Allowance exceeded");

        // Update the last transfer time for rate limiting
        lastTransferTime[from] = block.timestamp;

        // Deduct from the holder's allowance
        _approve(from, msg.sender, currentAllowance - value);

        // Use the internal function to update balances and emit the event
        _transfer(from, to, value);
        return true;
    }

    /// @notice Increases the allowance granted to a spender
    /// @param spender The address authorized to spend
    /// @param addedValue Additional amount to authorize
    /// @return success Indicates if the operation was successful
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool success) {
        require(spender != address(0), "Increase allowance for the zero address is prohibited");

        _approve(msg.sender, spender, allowance[msg.sender][spender] + addedValue);
        return true;
    }

    /// @notice Decreases the allowance granted to a spender
    /// @param spender The address authorized to spend
    /// @param subtractedValue Amount to subtract from the allowance
    /// @return success Indicates if the operation was successful
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool success) {
        require(spender != address(0), "Decrease allowance for the zero address is prohibited");
        require(allowance[msg.sender][spender] >= subtractedValue, "Decreased allowance below zero");

        _approve(msg.sender, spender, allowance[msg.sender][spender] - subtractedValue);
        return true;
    }

    /// @notice Allows the owner to burn a specific amount of tokens
    /// @dev Burns tokens and decreases the total supply, only callable by the owner.
    /// @param value The amount of tokens to burn
    function burn(uint256 value) external onlyOwner {
        require(balanceOf[msg.sender] >= value, "Insufficient balance to burn");

        _burn(msg.sender, value);
    }

    /// @notice Transfers ownership of the contract to a new address
    /// @dev Transfers ownership and emits an event. The new owner must be a valid address.
    /// @param newOwner The address of the new owner
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner is invalid");

        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice Allows the owner to renounce ownership of the contract
    /// @dev This function removes the owner, making the contract ownerless. Use with caution as it disables `onlyOwner` functions.
    function renounceOwnership() external onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    // ----- Internal functions to avoid code duplication -----

    /// @dev Internal function to handle token transfers and emit the Transfer event.
    ///      Optimized to avoid unnecessary storage writes when transferring to self.
    /// @param from The source address
    /// @param to The destination address
    /// @param value The amount to transfer
    function _transfer(address from, address to, uint256 value) internal {
        if (from == to) {
            emit Transfer(from, to, value);
            return;
        }
        unchecked {
            balanceOf[from] -= value;
            balanceOf[to] += value;
        }
        emit Transfer(from, to, value);
    }

    /// @dev Internal function to update allowances and emit the Approval event.
    /// @param tokenOwner The owner of the tokens
    /// @param spender The address authorized to spend
    /// @param value The new allowance value
    function _approve(address tokenOwner, address spender, uint256 value) internal {
        allowance[tokenOwner][spender] = value;
        emit Approval(tokenOwner, spender, value);
    }

    /// @dev Internal function to burn tokens and reduce the total supply.
    /// @param account The account from which to burn tokens
    /// @param value The amount of tokens to burn
    function _burn(address account, uint256 value) internal {
        unchecked {
            balanceOf[account] -= value;
            totalSupply -= value;
        }
        emit Burn(account, value);
        emit Transfer(account, address(0), value);
    }
}
