Funds Contract
Allow Users to transfer Eth,Smdx,Usdt
Allow users to Deposit
    1. Eth
    2. Usdt and Smdx
Allow users to withdraw
    1. Eth
    2. Usdt and Smdx
Alloq users to buy coffee for bloggers with smdx and usdt

Somidax MarketPlace Contract
Allow users to list NFT
Allow users to buy NFT
Allow user to cancel NFT
Allow users to transfer NFT
Get NFT Detail

Somidax Auction Contract
Allows users to Auction Nft
Allows users to delete Nft
Allows users to bid Nft
Allows users to     


# Getting Started with Create React App

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.


// nft = 0x5fbdb2315678afecb367f032d93f642f64180aa3
// somidax_marketplace = 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512
// funds = 0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0
// auction = 0xcf7ed3acca5a467e9e704c703e8d87f634fb0fc9
// token = 0xdc64a140aa3e981100a9beca4e685f962f0cf6c9


// cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "mintNFT(address,string)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 https://github.com/collinstb01 --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

// cast send 0x5fbdb2315678afecb367f032d93f642f64180aa3 "approve(address,uint256)" 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 4 --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

// cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "getCurrentTokenId()" --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d

// cast call 0x5fbdb2315678afecb367f032d93f642f64180aa3 "ownerOf(uint256)" 4 --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d


0x00000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c8



// cast send 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "ListedNFT(address,uint256,address,uint256,address)" 0x5fbdb2315678afecb367f032d93f642f64180aa3 4 0xdc64a140aa3e981100a9beca4e685f962f0cf6c9 100000000000000000 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d


// cast send 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "BoughtNFT(addressuint256,
address,uint256,address,address)" 0x558A03Ea3052620c34D12fA3A1500EbA7D135bE9 https://github.com/collinstb01 --rpc-url http://127.0.0.1:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d