// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/// @notice The interface of the {Resolver} contract.
interface IEASResolver {
  /// @notice A struct representing a single attestation.
  struct Attestation {
    bytes32 uid; // A unique identifier of the attestation.
    bytes32 schema; // The unique identifier of the schema.
    uint64 time; // The time when the attestation was created (Unix timestamp).
    uint64 expirationTime; // The time when the attestation expires (Unix timestamp).
    uint64 revocationTime; // The time when the attestation was revoked (Unix timestamp).
    bytes32 refUID; // The UID of the related attestation.
    address recipient; // The recipient of the attestation.
    address attester; // The attester/sender of the attestation.
    bool revocable; // Whether the attestation is revocable.
    bytes data; // Custom attestation data.
  }

  /// @notice Returns an existing attestation by UID.
  /// @param uid The UID of the attestation to retrieve.
  /// @return The attestation data members.
  function getAttestation(bytes32 uid) external view returns (Attestation memory);

  /// @notice Returns the owner of the project.
  /// @param key The key of the project.
  function projectOwner(bytes32 key) external view returns (address);
}
