---
title: View Appearance Lifecycle Consolidation
type: correctness
date: 2026-06-13
status: completed
execution: code
---

# View Appearance Lifecycle Consolidation

## Status: Completed

## Summary

Consolidate the duplicate `viewWillAppear` overrides so the legacy controller
can compile while preserving both visible-use beacon ranging and logo animation.

## Problem

`ViewController` declares `viewWillAppear(animated:)` twice in the same class.
One override marks the beacon screen visible and conditionally starts ranging;
the other animates the navigation logo. Swift rejects this duplicate method
declaration before either behavior can run.

## Requirements

- R1. Keep exactly one `viewWillAppear(animated:)` override.
- R2. Call `super.viewWillAppear(animated)` exactly once in that override.
- R3. Mark the screen visible before conditionally starting beacon ranging.
- R4. Preserve the existing logo animation in the same override.
- R5. Preserve `viewWillDisappear` ranging shutdown, authorization handling,
  stale callback guards, main-queue publication, and tweet behavior.
- R6. Add source-order, uniqueness, documentation, and mutation contracts.
- R7. Do not claim a modern Swift compile or physical beacon/Twitter execution
  from the Linux maintenance environment.

## Verification Plan

- Run a focused lifecycle source-order and uniqueness contract.
- Run `make check`, `make lint`, `make test`, and `make build`.
- Reject mutations that duplicate the override, remove visibility/ranging or
  animation behavior, stale the plan, or remove evidence.
- Audit exact paths, generated artifacts, secrets/signing material, and project,
  workflow, framework, and plist preservation.

## Non-Goals

- Modernizing the legacy Swift or TwitterKit/Fabric APIs.
- Changing beacon regions, authorization scope, tweet loading, or UI design.

## Work Completed

- Moved the existing logo animation into the visible-use `viewWillAppear`
  override after authorization-aware ranging setup.
- Removed the duplicate override that prevented Swift compilation.
- Added uniqueness and source-order contracts plus synchronized maintenance
  guidance.

## Verification Completed

- The focused lifecycle contract found exactly one override with one super
  call, visibility publication, authorized ranging, and logo animation in order.
- `make check`, `make lint`, `make test`, and `make build` passed the maintained
  Linux baseline; local xcodebuild was unavailable and is not claimed.
- `sh -n scripts/check-baseline.sh` and `git diff --check` passed.
- Six isolated hostile mutations were rejected: duplicate override, missing
  visibility, missing ranging, missing animation, stale plan status, and missing
  mutation evidence.
- No Fabric/Twitter credentials, signing, beacon hardware, physical-device
  ranging, or live Twitter request was used.
