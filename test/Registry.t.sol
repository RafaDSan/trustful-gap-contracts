// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { IResolver } from "../src/interfaces/IResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { IEAS } from "../src/interfaces/IEAS.sol";
import { IGrantRegistry } from "../src/interfaces/IGrantRegistry.sol";
import { IBadgeRegistry } from "../src/interfaces/IBadgeRegistry.sol";
import { ITrustfulResolver } from "../src/interfaces/ITrustfulResolver.sol";
import { Resolver } from "../src/resolver/Resolver.sol";

contract RegistryTest is Test {
  IEAS eas = IEAS(0xbD75f629A22Dc1ceD33dDA0b68c546A1c035c458);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0xA310da9c5B885E7fb3fbA9D66E9Ba6Df512b78eB);
  IGrantRegistry grantRegistry = IGrantRegistry(0x399629485D6B5b6209c4cbEFf5C04ccbc97d390F);
  IBadgeRegistry badgeRegistry = IBadgeRegistry(0xFD885f03b7ce1eA0D0f7Ca17E032F8Ce322886AF);
  ITrustfulResolver trustfulResolver =
    ITrustfulResolver(0x0000000000000000000000000000000000000000);
  Resolver resolver;

  function setUp() public {
    vm.startPrank(0x06a1aD4b9Ed1733F6359E00F1573Fa3F8697903B);
    resolver = new Resolver(
      eas,
      address(grantRegistry),
      address(badgeRegistry),
      address(trustfulResolver)
    );
  }

  function test_registry_badges() public {
    string memory schema = "bytes32[] badges,uint8[] score";
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
