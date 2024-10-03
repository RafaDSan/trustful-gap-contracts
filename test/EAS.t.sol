// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import { Test, console2 } from "forge-std/src/Test.sol";
import { IEAS, AttestationRequest, AttestationRequestData } from "../src/interfaces/IEAS.sol";

contract EASTest is Test {
  address deployer = 0x67eE5d3A5374849aDB4D80713a5765F164375F03;

  address public eas = 0xbD75f629A22Dc1ceD33dDA0b68c546A1c035c458;

  function setUp() public {
    vm.label(deployer, "deployer");
    vm.startPrank(deployer);
  }

  function test_attest_review() public {
    bytes32 grantUID = 0x635c2d0642c81e3191e6eff8623ba601b7e22e832d7791712b6bc28d052ff2b5;
    bytes32[] memory badgeIds = new bytes32[](7);
    uint8[] memory badgeScores = new uint8[](7);

    badgeIds[0] = 0xe02b7f93d209aa1a9708544eb17e46eee3a1f45fed0de720f4866e0caff148f8;
    badgeIds[1] = 0x446d8276789167189130fb83fce2c7b401752249a46b7e001d517c972a680219;
    badgeIds[2] = 0xb2cf2baa9cdf459fd115c1bac872e0c7318c71d1201da034ff34090bf5c9ead3;
    badgeIds[3] = 0xe85f17539b1c37dce80ab28bd08ca41f0c3f04a997756426157561ccf3447efa;
    badgeIds[4] = 0x8934465c22520a1367b2794d7c3448e531923564a89acf65fc1cb97d918eb9bd;
    badgeIds[5] = 0xc7110d04cc11dd911b5c12d4a26449fd87d7b6bf92ffbe02d0cda65b161eacb9;
    badgeIds[6] = 0x41fdc7e77ebf77189b683427e0c79506b9177b5ddad561f8e1d62b15f779dcfb;

    badgeScores[0] = 1;
    badgeScores[1] = 2;
    badgeScores[2] = 3;
    badgeScores[3] = 4;
    badgeScores[4] = 5;
    badgeScores[5] = 4;
    badgeScores[6] = 3;

    bytes memory data = abi.encode(grantUID, badgeIds, badgeScores);

    IEAS EAS = IEAS(eas);
    bytes32 schemaUID = 0x02dc5a92e5634ce3d8dd933067df1b53f661b1a53bcf8f17110c7d1ff884621f;
    address recipient = 0x67eE5d3A5374849aDB4D80713a5765F164375F03;
    uint64 expirationTime = 0;
    bool revocable = false;
    bytes32 refUID = 0x635c2d0642c81e3191e6eff8623ba601b7e22e832d7791712b6bc28d052ff2b5;
    uint256 value = 0;

    AttestationRequestData memory requestData = AttestationRequestData(
      recipient,
      expirationTime,
      revocable,
      refUID,
      data,
      value
    );

    AttestationRequest memory request = AttestationRequest({
      schema: schemaUID,
      data: requestData
    });

    bytes32 uid = EAS.attest(request);
    console2.logBytes32(uid);
  }
}
