# spin node
anvil-node:
	anvil --chain-id 1337

1-deploy-guessthenumber:
	forge script DeployGuessTheNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

1-solve-guessthenumber:
	forge script SolveGuessTheNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

1-unit:
	forge test --match-path test/lotteries/1_GuessTheNumber.t.sol -vvv

3-unit:
	forge test --match-path test/lotteries/3_GuessTheRandomNumber.t.sol -vvv --ffi


cast-isCompleted:
	cast call 0x8464135c8f25da09e49bc8782676a84730c318bc \
  	"isComplete()" \

define local_network
http://127.0.0.1:$1
endef