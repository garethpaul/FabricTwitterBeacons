# Orphaned Waiting Controller Design

## Status: Accepted

## Problem

`settee/WaitingController.swift` is not referenced by the storyboard or the
Xcode project source phase, but it still contains an obsolete beacon flow that
requests always-on location authorization and starts ranging without matching
screen-lifecycle cleanup. The file cannot affect the current app build, yet it
remains a misleading implementation that could be copied or accidentally added
back to the target.

## Constraints

- Preserve the active `ViewController` beacon and Twitter behavior.
- Preserve the current Xcode target membership and storyboard structure.
- Keep the when-in-use, visible-screen authorization contract authoritative.
- Avoid broad cleanup of unrelated historical source files.

## Options Considered

1. **Remove the unreachable controller and prohibit its return.** This removes
   the misleading privacy-sensitive implementation without changing runtime
   behavior.
2. Rewrite the controller to follow current lifecycle rules. Rejected because
   it has no storyboard, project, or source references and therefore has no
   maintained runtime role.
3. Leave the file in place. Rejected because its always-on authorization and
   unmanaged ranging conflict with the repository's documented safety model.

## Decision

Delete `settee/WaitingController.swift` and add a baseline contract requiring
that the orphan remain absent. Keep the active `ViewController` and its
framework-owned lifecycle unchanged.

## Validation

- Prove the controller is absent from the storyboard and project source phase.
- Observe the new baseline contract fail while the orphan still exists.
- Remove the file and run every Make verification alias.
- Confirm hosted Xcode parsing and security checks pass on the exact PR head.
