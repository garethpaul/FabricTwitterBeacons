---
title: Twitter Log Boundary
date: 2026-06-09
status: completed
execution: code
---

## Context

The beacon sample already avoids raw beacon payload logging, but app-owned
Twitter helper code still printed raw errors, account usernames, and tweet IDs.
Those values can identify a user account, API response, or physical proximity
session when combined with beacon-triggered behavior.

## Goals

- Keep Twitter diagnostics generic.
- Avoid logging usernames, tweet IDs, raw client errors, and localized error
  details.
- Preserve the current guest-search and bounded tweet-ID flow.
- Keep static verification available without Xcode.

## Implementation

- Replaced raw Twitter error logs in `ViewController.swift` and
  `TVSearchAPI.swift` with generic messages.
- Removed account and tweet-ID logging from the older `RESTApi.swift` helper.
- Extended `scripts/check-baseline.sh` with source guards for raw Twitter log
  details.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode project listing is still skipped locally because `xcodebuild` is not
installed in this environment.
