// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { GrantRegistry } from "../src/GrantRegistry.sol";
import { IEASResolver } from "../src/interfaces/IEASResolver.sol";

contract GrantRegistryTest is Test {
  address deployer = 0xa3b3b9eA33602914fbd5984Ec0937F4f41f7A3c2;

  GrantRegistry public grantRegistry;

  function setUp() public {
    vm.label(deployer, "deployer");
    vm.startPrank(deployer);
    grantRegistry = new GrantRegistry();
  }

  function test_grant_registry() public {
    bytes32[] memory grantUIDs = new bytes32[](2);
    uint256[] memory grantProgramUIDs = new uint256[](2);
    uint256[] memory statuses = new uint256[](2);

    grantUIDs[0] = 0x635c2d0642c81e3191e6eff8623ba601b7e22e832d7791712b6bc28d052ff2b5;
    grantProgramUIDs[0] = 260;
    statuses[0] = 1;

    grantUIDs[1] = 0xcdaa67fc005df1417c7f9a54eee0d62ec3b44d157eba707b3a0169d4cbca9bf3;
    grantProgramUIDs[1] = 260;
    statuses[1] = 1;

    grantRegistry.register(grantUIDs[0], grantProgramUIDs[0], statuses[0]);
    grantRegistry.register(grantUIDs[1], grantProgramUIDs[1], statuses[1]);

    assert(uint256(grantRegistry.getStatus(grantUIDs[0])) == 1);
    assert(uint256(grantRegistry.getStatus(grantUIDs[1])) == 1);
  }
}
