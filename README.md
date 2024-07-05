# Chandigarh University Summer Internship With Metacrafters Project 01 Avax Advanced Course 

## Project Introduction 

In this project, you will learn how to deploy your own EVM subnet using the Avalanche CLI and integrate it with Metamask for seamless interaction. First, you'll set up your subnet using the Avalanche CLI, ensuring it is correctly configured and added to Metamask as your selected network. Once configured, you'll connect Remix to your Metamask wallet using the Injected Provider to deploy and manage your smart contracts. The next steps involve deploying your smart contracts through Remix, allowing you to test and interact with them directly. This includes deploying tokens, creating pools, and more, providing a comprehensive hands-on experience in developing and managing decentralized applications on your EVM subnet. By the end of this project, you will have a functional EVM subnet integrated with Metamask, and you will have deployed and tested smart contracts using Remix, giving you a solid foundation in blockchain development and deployment.

## Avalanche Subnet

An Avalanche Subnet, short for "subnetwork," is a dynamic set of validators working together to achieve consensus on the state of a set of blockchains. Unlike a single monolithic network, Avalanche's architecture allows for the creation of multiple custom blockchains within the Avalanche platform, each with its own unique rules, validators, and governance. These subnets can be optimized for different use cases, such as DeFi applications, enterprise solutions, or even private blockchains.

## Commands

To create or deploy a subnet on Avalanche using the Avalanche CLI, follow these steps:

1. **Install the Avalanche CLI** (if you haven't already):
   ```sh
   curl -Lo avalanchego.tar.gz https://github.com/ava-labs/avalanchego/releases/download/v1.9.2/avalanchego-linux-1.9.2.tar.gz
   tar -xvf avalanchego.tar.gz
   cd avalanchego-1.9.2
   sudo install -o root -g root -m 0755 avalanchego /usr/local/bin/avalanchego
   ```

2. **Install the Avalanche-CLI** (if you haven't already):
   ```sh
   curl -Lo avalanche-cli https://github.com/ava-labs/avalanche-cli/releases/download/v0.6.3/avalanche-cli-linux-v0.6.3
   chmod +x avalanche-cli
   sudo mv avalanche-cli /usr/local/bin/
   ```

3. **Create a new subnet**:
   ```sh
   avalanche-cli subnet create <subnet-name>
   ```

4. **Deploy the subnet**:
   ```sh
   avalanche-cli subnet deploy <subnet-name>
   ```

### Example

Here's a step-by-step example of creating and deploying a subnet named "MySubnet":

1. Create the subnet:
   ```sh
   avalanche-cli subnet create MySubnet
   ```

   This command will guide you through the process of defining your subnet, including specifying the parameters for your blockchain.

2. Deploy the subnet:
   ```sh
   avalanche-cli subnet deploy MySubnet
   ```

   This command will deploy your subnet to the Avalanche network.

## ERC20 Token Contract Explanation 

This Solidity contract implements a basic ERC20 token, which is a standard for fungible tokens on the Ethereum blockchain. Here's a breakdown of its components and functionality:

### Overview

- **License and Version**: The contract uses the MIT license and specifies Solidity version 0.8.26.
- **State Variables**: It includes the total supply of tokens, balances of addresses, and allowances for transferring tokens on behalf of others.
- **Token Details**: The token's name is "cuinternship", its symbol is "cu", and it uses 18 decimal places, which is standard for ERC20 tokens.

### State Variables

- **totalSupply**: The total number of tokens in existence.
- **balanceOf**: A mapping that tracks the balance of each address.
- **allowance**: A mapping that tracks how much one address is allowed to spend on behalf of another address.
- **name, symbol, decimals**: These store the token's name, symbol, and decimal precision, respectively.

### Events

- **Transfer**: Emitted when tokens are transferred between addresses.
- **Approval**: Emitted when an owner approves a spender to spend a certain amount of tokens.

### Functions

1. **transfer**: Allows the caller to transfer tokens to another address.
   ```solidity
   function transfer(address recipient, uint amount) external returns (bool)
   ```
   - Decreases the caller's balance by the specified amount.
   - Increases the recipient's balance by the specified amount.
   - Emits a `Transfer` event.

2. **approve**: Allows the caller to approve another address to spend tokens on their behalf.
   ```solidity
   function approve(address spender, uint amount) external returns (bool)
   ```
   - Sets the allowance for the spender.
   - Emits an `Approval` event.

3. **transferFrom**: Allows a spender to transfer tokens from one address to another.
   ```solidity
   function transferFrom(address sender, address recipient, uint amount) external returns (bool)
   ```
   - Decreases the allowance for the spender.
   - Decreases the sender's balance.
   - Increases the recipient's balance.
   - Emits a `Transfer` event.

4. **mint**: Allows the caller to create new tokens and add them to their balance.
   ```solidity
   function mint(uint amount) external
   ```
   - Increases the caller's balance by the specified amount.
   - Increases the total supply of tokens.
   - Emits a `Transfer` event with the zero address as the sender.

5. **burn**: Allows the caller to destroy their tokens, reducing the total supply.
   ```solidity
   function burn(uint amount) external
   ```
   - Decreases the caller's balance by the specified amount.
   - Decreases the total supply of tokens.
   - Emits a `Transfer` event with the zero address as the recipient.

### Key Points

- **Security Considerations**: This contract doesn't include checks for underflow/overflow since Solidity 0.8+ has built-in checks for these conditions.
- **Events**: The `Transfer` and `Approval` events are standard for ERC20 tokens and help in tracking token movements and approvals.
- **Minting and Burning**: These functions allow dynamic changes to the total supply of tokens, which is useful for various tokenomics strategies.

This contract provides a simple and functional implementation of the ERC20 token standard, covering essential features like transferring tokens, approving allowances, minting, and burning tokens.

## Vault Contract Explanation 

### Contract Explanation: Vault Using IERC20 Interface

This Solidity contract defines a vault that allows users to deposit and withdraw ERC20 tokens. Here's a detailed explanation of the contract components and functionality:

#### SPDX License Identifier and Solidity Version
```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
```
- **SPDX License Identifier**: Specifies that the contract is licensed under the MIT license.
- **Solidity Version**: The contract is written for Solidity version 0.8.26.

#### IERC20 Interface
The `IERC20` interface defines the standard functions and events for an ERC20 token. These functions are necessary for interacting with any ERC20 token:
```solidity
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
```
- **Functions**: Define the essential actions for ERC20 tokens, such as transferring tokens, checking balances, and approving allowances.
- **Events**: `Transfer` and `Approval` events are used to log token transfers and approvals.

#### Vault Contract
The `Vault` contract allows users to deposit ERC20 tokens in exchange for shares and withdraw tokens by burning those shares.

##### State Variables
```solidity
contract Vault {
    IERC20 public immutable token;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
```
- **token**: An immutable variable that stores the address of the ERC20 token used in the vault.
- **totalSupply**: The total supply of shares in the vault.
- **balanceOf**: A mapping that tracks the number of shares held by each address.

##### Constructor
```solidity
    constructor(address _token) {
        token = IERC20(_token);
    }
```
- **constructor**: Initializes the vault with the address of the ERC20 token.

##### Private Functions: _mint and _burn
```solidity
    function _mint(address _to, uint _shares) private {
        totalSupply += _shares;
        balanceOf[_to] += _shares;
    }

    function _burn(address _from, uint _shares) private {
        totalSupply -= _shares;
        balanceOf[_from] -= _shares;
    }
```
- **_mint**: Increases the total supply of shares and the balance of the recipient.
- **_burn**: Decreases the total supply of shares and the balance of the sender.

##### Public Functions: deposit and withdraw
```solidity
    function deposit(uint _amount) external {
        uint shares;
        if (totalSupply == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply) / token.balanceOf(address(this));
        }

        _mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _shares) external {
        uint amount = (_shares * token.balanceOf(address(this))) / totalSupply;
        _burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }
```
- **deposit**: Allows users to deposit tokens into the vault. The user receives shares proportional to the amount deposited relative to the current total supply and balance of the vault.
  - If the total supply is 0, the number of shares minted equals the amount deposited.
  - Otherwise, the shares minted are calculated based on the proportion of the deposit amount to the vault's balance.
  - The `_mint` function increases the user's share balance and the total supply.
  - The `transferFrom` function transfers the tokens from the user to the vault.

- **withdraw**: Allows users to withdraw tokens from the vault by burning their shares.
  - The amount of tokens withdrawn is proportional to the number of shares being burned relative to the total supply and the vault's balance.
  - The `_burn` function decreases the user's share balance and the total supply.
  - The `transfer` function transfers the tokens from the vault to the user.

### Summary
The Vault contract provides a mechanism for users to deposit and withdraw ERC20 tokens while managing shares to represent their stake in the vault. Users can deposit tokens to receive shares and can later redeem those shares for tokens, with the value of shares corresponding to the proportion of tokens in the vault.

