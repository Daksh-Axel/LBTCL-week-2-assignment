# Learning Bitcoin from the Command Line - Week 2: Fee bumping a transaction

## Overview
This week, you'll learn how to fee bump a transaction using the Replace-By-Fee (RBF) and Child-Pays-for-Parent (CPFP) mechanisms. You'll write a bash script that interacts with a Bitcoin node using the `bitcoin-cli` command-line interface to perform basic Bitcoin wallet usage workflows.

## Problem Statement

Now that we have a running Bitcoin node, with a wallet connected, in this exercise, we will perform some basic Bitcoin wallet usage workflows using bash scripting and the `bitcoin-cli` command-line interface. We will focus on fee bumping using Replace-By-Fee (RBF) and Child-Pays-for-Parent (CPFP) mechanisms.

Wallets often need to fee-bump transactions in times of high fee-rate markets. There are two ways of fee bumping, RBF and CPFP. They both use different mechanisms for bumping the fee, but they cannot be used together. Trying to RBF a transaction would invalidate the CPFP, because the child transaction cannot be valid if its parent is removed from the mempool.

The following exercise attempts to demo that situation.

## Solution Requirements

You need to write a bash script that will do the following:

1. Create two wallets named `Miner` and `Trader`.
2. Fund the `Miner` wallet with at least 3 block rewards worth of satoshis (Starting balance: 150 BTC).
3. Craft a transaction from `Miner` to `Trader` with the following structure (let's call it the `Parent` transaction):
   - Input[0]: 50 BTC block reward.
   - Input[1]: 50 BTC block reward.
   - Output[0]: 70 BTC to `Trader`.
   - Output[1]: 29.99999 BTC change-back to `Miner`.
   - Signal for RBF (Enable RBF for the transaction).
4. Sign and broadcast the `Parent` transaction but do not mine it yet.
5. Make queries to the node's mempool to get the `Parent` transaction details.
   - Use `bitcoin-cli help` to get all the category-specific commands (wallet, mempool, chain, etc.).
   - Use `bitcoin-cli help <command-name>` to get usage information of specific commands.
   - Use `jq` to fetch data from `bitcoin-cli` output into bash variables and use `jq` again to craft your JSON from the variables.
   - You might have to make multiple CLI calls to get all the details.
   - Use the details to craft a JSON variable with the format mentioned below in the [Output Format](#output-format) section.
6. Output the above JSON to a file named `parent.json`.
7. Create a broadcast new transaction that spends from the above transaction (the `Parent`). Let's call it the `Child` transaction.
   - Input[0]: `Miner`'s output of the `Parent` transaction.
   - Output[0]: `Miner`'s new address. 29.99998 BTC.
8. Get the `Child` transaction details and output them to a file named `child.json`.
9. Now, fee bump the `Parent` transaction using RBF. Do not use `bitcoin-cli bumpfee`, instead hand-craft a conflicting transaction, that has the same inputs as the `Parent` but different outputs, adjusting their values to bump the fee of `Parent` by 10,000 satoshis.
10. Sign and broadcast the new Parent transaction.
11. Get the replaced `Parent` transaction details and output them to a file named `parent-rbf.json`.


### Output Format

```json
{
   "txid": "<txid>",
   "input": [
      {
         "txid": "<txid>", 
         "vout": "<num>"
      },
      ...
   ],
   "output": [
      {
         "scriptpubkey": "<scriptpubkey>", 
         "amount": "<amount in BTC>"
      },
      ...
   ],
   "fee": "<num>",
   "weight": "<num>"
}
```

## Submission

- Write your solution in `solution.sh`. Make sure to include comments explaining each step of your code.
- Commit your changes and push to the main branch:
   - Add your changes by running `git add solution.sh`.
   - Commit the changes by running `git commit -m "Solution"`.
   - Push the changes by running `git push origin main`.
- The autograder will run your script against a test script to verify the functionality.
- Check the status of the autograder on the Github Classroom portal to see if it passed successfully or failed. Once you pass the autograder with a score of 100, you have successfully completed the challenge.
- You can submit multiple times before the deadline. The last submission before the deadline will be considered your final submission.
- You will lose access to the repository after the deadline.

## Local Testing

### Prerequisites
- Install `jq` tool for parsing JSON data if you don't have it installed.
- Install Node.js and npm to run the test script.
- Node version 20 or higher is recommended. You can install Node.js using the following command:
  ```
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  source ~/.nvm/nvm.sh
  nvm install 20
  ```
- Install the required npm packages by running `npm install`.

### Testing Steps
- Start your Bitcoin Core node with the `bitcoin.conf` file with the following parameters:
  ```
  regtest=1
  fallbackfee=0.0001
  server=1
  rest=1
  txindex=1
  rpcauth=alice:88cae77e34048eff8b9f0be35527dd91$d5c4e7ff4dfe771808e9c00a1393b90d498f54dcab0ee74a2d77bd01230cd4cc
  ```
- Run your script using the command `/bin/bash solution.sh`.
- Run the test script using the command `npm run test`.
- The test script will run your script and verify the output. If the test script passes, you have successfully completed the challenge and are ready to submit your solution.

### Common Issues
- Make sure Bitcoin Core is running before running the test script. Your submission should not stop the Bitcoin Core daemon at any point.
- Make sure your `bitcoin.conf` file is correctly configured with the required parameters.
- Linux and MacOS are the recommended operating systems for this challenge. If you are using Windows, you may face compatibility issues.
- The autograder will run the test script on an Ubuntu 22.04 environment. Make sure your script is compatible with this environment.
- If you are unable to run the test script locally, you can submit your solution and check the results on the Github.

## Resources

- Useful bash script examples: [https://linuxhint.com/30_bash_script_examples/](https://linuxhint.com/30_bash_script_examples/)
- Useful `jq` examples: [https://www.baeldung.com/linux/jq-command-json](https://www.baeldung.com/linux/jq-command-json)
- Use `jq` to create JSON: [https://spin.atomicobject.com/2021/06/08/jq-creating-updating-json/](https://spin.atomicobject.com/2021/06/08/jq-creating-updating-json/)

## Evaluation Criteria
Your submission will be evaluated based on:
- **Autograder**: Your code must pass the autograder [test script](./test/test.spec.ts).
- **Explainer Comments**: Include comments explaining each step of your code.
- **Code Quality**: Your code should be well-organized, commented, and adhere to best practices.

### Plagiarism Policy
Our plagiarism detection checker thoroughly identifies any instances of copying or cheating. Participants are required to publish their solutions in the designated repository, which is private and accessible only to the individual and the administrator. Solutions should not be shared publicly or with peers. In case of plagiarism, both parties involved will be directly disqualified to maintain fairness and integrity.

### AI Usage Disclaimer
You may use AI tools like ChatGPT to gather information and explore alternative approaches, but avoid relying solely on AI for complete solutions. Verify and validate any insights obtained and maintain a balance between AI assistance and independent problem-solving.

## Why These Restrictions?
These rules are designed to enhance your understanding of the technical aspects of Bitcoin. By completing this assignment, you gain practical experience with the technology that secures and maintains the trustlessness of Bitcoin. This challenge not only tests your ability to develop functional Bitcoin applications but also encourages deep engagement with the core elements of Bitcoin technology.