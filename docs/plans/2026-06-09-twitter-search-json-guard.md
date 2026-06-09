---
title: Twitter Search JSON Guard
date: 2026-06-09
status: completed
execution: code
---

## Context

The beacon-triggered Twitter search path parsed the REST response with
`json!["statuses"]`. A malformed or non-dictionary response could crash before
the search flow reported any result to callers.

## Goals

- Preserve bounded tweet ID extraction for valid search responses.
- Avoid force-unwrapping malformed Twitter search JSON.
- Complete malformed search responses with an empty result.
- Extend static verification and docs so this parsing boundary stays visible.

## Implementation

- Cast the parsed response to `JSONDictionary` before reading `statuses`.
- Return `completion(result: [])` when the parsed response is not a dictionary.
- Extended `scripts/check-baseline.sh` to reject the old force unwrap and
  require the empty-result path.
- Updated README, VISION, and CHANGES.

## Verification

- `make check`
- `git diff --check`
