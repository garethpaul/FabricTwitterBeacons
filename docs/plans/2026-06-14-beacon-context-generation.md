---
title: Beacon Tweet Context Generation
type: reliability
status: planned
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
- R2. Empty, unknown, near, far, and hidden ranging states must invalidate a
  previously active close context exactly when that context is lost.
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

## Planned Verification

- Run focused source-order and synthetic leave/return generation checks.
- Run the full `make check` gate from the checkout and `/tmp`.
- Reject isolated hostile mutations for missing invalidation, generation
  propagation, equality checks, publication order, documentation, and completed
  plan evidence.
- Run plist parsing, exact intended-path, project/dependency, artifact,
  conflict-marker, whitespace, and changed-line credential audits.
- Take one bounded exact-head hosted check and code-scanning snapshot after push;
  do not poll pending jobs.
