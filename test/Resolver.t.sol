// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { IResolver } from "../src/interfaces/IResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { IEAS } from "../src/interfaces/IEAS.sol";
import { TestMockedResolver } from "../src/resolver/TestMockedResolver.sol";

contract ResolverTest is Test {
  IEAS eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0x0a7E2Ff54e76B8E6659aedc9103FB21c038050D0);
  TestMockedResolver testMockedResolver;
  

    bytes32 public schemaId;
    address deployer = 0xF977814e90dA44bFA03b6295A0616a897441aceC; //TODO: change address

    function setUp() public {
        vm.label(deployer, "deployer");
        vm.startPrank(deployer);
        testMockedResolver = new TestMockedResolver(eas);
        schemaId = schemaRegistry.register("bool isVerified", address(testMockedResolver), true);
    }

  function test_mocked_attest() public {
        vm.stopPrank();
        vm.prank(deployer);

        AttestationRequest memory attestationRequest = AttestationRequest({
            schema: schemaId,
            data: AttestationRequestData({
                recipient: deployer,
                expirationTime: 0,
                revocable: true,
                refUID: bytes32(0),
                data: abi.encode("Test review", 5),
                value: 0
            })
        });

        bytes32 attestedMockedReviewUID = eas.attest(attestationRequest);
        assertTrue(attestedMockedReviewUID != bytes32(0));
    }

    function test_mocked_revoke() public {
        vm.stopPrank();
        vm.prank(deployer);

        AttestationRequest memory attestationRequest = AttestationRequest({
            schema: schemaId,
            data: AttestationRequestData({
                recipient: deployer,
                expirationTime: 0,
                revocable: true,
                refUID: bytes32(0),
                data: abi.encode("Test review", 5),
                value: 0
            })
        });

        bytes32 attestedMockedReviewUID = eas.attest(attestationRequest);
        assertTrue(attestedMockedReviewUID != bytes32(0));

        Attestation memory attestation = Attestation({
            schema: schemaId,
            uid: attestedMockedReviewUID,
            attester: deployer,
            recipient: deployer,
            expirationTime: 0,
            revocable: true,
            revoked: false,
            refUID: bytes32(0),
            data: abi.encode("Test review", 5),
            value: 0
        });

        bool revoked = eas.revoke(attestation);
        assertTrue(revoked);
    }

    function test_mocked_attest_grant() public {
        vm.stopPrank();
        vm.prank(deployer);

        AttestationRequest memory attestationRequest = AttestationRequest({
            schema: schemaId,
            data: AttestationRequestData({
                recipient: deployer,
                expirationTime: 0,
                revocable: true,
                refUID: bytes32(0),
                data: abi.encode("DAO Program"),
                value: 0
            })
        });

        bytes32 attestedMockedGrantUID = eas.attest(attestationRequest);
        assertTrue(attestedMockedGrantUID != bytes32(0));
    }

    function test_mocked_attest_revoke_grant() public {
        vm.stopPrank();
        vm.prank(deployer);

        AttestationRequest memory attestationRequest = AttestationRequest({
            schema: schemaId,
            data: AttestationRequestData({
                recipient: deployer,
                expirationTime: 0,
                revocable: true,
                refUID: bytes32(0),
                data: abi.encode("DAO Program"),
                value: 0
            })
        });

        bytes32 attestedMockedGrantUID = eas.attest(attestationRequest);
        assertTrue(attestedMockedGrantUID != bytes32(0));

        Attestation memory attestation = Attestation({
            schema: schemaId,
            uid: attestedMockedGrantUID,
            attester: deployer,
            recipient: deployer,
            expirationTime: 0,
            revocable: true,
            revoked: false,
            refUID: bytes32(0),
            data: abi.encode("DAO Program"),
            value: 0
        });

        bool revoked = eas.revoke(attestation);
        assertTrue(revoked);
    }
}