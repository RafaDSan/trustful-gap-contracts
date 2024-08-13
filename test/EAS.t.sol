// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { IEAS, AttestationRequest, AttestationRequestData } from "./../src/interfaces/IEAS.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";

contract EASTest is Test {
  IEAS eas = IEAS(0xbD75f629A22Dc1ceD33dDA0b68c546A1c035c458);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0xA310da9c5B885E7fb3fbA9D66E9Ba6Df512b78eB);
  Resolver resolver;

  address deployer = 0xa3b3b9eA33602914fbd5984Ec0937F4f41f7A3c2;

  function setUp() public {
    vm.label(deployer, "deployer");
    vm.startPrank(deployer);
    resolver = new Resolver(eas);
  }

  function test_mocked_attestations() public {
    bytes32[] memory uids = mocked_schemas_uids();

    bytes32 attestedMockedReviewUID = test_attest_mocked_review(
      uids[0],
      deployer,
      "ValidAttestation",
      5
    );
    console2.log("test_mocked_review_attestation UID generated:");
    console2.logBytes32(attestedMockedReviewUID);
    assertTrue(attestedMockedReviewUID != bytes32(0));

    bytes32 attestedMockedGrantUID = test_attest_mocked_grant(
      uids[1],
      deployer,
      "ValidAttestation"
    );
    console2.log("test_mocked_grant_attestation UID generated:");
    console2.logBytes32(attestedMockedGrantUID);
    assertTrue(attestedMockedGrantUID != bytes32(0));
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
        })
      );
  }

  function test_attest_mocked_grant(
    bytes32 schemaUID,
    address recipient,
    string memory grantTitle
  ) public returns (bytes32) {
    return
      eas.attest(
        AttestationRequest({
          schema: schemaUID,
          data: AttestationRequestData({
            recipient: recipient,
            expirationTime: 0,
            revocable: false,
            refUID: bytes32(0),
            data: abi.encode(grantTitle),
            value: 0
          })
        })
      );
  }
}
