# spin node
anvil-node:
	anvil --chain-id 1337

1-deploy-guessthenumber:
	forge script DeployGuessTheNumberScript --rpc-url $(call local_network,8545)  -vvvv --broadcast; \

1-unit:
	forge test --match-path test/GuessTheNumber.t.sol -vvv

define local_network
http://127.0.0.1:$1
endef