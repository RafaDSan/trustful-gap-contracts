TestMockedResolver.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;
//OBS: Temporary mocked file to deploy a resolver
import "./Resolver.sol";

contract TestMockedResolver is Resolver {
    constructor(IEAS eas) Resolver(eas) {}

    mapping(string => bool) public allowedAttestationStrings;

    function attestMockedReview(Attestation calldata attestation) internal returns (bool) {
        return true;
    }

    function attestMockedGrant(Attestation calldata attestation) internal returns (bool) {
        return true;
    }
    
    function onAttest(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        //Logic to be applied to attestations
        return true;
    }

    function onRevoke(Attestation calldata /*attestation*/, uint256 /*value*/) internal pure override returns (bool) {
        //Logic to be applied to revocations
        return true;
    }
}