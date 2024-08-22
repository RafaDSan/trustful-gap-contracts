//SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

interface ITrustfulResolver {
  function createStory(
    bytes32 txUID,
    bytes32[] calldata badges,
    uint8[] calldata badgeScores,
    string memory grantProgramLabel
  ) external;
}
