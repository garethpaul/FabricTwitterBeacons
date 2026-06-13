---
title: Hidden Ranging Callback Guard
type: reliability
date: 2026-06-13
status: in progress
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
