// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { IEAS } from "./../src/interfaces/IEAS.sol";
import { TestMockedResolver } from "../src/resolver/TestMockedResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { Attestation } from "../src/Common.sol";

contract EASTest is Test {
  IEAS eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0x0a7E2Ff54e76B8E6659aedc9103FB21c038050D0);
  TestMockedResolver testMockedResolver;
  

    bytes32 public schemaId;
    address deployer = 0xF977814e90dA44bFA03b6295A0616a897441aceC; //TODO: change address

    function setUp() public {
        vm.label(deployer, "deployer");
        vm.startPrank(deployer);
        testMockedResolver = new TestMockedResolver(eas);
    }
    
    function test_mocked_attestations() public {
        
        bytes32 attestedMockedReviewUID = test_attest_mocked_review(schemaId, deployer, "Nice Grant", 5);
        assertTrue(attestedMockedReviewUID != bytes32(0));
        
        bytes32 attestedMockedGrantUID = test_attest_mocked_grant(schemaId, deployer, "DAO Program");
        assertTrue(attestedMockedGrantUID != bytes32(0));
    }




    function test_attest_mocked_review(
        bytes32 schemaUID,
        address recipient,
        string memory review,
        uint256 score
    ) public returns (bytes32) {
      return 
        eas.attest(
            AttestationRequest({
                schema: schemaUID,
                data: AttestationRequestData({
                    recipient: recipient,
                    expirationTime: 0,
                    revocable: true,
                    refUID: bytes32(0),
                    data: abi.encode(review, score),
                    value: 0
                })
            }
        );
    }

    function test_attest_mocked_grant(
        bytes32 schemaUID,
        address recipient,
        string memory grant,
    ) public returns (bytes32) {
      return 
        eas.attest(
            AttestationRequest({
                schema: schemaUID,
                data: AttestationRequestData({
                    recipient: recipient,
                    expirationTime: 0,
                    revocable: true,
                    refUID: bytes32(0),
                    data: abi.encode(grant),
                    value: 0
                })
            }
        );
    }

}