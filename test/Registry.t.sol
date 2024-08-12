// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { IResolver } from "../src/interfaces/IResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { IEAS } from "../src/interfaces/IEAS.sol";
import { TestMockedResolver } from "../src/resolver/TestMockedResolver.sol";

contract RegistryTest is Test {
  IEAS eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0x0a7E2Ff54e76B8E6659aedc9103FB21c038050D0);
  // IResolver resolver;
  TestMockedResolver testMockedResolver;

  function setUp() public {
    vm.startPrank(0x06a1aD4b9Ed1733F6359E00F1573Fa3F8697903B);
    testMockedResolver = new TestMockedResolver(eas);
  }

  function test_mocked_schema_review() public {
    string memory schema = "string review, uints score";
    bool revocable = true;

    bytes32 uid = schemaRegistry.register(schema, testMockedResolver, revocable);
    console2.log("test_mocked_schema_review UID generated:");
    console2.logBytes32(uid);
  }

  function test_mocked_schema_grant() public {
    string memory schema = "string title";
    bool revocable = false;

    bytes32 uid = schemaRegistry.register(schema, testMockedResolver, revocable);
    console2.log("test_mocked_schema_grant UID generated:");
    console2.logBytes32(uid);
  }

}