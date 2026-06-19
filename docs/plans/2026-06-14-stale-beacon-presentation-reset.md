---
title: Stale Beacon Presentation Reset
type: correctness
date: 2026-06-14
status: completed
execution: code
---

# Stale Beacon Presentation Reset

## Summary

Clear already-published tweets when the active close-beacon context is lost.
The controller must restore its existing waiting label and spinner without
rerunning full view setup or duplicating navigation and authorization work.

## Requirements

- R1. Invalidate the active beacon generation and clear published tweets when
  ranging returns nil, no known beacons, or a transition away from immediate
  proximity.
- R2. Restore the existing waiting label and activity indicator only when they
  are absent from the view hierarchy.
- R3. Do not call `setupView()` from ranging callbacks or duplicate navigation,
  location delegate, or authorization setup.
- R4. Preserve hidden-screen callback rejection, main-queue Twitter
  publication, generation ownership, and close-beacon loading behavior.
- R5. Add mutation-sensitive source-order and documentation contracts.
- R6. Run the portable maintenance gate; keep Xcode/device validation truthful
  when unavailable on Linux.

## Non-Goals

- Modernizing legacy Swift, UIKit, CoreLocation, Fabric, or TwitterKit APIs.
- Changing beacon UUIDs, proximity thresholds, tweet search, or permalink flow.
- Claiming physical beacon or live Twitter validation.

## Implementation Units

1. Add a focused presentation-reset helper in `settee/ViewController.swift`.
2. Route active-context loss paths through the helper and remove the callback's
   full `setupView()` rerun.
3. Add a static contract, baseline wiring, and synchronized project guidance.

## Verification

- The focused presentation-reset contract passed and verified helper ordering,
  four active-context loss call sites, and the absence of callback-owned full
  view setup.
- Seven hostile source mutations were rejected: removed tweet clearing, removed
  label or spinner guards, removed spinner restart, restored `setupView()`, and
  removed nil-beacon or proximity-transition resets.
- `make check`, `make lint`, `make test`, and `make build` passed the portable
  maintenance baseline from the repository root.
- The full `make check` gate passed through the absolute Makefile path from an
  external working directory.
- Local Xcode compilation, simulator UI, physical beacon ranging, and live
  Twitter behavior were not executed because Xcode and Apple hardware are not
  available on this Linux host; hosted macOS verification remains required.
- No Fabric/Twitter credentials, signing material, live beacon payloads, or
  account-derived tweet data were used.
- Exact intended-path, generated-artifact, whitespace, conflict-marker,
  project-file preservation, and changed-line credential-pattern audits passed
  before commit.
