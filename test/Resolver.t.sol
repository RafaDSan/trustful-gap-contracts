// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { Resolver } from "../src/resolver/Resolver.sol";
import { IResolver } from "../src/interfaces/IResolver.sol";
import { ISchemaRegistry } from "../src/interfaces/ISchemaRegistry.sol";
import { IEAS, AttestationRequest, AttestationRequestData } from "../src/interfaces/IEAS.sol";
import { TestMockedResolver } from "../src/resolver/TestMockedResolver.sol";

contract ResolverTest is Test {
  IEAS eas = IEAS(0xC2679fBD37d54388Ce493F1DB75320D236e1815e);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0x0a7E2Ff54e76B8E6659aedc9103FB21c038050D0);
  TestMockedResolver testMockedResolver;

  address deployer = 0xa3b3b9eA33602914fbd5984Ec0937F4f41f7A3c2;

  function setUp() public {
    vm.label(deployer, "deployer");
    vm.startPrank(deployer);
    testMockedResolver = new TestMockedResolver(eas);
  }

  function test_mocked_controller() public {
    vm.startPrank(deployer);

    //Not functional code as there is not a controller in the mock resolver code
    //Example of testing:

    // function test_is_attester_allowed() public returns (bool) {

    // Set allowed attester strings
    // string memory attester = "Karma";

    // testMockedResolver.setAllowedAttester(attester, true);

    // Check if the strings are allowed
    //     assertTrue(testMockedResolver.isAttestationAllowed(attester));

    //   }
  }
}
