
# Token42 - Deployment Guide

## Prerequisites

Before deploying the Token42 contract on the BNB Chain Testnet, make sure you have the following tools and accounts set up:

1. **Metamask**: Install and configure [Metamask](https://metamask.io/) to interact with the BNB Chain Testnet.
2. **Testnet BNB**: Ensure your Metamask account has some BNB tokens on the BNB Chain Testnet for gas fees. You can obtain Testnet BNB from the [BNB Chain Testnet Faucet](https://testnet.bnbchain.org/faucet-smart) or using their Discord channel (accessible on the previous link).
3. **Remix IDE**: Use [Remix IDE](https://remix.ethereum.org/) for contract deployment.
4. **BNB Chain Testnet Configuration**: Add the BNB Chain Testnet to your Metamask with the following settings:
    - **Network Name**: BNB Chain Testnet
    - **New RPC URL**: `https://data-seed-prebsc-1-s1.binance.org:8545/`
    - **Chain ID**: 97
    - **Currency Symbol**: BNB
    - **Block Explorer URL**: `https://testnet.bscscan.com/`

## Deployment Steps

### Step 1: Open Remix IDE
1. Navigate to [Remix IDE](https://remix.ethereum.org/).
2. Create a new file and paste the Token42 contract code into it.

### Step 2: Compile the Contract
1. In Remix, select the Solidity compiler from the sidebar.
2. Choose the correct Solidity version (`0.8.0` or higher) and click on "Compile Token42.sol."

### Step 3: Connect to BNB Chain Testnet
1. In the Deploy & Run Transactions tab, switch the environment to **Injected Web3** to use your Metamask wallet.
2. Make sure Metamask is set to the BNB Chain Testnet network.

### Step 4: Deploy the Contract
1. In the "Deploy" section of Remix, enter the `initialSupply` parameter for the constructor. This should be the total supply of tokens (in base units, without considering decimals).
2. Click on **Deploy** and confirm the transaction in Metamask.

### Step 5: Verify Deployment
Once the transaction is confirmed, your contract will be deployed. You can verify the contract and interact with it on [BscScan Testnet](https://testnet.bscscan.com/).

- **Contract Address**: Defined during deployment
- **Token Name**: Token42
- **Symbol**: TK42
- **Decimals**: 18
- **Total Supply**: Defined during deployment

## Interacting with the Contract

Once deployed, you can interact with the contract functions using Remix, or by connecting to the contract address via BscScan.

### Important Contract Functions
- **transfer(address to, uint256 value)**: Transfer tokens to another address.
- **approve(address spender, uint256 value)**: Approve an address to spend tokens on your behalf.
- **burn(uint256 value)**: Burn tokens from the owner's balance, reducing the total supply.
- **transferOwnership(address newOwner)**: Transfer ownership of the contract to another address.

## Testnet Information

- **Network Name**: BNB Chain Testnet
- **Chain ID**: 97
- **RPC URL**: `https://data-seed-prebsc-1-s1.binance.org:8545/`
- **Block Explorer**: [BNB Chain Testnet Explorer](https://testnet.bscscan.com/)

## Conclusion

Your Token42 contract is now deployed on the BNB Chain Testnet. Ensure to keep track of the contract address and private keys securely. You can now interact with your token using Metamask or any other Web3 tool.