---
title: Twitter Load Inflight Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

Beacon proximity changes can call the Twitter search flow more than once while
the table is still loading tweets. `ViewController` already had an
`isLoadingTweets` flag, but the flag was not set or reset around the guest
tweet-load request. Empty search results also still attempted a guest login.

## Goals

- Skip tweet loads when search returns no tweet IDs.
- Mark guest tweet loads as in-flight before starting Twitter work.
- Clear the in-flight flag when guest login fails or tweet loading completes.
- Keep tweet diagnostics generic and preserve the bounded tweet-ID search flow.

## Implementation

- Added an empty-ID guard to `loadTweets`.
- Set `isLoadingTweets` before guest login and reset it on login failure and
  `loadTweetsWithIDs` completion.
- Extended `scripts/check-baseline.sh` and project docs to preserve the
  non-overlapping tweet-load boundary.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode project listing is still skipped locally because `xcodebuild` is not
installed in this environment.
