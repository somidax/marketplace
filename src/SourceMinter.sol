 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.20;

import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {Withdraw} from "./Withdraw.sol";

// /**
//  * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
//  * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
//  * DO NOT USE THIS CODE IN PRODUCTION.
//  */
contract SourceMinter is Withdraw {
    enum PayFeesIn {
         Native,
         LINK
     }

     address immutable i_router;
     address immutable i_link;

     event MessageSent(bytes32 messageId);

     constructor(address router, address link) {
         i_router = router;
         i_link = link;
         LinkTokenInterface(i_link).approve(i_router, type(uint256).max);
     }

     receive() external payable {}

     function getFee(
         uint64 destinationChainSelector,
         address receiver,
         PayFeesIn payFeesIn,
         string memory tokenURI
     ) external view returns (uint256 _fee) {
         Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
             receiver: abi.encode(receiver),
             data: abi.encodeWithSignature("mint(address,string)", msg.sender,tokenURI),
             tokenAmounts: new Client.EVMTokenAmount[](0),
             extraArgs: "",
             feeToken: payFeesIn == PayFeesIn.LINK ? i_link : address(0)
         });

         uint256 fee = IRouterClient(i_router).getFee(
             destinationChainSelector,
             message
         );

         return fee;
     }
     function mint(
         uint64 destinationChainSelector,
         address receiver,
         PayFeesIn payFeesIn,
         uint256 fee,
         string memory tokenURI
     ) external payable  {
         (bool success,) = payable(address(this)).call{value: msg.value}("");
         require(success, "Failed to send ethereum");

         Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
             receiver: abi.encode(receiver),
             data: abi.encodeWithSignature("mint(address,string)", msg.sender,tokenURI),
             tokenAmounts: new Client.EVMTokenAmount[](0),
             extraArgs: "",
             feeToken: payFeesIn == PayFeesIn.LINK ? i_link : address(0)
         });

        bytes32 messageId;

        if (payFeesIn == PayFeesIn.LINK) {
             // LinkTokenInterface(i_link).approve(i_router, fee);
             messageId = IRouterClient(i_router).ccipSend(
                 destinationChainSelector,
                 message
             );
         } else {
             messageId = IRouterClient(i_router).ccipSend{value: fee}(
                 destinationChainSelector,
                 message
             );
         }

         emit MessageSent(messageId);
     }
}
