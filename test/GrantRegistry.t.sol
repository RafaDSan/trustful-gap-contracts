// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { GrantRegistry } from "../src/GrantRegistry.sol";
import { IGrantRegistry } from "../src/interfaces/IGrantRegistry.sol";
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
    address[] memory grantees = new address[](2);
    uint256[] memory chains = new uint256[](2);
    uint256[] memory statuses = new uint256[](2);

    // https://gap.karmahq.xyz/project/arbitrum-thailand/grants?tab=overview
    grantUIDs[0] = 0x635c2d0642c81e3191e6eff8623ba601b7e22e832d7791712b6bc28d052ff2b5;
    grantProgramUIDs[0] = 260;
    grantees[0] = 0x343e6C4512c9f43C4b80994897627BCd29D2a956;
    chains[0] = 42161;
    statuses[0] = 1;
    // https://gap.karmahq.xyz/project/omni-analytics-group/grants?tab=overview
    grantUIDs[1] = 0xcdaa67fc005df1417c7f9a54eee0d62ec3b44d157eba707b3a0169d4cbca9bf3;
    grantProgramUIDs[1] = 260;
    grantees[1] = 0x41D2a18E1DdACdAbFDdADB62e9AEE67c63070b76;
    chains[1] = 42161;
    statuses[1] = 1;

    grantRegistry.register(
      grantUIDs[0],
      grantProgramUIDs[0],
      grantees[0],
      chains[0],
      IGrantRegistry.Status(statuses[0])
    );
    grantRegistry.register(
      grantUIDs[1],
      grantProgramUIDs[1],
      grantees[0],
      chains[0],
      IGrantRegistry.Status(statuses[1])
    );

    assert(uint256(grantRegistry.getStatus(grantUIDs[0])) == 1);
    assert(uint256(grantRegistry.getStatus(grantUIDs[1])) == 1);
    assert(grantRegistry.getGranteeAddress(grantUIDs[0]) == grantees[0]);
    assert(grantRegistry.getGrantProgramUID(grantUIDs[0]) == grantProgramUIDs[0]);

    grantRegistry.update(grantUIDs[0], 2);
    assert(uint256(grantRegistry.getStatus(grantUIDs[0])) == 2);

    grantRegistry.remove(grantUIDs[0]);
  }

  function test_grant_registry_batch() public {
    IGrantRegistry.Grant[] memory grants = new IGrantRegistry.Grant[](2);

    grants[0] = IGrantRegistry.Grant(
      0x635c2d0642c81e3191e6eff8623ba601b7e22e832d7791712b6bc28d052ff2b5,
      260,
      0x343e6C4512c9f43C4b80994897627BCd29D2a956,
      42161,
      IGrantRegistry.Status(1)
    );

    grants[1] = IGrantRegistry.Grant(
      0xcdaa67fc005df1417c7f9a54eee0d62ec3b44d157eba707b3a0169d4cbca9bf3,
      260,
      0x41D2a18E1DdACdAbFDdADB62e9AEE67c63070b76,
      42161,
      IGrantRegistry.Status(1)
    );

    grantRegistry.batchRegister(grants);

    assert(uint256(grantRegistry.getStatus(grants[0].grantUID)) == 1);
    assert(uint256(grantRegistry.getStatus(grants[1].grantUID)) == 1);

    grantRegistry.update(grants[0].grantUID, 2);
    assert(uint256(grantRegistry.getStatus(grants[0].grantUID)) == 2);

    grantRegistry.remove(grants[0].grantUID);
    grantRegistry.remove(grants[1].grantUID);
  }
}
