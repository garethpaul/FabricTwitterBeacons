---
title: Twitter Search Reservation
type: reliability
date: 2026-06-14
status: in-progress
execution: code
---

# Twitter Search Reservation

## Summary

Reserve a beacon generation before starting Twitter search so repeated refresh
or ranging events cannot launch duplicate search and tweet-load chains for the
same active context.

## Prioritized Engineering Tasks

1. Centralize search dispatch behind a generation-aware helper.
2. Set the in-flight generation before invoking the asynchronous search.
3. Release the reservation for stale, empty, login-failure, and completed
   tweet-load paths.
4. Route both beacon arrival and manual refresh through the helper.
5. Preserve stale-context rejection and main-queue publication.

## Requirements

- R1. At most one search chain may be in flight for a beacon generation.
- R2. Reservation must happen before `Search()` dispatch.
- R3. Empty search results must release the reservation without calling the
  tweet loader.
- R4. Context invalidation must continue preventing stale UI publication.
- R5. All TwitterKit-driven UI state must remain on the main queue.

## Non-Goals

- Adding retries or replacing retired TwitterKit.
- Changing search terms, result limits, or beacon proximity rules.
- Claiming device-runtime behavior from Linux validation.

## Verification

- Pending implementation and bounded validation.
