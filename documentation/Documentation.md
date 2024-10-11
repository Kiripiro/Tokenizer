
# Token42 - Custom ERC20 Token Contract

---

## Overview

**Token42** is a custom ERC20 token contract that includes specific functionalities such as secure ownership management and optimizations for gas efficiency. This contract features standard ERC20 methods and a burn mechanism restricted to the contract owner. Additionally, it is compliant with the best security practices and norms as outlined in the [SWC Registry](https://swcregistry.io/).

---

## Table of Contents

1. [Contract Information](#contract-information)
2. [State Variables](#state-variables)
   - [Token Information](#token-information)
   - [Balances and Allowances](#balances-and-allowances)
3. [Events](#events)
4. [Modifiers](#modifiers)
   - [validRecipient](#validrecipient)
   - [validSpender](#validspender)
   - [isNonZero](#isnonzero)
5. [Constructor](#constructor)
6. [Functions](#functions)
   - [transfer](#transfer)
   - [approve](#approve)
   - [transferFrom](#transferfrom)
   - [increaseAllowance](#increaseallowance)
   - [decreaseAllowance](#decreaseallowance)
   - [burn](#burn)
   - [balanceOf](#balanceof)
   - [allowance](#allowance)
7. [Ownership Functions](#ownership-functions)
   - [transferOwnership](#transferownership)
   - [renounceOwnership](#renounceownership)
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

#### Account Struct

- `struct Account`:
  - `uint256 balance`: The token balance of the account.
  - `mapping(address => uint256) allowances`: The allowances granted to spenders.

### Balances and Allowances

- `mapping(address => Account) private accounts`: Maps each address to its account details, including balance and allowances.

---

## Events

- `event Transfer(address indexed from, address indexed to, uint256 value)`: Emitted whenever tokens are transferred, including initial token minting.
- `event Approval(address indexed owner, address indexed spender, uint256 value)`: Emitted whenever an owner approves a spender.

---

## Modifiers
> A modifier is a special type of function that you use to modify the behavior of other functions. Modifiers allow you to add extra conditions or functionality to a function without having to rewrite the entire function.

### validRecipient

```solidity
modifier validRecipient(address to) { ... }
```

- Ensures that the recipient address is not the zero address.

### validSpender

```solidity
modifier validSpender(address spender) { ... }
```

- Ensures that the spender address is not the zero address.

### isNonZero

```solidity
modifier isNonZero(uint256 value) { ... }
```

- Ensures that the value provided is not zero.

---

## Constructor

### Token42 Constructor

```solidity
constructor(uint256 initialSupply) Ownable(msg.sender) payable { ... }
```

- Initializes the contract with the total supply, assigns the supply to the deployer (owner), and emits a `Transfer` event.

---

## Functions

### transfer

```solidity
function transfer(address to, uint256 value) external validRecipient(to) returns (bool)
```

- Transfers tokens from the caller to the specified address.
- Emits a `Transfer` event.

### approve

```solidity
function approve(address spender, uint256 value) external validSpender(spender) returns (bool)
```

- Approves the specified address to spend tokens on the caller’s behalf.
- Requires that the allowance is zero or the value is zero to prevent the race condition.
- Emits an `Approval` event.

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) external isNonZero(value) validRecipient(to) returns (bool)
```

- Allows a spender to transfer tokens from an approved account using the allowance mechanism.
- Emits a `Transfer` event.

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) external validSpender(spender) returns (bool)
```

- Increases the spender’s allowance by a specific amount.
- Emits an `Approval` event.

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) external validSpender(spender) returns (bool)
```

- Decreases the spender’s allowance by a specific amount.
- Emits an `Approval` event.

### burn

```solidity
function burn(uint256 value) external isNonZero(value) onlyOwner
```

- Allows the contract owner to destroy tokens from their account, reducing the total supply.
- Emits a `Transfer` event.

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

- Returns the token balance of the specified address.

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

- Returns the remaining number of tokens that `spender` is allowed to spend on behalf of `owner`.

---

## Ownership Functions

The contract inherits ownership functions from the OpenZeppelin `Ownable` contract, which include:

### transferOwnership

```solidity
function transferOwnership(address newOwner) public virtual onlyOwner
```

- Transfers ownership of the contract to a new owner.
- Emits an `OwnershipTransferred` event.

### renounceOwnership

```solidity
function renounceOwnership() public virtual onlyOwner
```

- Allows the owner to renounce ownership of the contract.
- Emits an `OwnershipTransferred` event.

---

## Security Considerations

- **Ownership Security**: Only the owner can perform sensitive operations like burning tokens.
- **Zero Address Checks**: Modifiers ensure that recipient and spender addresses are valid.

---

## Gas Optimizations

- **Cached Storage Variables**: Functions cache storage variables in memory to reduce gas costs associated with storage reads and writes.
- **Modifiers Usage**: Centralizes common checks to streamline code and gas usage.

---
