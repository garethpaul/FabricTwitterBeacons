---
title: Hidden Ranging Callback Guard
type: reliability
date: 2026-06-13
status: completed
execution: code
---

# Hidden Ranging Callback Guard

## Summary

Ignore queued beacon-ranging callbacks after the beacon screen disappears so
they cannot start new guest Twitter searches while the view is hidden.

## Requirements

- R1. Return from `didRangeBeacons` when the beacon screen is not visible.
- R2. Place the visibility guard before beacon inspection and `Search()`.
- R3. Preserve authorization, visible ranging, proximity transitions, stale
  result guards, main-queue publication, and permalink validation.
- R4. Add mutation-sensitive source, documentation, and completed-plan
  contracts.
- R5. Do not alter credentials, frameworks, project settings, plist, workflow,
  or physical-device verification claims.

## Verification Plan

- Run the full portable privacy and lifecycle baseline.
- Reject guard removal and post-search ordering mutations.
- Run shell syntax, plist, diff, exact-path, signing/secret, and artifact checks.

## Non-Goals

- Replacing Fabric/TwitterKit or claiming a device beacon/Twitter run.

## Verification

- `make check`, `make lint`, `make test`, and `make build` passed the portable
  privacy, lifecycle, project, and documentation baseline.
- Four hostile mutations were rejected across guard removal, post-search
  ordering, documentation, and completed-plan evidence.
- Shell syntax, plist parsing, diff, exact-path, signing/secret, and artifact
  checks passed.
- Xcode, signing, beacon hardware, Fabric/Twitter authentication, and physical
  device behavior were unavailable and are not claimed.
