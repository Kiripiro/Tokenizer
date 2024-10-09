
# Token42 - Custom ERC20 Token Contract Documentation

## Overview
**Token42** is a custom ERC20 token contract that implements a fixed supply and includes a burn function reserved for the owner. This documentation provides a detailed explanation of the contract's functionality and how to use its features.

## Contract Details
- **Token Name**: Token42
- **Symbol**: TK42
- **Decimals**: 18
- **Total Supply**: Defined during deployment
- **Owner**: The deployer of the contract initially, can be transferred and revoked.

## Functions

### 1. Constructor: `constructor(uint256 initialSupply)`
Initializes the token with a fixed total supply and assigns the entire supply to the owner.

- **Parameters**:
    - `initialSupply`: The initial supply of tokens without decimals.
- **Events**:
    - `Transfer`: Emits when tokens are created from the zero address.

### 2. Transfer: `transfer(address to, uint256 value) → bool`
Transfers tokens from the caller's account to a recipient.

- **Parameters**:
    - `to`: The address of the recipient.
    - `value`: The amount of tokens to transfer (in smallest units).
- **Returns**: `success`: Boolean indicating whether the transfer was successful.
- **Requirements**:
    - The recipient address must not be zero.
    - The caller must have enough balance.
- **Events**:
    - `Transfer`: Emits when tokens are transferred.

### 3. Approve: `approve(address spender, uint256 value) → bool`
Allows a spender to transfer tokens from the owner's account up to a certain limit.

- **Parameters**:
    - `spender`: The address allowed to spend tokens.
    - `value`: The maximum amount of tokens the spender can transfer.
- **Returns**: `success`: Boolean indicating whether the approval was successful.
- **Requirements**:
    - The spender address must not be zero.
- **Events**:
    - `Approval`: Emits when the allowance is set.

### 4. TransferFrom: `transferFrom(address from, address to, uint256 value) → bool`
Transfers tokens from one address to another using the allowance mechanism.

- **Parameters**:
    - `from`: The source address.
    - `to`: The destination address.
    - `value`: The amount to transfer.
- **Returns**: `success`: Boolean indicating if the transfer succeeded.
- **Requirements**:
    - The source must have enough balance.
    - The caller must have sufficient allowance.
    - The destination address must not be zero.
- **Events**:
    - `Transfer`: Emits when tokens are transferred.

### 5. Increase Allowance: `increaseAllowance(address spender, uint256 addedValue) → bool`
Increases the allowance granted to a spender.

- **Parameters**:
    - `spender`: The address allowed to spend tokens.
    - `addedValue`: The additional allowance.
- **Returns**: `success`: Boolean indicating if the operation was successful.
- **Requirements**:
    - The spender address must not be zero.
- **Events**:
    - `Approval`: Emits when the allowance is increased.

### 6. Decrease Allowance: `decreaseAllowance(address spender, uint256 subtractedValue) → bool`
Decreases the allowance granted to a spender.

- **Parameters**:
    - `spender`: The address allowed to spend tokens.
    - `subtractedValue`: The amount to subtract from the current allowance.
- **Returns**: `success`: Boolean indicating if the operation was successful.
- **Requirements**:
    - The spender address must not be zero.
    - The remaining allowance must not be less than zero.
- **Events**:
    - `Approval`: Emits when the allowance is decreased.

### 7. Burn: `burn(uint256 value)`
Burns a specific amount of tokens from the owner's balance, reducing the total supply.

- **Parameters**:
    - `value`: The number of tokens to burn.
- **Requirements**:
    - The caller must have enough tokens to burn.
- **Events**:
    - `Burn`: Emits when tokens are burned.
    - `Transfer`: Emits when tokens are burned.

### 8. Transfer Ownership: `transferOwnership(address newOwner)`
Transfers the ownership of the contract to a new owner.

- **Parameters**:
    - `newOwner`: The address of the new owner.
- **Requirements**:
    - The new owner address must not be zero.
- **Events**:
    - `OwnershipTransferred`: Emits when ownership is transferred.

### 9. Renounce Ownership: `renounceOwnership()`
Allows the owner to renounce their ownership, leaving the contract without an owner.

- **Events**:
    - `OwnershipTransferred`: Emits when ownership is renounced.

## Events
- `Transfer`: Emitted when tokens are transferred.
- `Approval`: Emitted when an allowance is set or updated.
- `OwnershipTransferred`: Emitted when ownership is transferred.
- `Burn`: Emitted when tokens are burned.

## Security Considerations
- Ensure that the `onlyOwner` modifier is correctly applied to sensitive functions like `burn`, `transferOwnership`, and `renounceOwnership`.
- Avoid transferring tokens to the zero address or performing approvals to the zero address.