# spin node
anvil-node-auto:
	anvil --chain-id 1337 --block-time 5

1-deploy-guessthenumber:
	forge script DeployGuessTheNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

1-solve-guessthenumber:
	forge script SolveGuessTheNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast --ffi; \

1-unit:
	forge test --match-path test/lotteries/1_GuessTheNumber.t.sol -vvv

2-deploy-guessthesecretnumber:
	forge script DeployGuessTheSecretNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

2-solve-guessthesecretnumber:
	forge script SolveGuessTheSecretRandomNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast --ffi; \

2-unit:
	forge test --match-path test/lotteries/2_GuessTheSecretNumber.t.sol -vvv

3-deploy-guesstherandomnumber:
	forge script DeployGuessTheRandomNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

3-solve-guesstherandomnumber:
	forge script SolveGuessTheRandomNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast --ffi; \

3-unit:
	forge test --match-path test/lotteries/3_GuessTheRandomNumber.t.sol -vvv --ffi

4-deploy-guessthenewnumber:
	forge script DeployGuessTheNewNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

4-solve-guessthenewnumber:
	forge script SolveGuessTheNewNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast --ffi; \

4-unit:
	forge test --match-path test/lotteries/4_GuessTheNewNumber.t.sol -vvv --ffi

5-deploy-predictthefuture:
	forge script DeployPredictTheFutureScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

5-unit:
	forge test --match-path test/lotteries/5_PredictTheFuture.t.sol -vvv --ffi

cast-storage:
	cast storage 0x8464135c8f25da09e49bc8782676a84730c318bc 0 \

cast-isCompleted:
	cast call 0x8464135c8f25da09e49bc8782676a84730c318bc \
  	"isComplete()(bool)" \

define local_network
http://127.0.0.1:$1
endef