// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

/// @title Token42 - Custom implementation of the ERC20 token with enhanced security measures.
/// @dev This contract follows the ERC20 standard and includes optimizations for gas efficiency and secure ownership management.

import "@openzeppelin/contracts/access/Ownable.sol";

contract Token42 is Ownable {

    struct Account {
        uint256 balance;
        mapping(address => uint256) allowances;
    }

    uint256 public totalSupply;
    bytes32 public name = "Token42";
    bytes32 public symbol = "TK42";
    uint8   public decimals = 18;

    mapping(address => Account) private accounts;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    modifier validRecipient(address to) {
        require(to != address(0), "Invalid recipient");
        _;
    }

    modifier validSpender(address spender) {
        require(spender != address(0), "Invalid spender");
        _;
    }

    modifier isNonZero(uint256 value) {
        require(value != 0, "Value must be non-zero");
        _;
    }

    /**
     * @notice Initializes the contract with an initial supply assigned to the deployer.
     * @param initialSupply The total number of tokens to mint upon deployment.
     */
    constructor(uint256 initialSupply) Ownable(msg.sender) payable {
        totalSupply = initialSupply * 1e18;
        accounts[msg.sender].balance = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /**
     * @notice Transfers `value` tokens from the caller to the address `to`.
     * @param to The address of the recipient.
     * @param value The amount of tokens to transfer.
     * @return True if the operation is successful.
     */
    function transfer(address to, uint256 value) external validRecipient(to) returns (bool) {
        Account storage senderAccount = accounts[msg.sender];
        Account storage receiverAccount = accounts[to];

        uint256 senderBalance = senderAccount.balance;
        uint256 receiverBalance = receiverAccount.balance;

        require(senderBalance >= value, "Insufficient balance");

        senderBalance -= value;
        receiverBalance += value;

        senderAccount.balance = senderBalance;
        receiverAccount.balance = receiverBalance;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @notice Approves the `spender` to withdraw up to `value` from the caller's account.
     * @param spender The address authorized to spend.
     * @param value The maximum amount they are authorized to withdraw.
     * @return True if the operation is successful.
     */
    function approve(address spender, uint256 value) external validSpender(spender) returns (bool) {
        Account storage ownerAccount = accounts[msg.sender];
        require(value == 0 || ownerAccount.allowances[spender] == 0, "Reset allowance to zero first");

        if (ownerAccount.allowances[spender] != value) {
            ownerAccount.allowances[spender] = value;
            emit Approval(msg.sender, spender, value);
        }
        return true;
    }

    /**
     * @notice Transfers `value` tokens from address `from` to address `to` using the allowance mechanism.
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param value The amount of tokens to transfer.
     * @return True if the operation is successful.
     */
    function transferFrom(address from, address to, uint256 value) external isNonZero(value) validRecipient(to) returns (bool) {
        Account storage fromAccount = accounts[from];
        Account storage toAccount = accounts[to];

        uint256 senderBalance = fromAccount.balance;
        uint256 receiverBalance = toAccount.balance;
        uint256 spenderAllowance = fromAccount.allowances[msg.sender];

        require(senderBalance >= value, "Insufficient balance");
        require(spenderAllowance >= value, "Allowance exceeded");

        senderBalance -= value;
        spenderAllowance -= value;
        receiverBalance += value;

        fromAccount.balance = senderBalance;
        fromAccount.allowances[msg.sender] = spenderAllowance;
        toAccount.balance = receiverBalance;

        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @notice Increases the allowance granted to `spender` by the caller by `addedValue`.
     * @param spender The address authorized to spend.
     * @param addedValue The amount to increase the allowance by.
     * @return True if the operation is successful.
     */
    function increaseAllowance(address spender, uint256 addedValue) external validSpender(spender) returns (bool) {
        Account storage ownerAccount = accounts[msg.sender];
        ownerAccount.allowances[spender] += addedValue;
        emit Approval(msg.sender, spender, ownerAccount.allowances[spender]);
        return true;
    }

    /**
     * @notice Decreases the allowance granted to `spender` by the caller by `subtractedValue`.
     * @param spender The address authorized to spend.
     * @param subtractedValue The amount to decrease the allowance by.
     * @return True if the operation is successful.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) external validSpender(spender) returns (bool) {
        Account storage ownerAccount = accounts[msg.sender];
        require(ownerAccount.allowances[spender] >= subtractedValue, "Allowance below zero");

        ownerAccount.allowances[spender] -= subtractedValue;
        emit Approval(msg.sender, spender, ownerAccount.allowances[spender]);
        return true;
    }

    /**
     * @notice Burns `value` tokens from the caller's account, reducing the total supply.
     * @param value The amount of tokens to burn.
     */
    function burn(uint256 value) external isNonZero(value) onlyOwner {
        Account storage ownerAccount = accounts[msg.sender];
        require(ownerAccount.balance >= value, "Insufficient balance");

        ownerAccount.balance -= value;
        totalSupply -= value;

        emit Transfer(msg.sender, address(0), value);
    }

    /**
     * @notice Returns the token balance of the specified address.
     * @param account The address to query.
     * @return The token balance of the address.
     */
    function balanceOf(address account) external view returns (uint256) {
        return accounts[account].balance;
    }

    /**
     * @notice Returns the remaining number of tokens that `spender` is allowed to spend on behalf of `owner`.
     * @param owner The address which owns the funds.
     * @param spender The address authorized to spend the funds.
     * @return The remaining allowance for the spender.
     */
    function allowance(address owner, address spender) external view returns (uint256) {
        return accounts[owner].allowances[spender];
    }
}
