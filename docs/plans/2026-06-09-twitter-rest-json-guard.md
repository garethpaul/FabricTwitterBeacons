---
title: Twitter REST JSON Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

The legacy `RESTApi.swift` helper parsed Twitter API responses with
`json!["statuses"]`. Missing data, parse failures, or non-dictionary responses
could crash before the sample failed closed.

## Goals

- Preserve the existing Twitter login and request flow.
- Avoid force-unwrapping malformed Twitter REST JSON.
- Log generic missing-data or parse-failure messages only.
- Extend static verification and docs so the REST parsing boundary stays
  visible.

## Implementation

- Added missing-data and JSON parse-error guards in `RESTApi.swift`.
- Cast parsed REST responses to `JSONDictionary` before reading `statuses`.
- Extended `scripts/check-baseline.sh` to reject the old force unwrap and
  require the generic REST failure messages.
- Updated README, SECURITY, VISION, and CHANGES notes for the guard.

## Verification

- `sh -n scripts/check-baseline.sh`
- `scripts/check-baseline.sh`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
