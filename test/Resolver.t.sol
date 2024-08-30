// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/Resolver.sol";

contract ResolveTest is Test {
  address deployer = 0xa3b3b9eA33602914fbd5984Ec0937F4f41f7A3c2;

  address ARB_ONE_EAS = 0xbD75f629A22Dc1ceD33dDA0b68c546A1c035c458;
  address GRANT_REGISTRY = 0xf67f0Cf86589f36e6c76Cb1C7Ed188290862d46a;
  address BADGE_REGISTRY = 0x2AE204CA953227B2592734a79969821e224B83e7;

  Resolver public resolver;

  function setUp() public {
    vm.label(deployer, "deployer");
    vm.startPrank(deployer);
    resolver = new Resolver(ARB_ONE_EAS, GRANT_REGISTRY, BADGE_REGISTRY);
  }

  function test_resolver_initialize() public view {
    assert(resolver.eas() == ARB_ONE_EAS);
    assert(address(resolver.grantRegistry()) == GRANT_REGISTRY);
    assert(address(resolver.badgeRegistry()) == BADGE_REGISTRY);
  }
}
