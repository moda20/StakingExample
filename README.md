## Blockchain Engineer Assignment 
### Introduction
This project is originally an assignment for a recruitment process.
the goal is to make a stackable token with separate token rewards 
based on staking time. something similar to bank account interests.
The project uses truffle to compile and deploy the smart contracts

### Design

The design of the contract is a 3 token contract. StakingFile for managing the staking
and stakeholders and the rewards as well. A stakeable token to serve as the token 
to be staked and the reward Token to serve as the reward for staking for the specified duration.



### Usage

When developing the smart contracts i used the truffle suite of tools to help with the 
development and deployment of the contracts. 

you can download truffle

```bash
$ npm install -g truffle
```

to deploy the contracts I used `ganache` as my eth network and node emulator and 
it is also part of the truffle and suite and can be downloaded from the main truffle web page.


#### Deployment

to deploy the smart contracts and execute the deployment script run in the root of the project:

```bash
$ truffle deploy
```

**Note: I used solc version 0.8.0 as my compiler**

#### Testing

Testing the staking process can be via invoking the smart contract directly from your own scripts
or by running the included tests.

to run the tests use the following command : 
```shell
truffle exec test/testStakingAddStake.js
```
change the name of the file to whatever test file you want to execute. this way truffle will
inject it's tools like artifacts and web3 in the runtime of the `exec` command
