-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install chainaccelorg/foundry-devops@0.0.11 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit && forge install foundry-rs/forge-std@v1.5.3 --no-commit && forge install openzeppelin/openzeppelin-contracts@v4.8.3 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

coverage :; forge coverage --report debug > coverage-report.txt

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif
ifeq ($(findstring --network arbitrium,,$(ARGS)),--network arbitrium)
	NETWORK_ARGS := --rpc-url $(ARBITRUIM_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif
ifeq ($(findstring --network polygon,,$(ARGS)),--network polygon)
	NETWORK_ARGS := --rpc-url $(POLYGON_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(POLYGON_API_KEY) -vvvv
endif

deploy:
	@forge script script/Deploy__Somidax__Game.s.s.sol:DeploySomidaxGame $(NETWORK_ARGS)

# Deploy__SMDX_Tokens DeploySMDXTokens
# Deploy__Somidax__Auction DeploySMDXAuction 	👍
# Deploy__Somidax__Funds DeploySomidaxFunds		👍
# Deploy__Somidax__Marketplace DeploySomidaxMarketPlace 👍
# Deploy__SomidaxNFT DeploySomidaxNFT	👍
# Deploy__Somidax__Game DeploySomidaxGame	👍

# 0xb142539ac1659b231fa1c944a62f64ad6afc6c3b	auction 👍
# 0x255dd0C3440CC1c61230CC7f659105a34dF85467  	funds	👍
# 0xa5d58F292469842ce50c10Ac7C8f2b6736878C7c	marketplace 👍
# 0xeEB57419595A68E82cDF13e93564d46799D612c1	somidax nft	👍
# 0xA8A073ACcDE3c504a8B59cfa505F7cF3C1E3852c	somidax game	👍

# ARBITRUIM
# 0xb8E482349bf3ca3Ff0203C3cDeFa0B90b5ebD078
# 0xeF0b20109086F6B133C14208e75fDcC853F744C4
# 0xfF8c1761f2874555321e54A5bEa9Eb4517A169fc
# 0xf7c9d58c913dbfb0c5c484093e42cd180d185dff
# 0x149d6e7a08083876efaaedc92bd88e3fe3dbae0e

# POLYGON
# 0x1d1Af5cde8042E43d9787Ae5f2a6cAc09A673c90	auction 👍
# 0xa20be5db2189A0114687Ca62b07890B2851849c9  	funds	👍
# 0x7403497B4214D9C71C6eAc6c288A900CE59f7ec4	marketplace 👍
# 0x0EC9Ad17d1Aa816E196776bBb1a7a5E1b3956133	somidax nft	👍
# 0x7cbb573B5A99cFF29708226Ad8d073c2629D1E4B	somidax game	👍