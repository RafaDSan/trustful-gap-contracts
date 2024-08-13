// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { IResolver } from "../src/interfaces/IResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { IEAS } from "../src/interfaces/IEAS.sol";
import { Resolver } from "../src/resolver/Resolver.sol";

contract RegistryTest is Test {
  IEAS eas = IEAS(0xbD75f629A22Dc1ceD33dDA0b68c546A1c035c458);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0xA310da9c5B885E7fb3fbA9D66E9Ba6Df512b78eB);
  Resolver resolver;

  function setUp() public {
    vm.startPrank(0x06a1aD4b9Ed1733F6359E00F1573Fa3F8697903B);
    resolver = new Resolver(eas);
  }

  function test_registry_mocked_schema_review() public {
    string memory schema = "string review,uints score";
    bool revocable = true;

    bytes32 uid = schemaRegistry.register(schema, resolver, revocable);
    console2.log("test_mocked_schema_review UID generated:");
    console2.logBytes32(uid);
  }

  function test_registry_mocked_schema_grant() public {
    string memory schema = "string title";
    bool revocable = false;

    bytes32 uid = schemaRegistry.register(schema, resolver, revocable);
    console2.log("test_mocked_schema_grant UID generated:");
    console2.logBytes32(uid);
  }
}
