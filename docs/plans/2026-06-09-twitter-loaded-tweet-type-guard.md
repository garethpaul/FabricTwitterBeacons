# Twitter Loaded Tweet Type Guard

date: 2026-06-09
status: completed

## Context

Beacon proximity and refresh actions load embedded tweets through TwitterKit.
The response path force-cast each loaded object to `TWTRTweet` and appended it
to the current table state. A malformed or unexpected TwitterKit response could
crash the view, and repeated successful loads could duplicate stale rows.

## Goals

- Avoid force-casting loaded TwitterKit response objects.
- Replace the visible tweet list from a successful load instead of appending
  duplicate stale rows.
- Preserve the existing empty-ID and in-flight request guards.
- Extend the static baseline because simulator-based Xcode verification is not
  available in this environment.

## Implementation

- Changed successful tweet loads to unwrap the response array and type-check
  each object with `as? TWTRTweet`.
- Collected valid tweet objects into a fresh array and assigned it to
  `self.tweets` once.
- Added baseline guards and documentation for the loaded tweet type boundary.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

XcodeBuildMCP simulator testing was unavailable in this Codex session, and
`xcodebuild` project listing is skipped locally when the command is missing.
