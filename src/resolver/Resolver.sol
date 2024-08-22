// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import { IEAS, Attestation } from "../interfaces/IEAS.sol";
import { IGrantRegistry } from "../interfaces/IGrantRegistry.sol";
import { IResolver } from "../interfaces/IResolver.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { AccessDenied, InvalidEAS, InvalidLength, uncheckedInc, EMPTY_UID, NO_EXPIRATION_TIME } from "../Common.sol";
import { IBadgeRegistry } from "../interfaces/IBadgeRegistry.sol";
import { ITrustfulResolver } from "../interfaces/ITrustfulResolver.sol";

error InvalidExpiration();
error InvalidAttestationData();

/// @author Blockful | 0xneves
/// @notice KarmaGap Resolver contract for Ethereum Attestation Service.
contract Resolver is IResolver, AccessControl {
  // The global EAS contract.
  IEAS internal immutable _eas;
  IGrantRegistry public grantRegistry;
  IBadgeRegistry public badgeRegistry;
  ITrustfulResolver public trustfulResolver;

  // Mapping to track if a grantee has already reviewed a grant once for statuses Completed, Cancelled, or Rejected
  mapping(bytes32 => bool) private _granteeReviewed;

  /// @dev Creates a new resolver.
  /// @param eas The address of the global EAS contract.
  constructor(
    IEAS eas,
    address grantRegistryAddr,
    address badgeRegistryAddr,
    address trustfulResolverAddr
  ) {
    if (address(eas) == address(0)) revert InvalidEAS();
    _eas = eas;
    grantRegistry = IGrantRegistry(grantRegistryAddr);
    badgeRegistry = IBadgeRegistry(badgeRegistryAddr);
    trustfulResolver = ITrustfulResolver(trustfulResolverAddr);
  }

  /// @dev Ensures that only the EAS contract can make this call.
  modifier onlyEAS() {
    if (msg.sender != address(_eas)) revert AccessDenied();
    _;
  }

  /// @inheritdoc IResolver
  function isPayable() public pure virtual returns (bool) {
    return false;
  }

  /// @inheritdoc IResolver
  //Decode array badges and score
  //Front passa o grantID no attestation
  function attest(Attestation calldata attestation) external payable onlyEAS returns (bool) {
    (
      bytes32 grantId,
      bytes32[] memory badgeIds,
      uint8[] memory badgesScores,
      string memory grantProgramLabel
    ) = abi.decode(attestation.data, (bytes32, bytes32[], uint8[], string));

    IGrantRegistry.Grant memory grant = grantRegistry.getGrant(grantId);

    // Check if badges exist
    for (uint256 i = 0; i < badgeIds.length; i++) {
      if (!badgeRegistry.badgeExists(badgeIds[i])) {
        revert("Badge does not exist");
      }
    }

    // Check if grantee is not the attester
    if (grant.grantee != attestation.attester) {
      revert InvalidAttestationData();
    }

    // Prevent review if status is Proposed
    if (grant.status == IGrantRegistry.Status.Proposed) {
      revert("Grantee cannot review a grant with Proposed status");
    }

    // Allow one last review for Completed, Cancelled, or Rejected statuses
    bool canReview = grant.status == IGrantRegistry.Status.Completed ||
      grant.status == IGrantRegistry.Status.Cancelled ||
      grant.status == IGrantRegistry.Status.Rejected;
    if (canReview && !_granteeReviewed[grantId]) {
      _granteeReviewed[grantId] = true;
    } else if (!canReview || _granteeReviewed[grantId]) {
      revert("Grantee cannot review this grant");
    }

    trustfulResolver.createStory(grantId, badgeIds, badgesScores, grantProgramLabel);

    return true;
  }

  function revoke(Attestation calldata attestation) external payable returns (bool) {
    return true;
  }
}
