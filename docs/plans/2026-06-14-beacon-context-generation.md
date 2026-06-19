---
title: Beacon Tweet Context Generation
type: reliability
status: completed
date: 2026-06-14
---

# Beacon Tweet Context Generation

## Summary

Replace the boolean-only stale tweet guard with a monotonically increasing
beacon-context generation. Search, guest-login, and tweet-load callbacks must
match the generation that initiated them, so results from an earlier
leave-and-return cycle cannot overwrite the current beacon session.

## Prioritized Engineering Tasks

1. Increment the context generation when the beacon screen disappears or a
   close beacon context is lost.
2. Capture the generation before each close-range search and pass it through
   tweet loading.
3. Require screen visibility, close proximity, and generation equality before
   login, request, and result publication.
4. Preserve main-queue publication, in-flight request suppression, typed tweet
   filtering, authorization behavior, and validated permalink navigation.

## Requirements

- R1. A callback from a prior close-beacon cycle must fail closed after the
  user leaves and returns.
- R2. Authorization loss plus empty, unknown, near, far, and hidden ranging
  states must invalidate a previously active close context when it is lost.
- R3. Search and refresh flows must capture and propagate their initiating
  generation to `loadTweets`.
- R4. Static contracts must prove generation capture, invalidation, propagation,
  and pre-publication checks in source order.
- R5. Repository guidance must document the generation boundary and its device
  validation limitation.

## Non-Goals

- Cancelling TwitterKit requests, replacing TwitterKit, or changing hashtags.
- Changing beacon UUIDs, authorization scope, proximity thresholds, or UI copy.
- Claiming physical beacon/Twitter behavior without the existing device runbook.

## Verification

- Focused source-order and synthetic leave/return generation checks passed.
- Seven isolated hostile mutations were rejected for generation increment,
  equality, propagation, in-flight ownership, authorization-loss invalidation,
  documentation, and completed-plan evidence.
- `make check` passed from the checkout and from `/tmp` through the absolute
  Makefile path. Both runs truthfully skipped `xcodebuild` because it is not
  installed on the Linux host.
- Both plist parses, exact intended-path review, unchanged project/framework/
  workflow inspection, generated-artifact, untracked-file, conflict-marker,
  whitespace, and changed-line credential-pattern audits passed.
- Sequential Swift correctness, lifecycle, concurrency, maintainability, and
  test review found no actionable issue. XcodeBuildMCP is not connected, so
  hosted macOS parsing and the physical-device runbook remain authoritative.
- Browser testing is not applicable to this native beacon application.
- One bounded exact-head hosted check and code-scanning snapshot is required
  after push; pending jobs will not be polled.
