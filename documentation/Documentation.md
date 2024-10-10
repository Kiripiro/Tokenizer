
# Token42 - Custom ERC20 Token Contract

---

## Overview

**Token42** is a custom ERC20 token contract that includes specific functionalities such as rate limiting, secure ownership management, and optimizations for gas efficiency. This contract features standard ERC20 methods and a burn mechanism available only to the owner.

---

## Table of Contents

1. [Contract Information](#contract-information)
2. [State Variables](#state-variables)
   - [Token Information](#token-information)
   - [Ownership](#ownership)
   - [Balances and Allowances](#balances-and-allowances)
   - [Transfer Cooldown](#transfer-cooldown)
3. [Events](#events)
4. [Modifiers](#modifiers)
5. [Constructor](#constructor)
6. [Functions](#functions)
   - [transfer](#transfer)
   - [approve](#approve)
   - [safeApprove](#safeApprove)
   - [transferFrom](#transferFrom)
   - [increaseAllowance](#increaseAllowance)
   - [decreaseAllowance](#decreaseAllowance)
   - [burn](#burn)
   - [transferOwnership](#transferOwnership)
   - [renounceOwnership](#renounceOwnership)
7. [Internal Functions](#internal-functions)
   - [_transfer](#_transfer)
   - [_approve](#_approve)
   - [_burn](#_burn)
8. [Security Considerations](#security-considerations)
9. [Gas Optimizations](#gas-optimizations)

---

## Contract Information

- **Name**: Token42
- **Symbol**: TK42
- **Decimals**: 18
- **Total Supply**: Defined during deployment

---

## State Variables

### Token Information

- `string public name`: The name of the token.
- `string public symbol`: The symbol representing the token.
- `uint8 public decimals`: Number of decimal places for token display purposes.
- `uint256 public totalSupply`: The total supply of tokens.

### Ownership

- `address public owner`: The current owner of the contract, initially set to the deployer. The owner can transfer or renounce ownership.

### Balances and Allowances

- `mapping(address => uint256) public balanceOf`: Maps each address to its token balance.
- `mapping(address => mapping(address => uint256)) public allowance`: Maps token allowances, allowing approved spenders to transfer tokens on behalf of the owner.

### Transfer Cooldown

- `mapping(address => uint256) public lastTransferTime`: Tracks the last transfer timestamp for each address.
- `uint256 public transferCooldown`: The required cooldown period (in seconds) between transfers, default is 60 seconds.

---

## Events

- `event Transfer(address indexed from, address indexed to, uint256 value)`: Emitted whenever tokens are transferred, including initial token minting.
- `event Approval(address indexed owner, address indexed spender, uint256 value)`: Emitted whenever an owner approves a spender.
- `event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)`: Emitted when contract ownership is transferred.
- `event Burn(address indexed burner, uint256 value)`: Emitted when tokens are burned.

---

## Modifiers

### onlyOwner

```solidity
modifier onlyOwner() { ... }
```

- Restricts access to certain functions to the contract owner only.

### cooldownPassed

```solidity
modifier cooldownPassed(address account) { ... }
```

- Ensures that the cooldown period between transfers has passed for the given account.

---

## Constructor

### Token42 Constructor

```solidity
constructor(uint256 initialSupply) { ... }
```

- Initializes the contract with the total supply, assigns the supply to the deployer (owner), and emits a `Transfer` event.

---

## Functions

### transfer

```solidity
function transfer(address to, uint256 value) external cooldownPassed(msg.sender) returns (bool success)
```

- Transfers tokens from the caller to the specified address, applying the cooldown restriction.
- Emits a `Transfer` event.

### approve

```solidity
function approve(address spender, uint256 value) external returns (bool success)
```

- Approves the specified address to spend tokens on the caller’s behalf.
- Emits an `Approval` event.

### safeApprove

```solidity
function safeApprove(address spender, uint256 currentValue, uint256 newValue) external returns (bool success)
```

- Safely approves a new allowance only if the current allowance matches the expected value.
- Prevents race conditions.

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external cooldownPassed(from) returns (bool success)
```

- Allows a spender to transfer tokens from an approved account using the allowance mechanism.
- Emits a `Transfer` event.

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) external returns (bool success)
```

- Increases the spender’s allowance by a specific amount.
- Emits an `Approval` event.

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool success)
```

- Decreases the spender’s allowance by a specific amount.
- Emits an `Approval` event.

### burn

```solidity
function burn(uint256 value) external onlyOwner
```

- Allows the owner to destroy tokens, reducing the total supply.
- Emits a `Burn` and a `Transfer` event.

### transferOwnership

```solidity
function transferOwnership(address newOwner) external onlyOwner
```

- Transfers ownership of the contract to a new owner.
- Emits an `OwnershipTransferred` event.

### renounceOwnership

```solidity
function renounceOwnership() external onlyOwner
```

- Allows the owner to renounce ownership of the contract.
- Emits an `OwnershipTransferred` event.

---

## Internal Functions

### _transfer

```solidity
function _transfer(address from, address to, uint256 value) internal
```

- Handles the logic for transferring tokens between addresses and emits the `Transfer` event.

### _approve

```solidity
function _approve(address owner, address spender, uint256 value) internal
```

- Updates the allowance and emits an `Approval` event.

### _burn

```solidity
function _burn(address account, uint256 value) internal
```

- Handles the logic for burning tokens, reducing the total supply, and emits the `Burn` and `Transfer` events.

---

## Security Considerations

- **Reentrancy Protection**: The contract avoids external calls during critical operations, mitigating reentrancy risks.
- **Rate Limiting**: A cooldown period of 60 seconds is applied to transfers, preventing rapid transactions from the same account.
- **Ownership Security**: Only the owner can burn tokens or transfer ownership, ensuring sensitive operations are controlled.

---

## Gas Optimizations

- **Unchecked Arithmetic**: Uses unchecked arithmetic operations in critical places to save gas, assuming necessary preconditions are met.
- **Self-Transfer Optimization**: Skips unnecessary balance updates when transferring tokens to self.
- **Modifier Efficiency**: Cooldown logic is implemented in a modifier to centralize checks and streamline gas usage.