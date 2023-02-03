// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// import { MarketAPI } from "@zondax/filecoin-solidity/contracts/v0.8/MarketAPI.sol";
// import { CommonTypes } from "@zondax/filecoin-solidity/contracts/v0.8/types/CommonTypes.sol";
// import { MarketTypes } from "@zondax/filecoin-solidity/contracts/v0.8/types/MarketAPI.sol";
// import { BigInt } from "@zondax/filecoin-solidity/contracts/v0.8/cbor/BigNumberCbor.sol";

contract StorageLoan {

    // address immutable filecoin = 0x0d8ce2a99bb6e3b7db580ed848240e4a0f9ae153; its probably a native asset here actually

    mapping (address => loanAgreement[]) loanInformation;

    struct loanAgreement {
        address lender;
        address borrower;
        // address escrow;
        uint256 size;
        uint48 created;
        bool interest; 
    }

    function createAgreement(address lender, address borrower, bool interest) public payable returns (loanAgreement memory) {

        loanInformation[lender].push(
            loanAgreement({
            lender: lender,
            borrower: borrower,
            size: msg.value,
            created: uint48(block.timestamp),
            interest: interest
        })
        );

        (bool success, ) = borrower.call{value:msg.value}("");
        require(success, "Transfer failed.");

        return loanInformation[lender][loanInformation[lender].length];

    }


    /*
    Okay so, we need to be able to create a loan agreement, store the terms, and check against them.

    If the loan is invalid, it needs to be able to nullify it and delete the data. 
    It also needs to be able to liquidate the borrower

    The loan should have an arbitrarily large duration, no/low interest,
    and the denomination should match that of the collateral requirements for a storage provider.

    It might need a forwarding contract to act as a middleman for the storage miner
    i.e during liquidation, it must be able to withdraw collateral and return it to the lender 

    This might be done best as a factory, especially if there is a middleman contract
    */

}