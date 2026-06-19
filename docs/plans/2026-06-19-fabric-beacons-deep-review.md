# Fabric Twitter Beacons Deep Review

## Status: In progress

## Scope

Review and consolidate pull requests #1 and #3-#14 with evidence-first checks
across credentials, beacon lifecycle ownership, Twitter search parsing,
permalink navigation, privacy configuration, and hosted CI.

## Findings and provenance

- The original 2014 project committed provider credentials. Commit `b364e03`
  removed them from the default project, but `68ff10a` copied the known values
  into a baseline checker and the #1-#13 stack carried those literals forward.
  The current tree now stores only non-reversible fingerprints. Public Git
  history still requires provider-side revocation or retired-app deletion plus
  activity review.
- Commit `754840f` added top-level JSON guards but retained dynamic subscripting
  of each untyped status entry. Dictionary casting, canonical ID validation,
  deduplication, and an early 20-result stop now protect that boundary.
- Commit `fe06375` invalidated callback generations on screen hide without
  clearing already-published tweets. The shared reset helper now invalidates
  generations and clears visible content before the screen can reappear.
- Commit `5b886c6` and the later permalink policy constrained scheme and host but
  accepted any path on those hosts. The production predicate now requires a
  canonical username/status/positive-decimal-ID path.

## Verification

- Executable Swift policy tests cover Twitter/X permalinks and tweet IDs.
- Static checks verify typed, deduplicated, bounded JSON extraction and stale
  presentation reset ownership.
- Exact revoked-value fingerprints and redacted Gitleaks scan the current tree.
- Five hostile mutations cover ID canonicalization, entry type checks, stale
  screen-hide reset, status-path validation, and checkout credential persistence.
- `make check`, Xcode project parsing, hosted Check, and hosted CodeQL provide
  the final merge evidence.

## Residual risk

The archival Fabric/Twitter services, provider credentials, physical iBeacon
hardware, signed iOS device, live location authorization transitions, and
TwitterKit network behavior are unavailable. Those remain device/provider
verification requirements and are not inferred from static or hosted checks.
