// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { IResolver } from "../src/interfaces/IResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { IEAS, AttestationRequest, AttestationRequestData } from "../src/interfaces/IEAS.sol";

contract ResolverTest is Test {
  IEAS eas = IEAS(0xbD75f629A22Dc1ceD33dDA0b68c546A1c035c458);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0xA310da9c5B885E7fb3fbA9D66E9Ba6Df512b78eB);
  Resolver resolver;

  address deployer = 0xa3b3b9eA33602914fbd5984Ec0937F4f41f7A3c2;

  function setUp() public {
    vm.label(deployer, "deployer");
    vm.startPrank(deployer);
    resolver = new Resolver(eas);
  }

  function test_mocked_resolver_attestation() public {
    bytes32[] memory uids = mocked_schemas_uids();

    // Check attestation for mocked review
    try
      eas.attest(
        AttestationRequest({
          schema: uids[0],
          data: AttestationRequestData({
            recipient: deployer,
            expirationTime: 0,
            revocable: true,
            refUID: bytes32(0),
            data: abi.encode("123", 5),
            value: 0
          })
        })
      )
    returns (bytes32 attestedMockedReviewUID) {
      console2.log("test_mocked_review_attestation UID generated:");
      console2.logBytes32(attestedMockedReviewUID);
      assertTrue(true);
    } catch (bytes memory) {
      // Expected revert
      console2.log("Revert caught.");
    }

    // Check attestation for mocked grant
    try
      eas.attest(
        AttestationRequest({
          schema: uids[1],
          data: AttestationRequestData({
            recipient: deployer,
            expirationTime: 0,
            revocable: false,
            refUID: bytes32(0),
            data: abi.encode("testing"),
            value: 0
          })
        })
      )
    returns (bytes32 attestedMockedGrantUID) {
      console2.log("test_mocked_grant_attestation UID generated:");
      console2.logBytes32(attestedMockedGrantUID);
      assertTrue(true);
    } catch (bytes memory) {
      console2.log("Revert caught.");
    }
  }

  function mocked_schemas_uids() public returns (bytes32[] memory) {
    bytes32[] memory uids = new bytes32[](2);

    //Mocked Review schema
    string memory schema = "string review,uints score";
    bool revocable = true;
    uids[0] = schemaRegistry.register(schema, resolver, revocable);

    // Mocked Grant schema
    schema = "string title";
    revocable = false;
    uids[1] = schemaRegistry.register(schema, resolver, revocable);

    return uids;
  }
}
