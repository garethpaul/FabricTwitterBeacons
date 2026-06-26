# Tweet Publication Presentation Ownership

Status: Completed
Date: 2026-06-26

## Problem

Typed tweets are published on the main queue, but the waiting label and spinner
are removed only by a later beacon-ranging callback. If ranging pauses after
the network response, loaded rows can remain covered by stale waiting UI.

## Decision

- Publish typed tweets through one presentation helper on the main queue.
- Hide the waiting label and spinner immediately when that publication contains
  at least one typed tweet.
- Keep empty or fully rejected TwitterKit responses in the waiting state.
- Remove successful-publication cleanup from the ranging callback so network
  completion does not depend on another physical beacon event.

## Verification

- Add a RED source-order contract for publication-owned UI cleanup.
- Reject helper bypass, missing empty-result restoration, missing spinner
  cleanup, missing label cleanup, and ranging-owned cleanup mutations.
- Run all Make aliases, Swift policy harnesses when available, syntax checks,
  hosted macOS Xcode parsing, and CodeQL.

## Results

- RED: `make check` rejected the missing publication helper and ordered cleanup.
- GREEN: typed tweet publication now replaces rows and removes waiting UI in
  one active main-queue callback; empty typed results preserve waiting state.
- Five isolated mutations were rejected: helper bypass, missing empty-result
  restoration, missing spinner cleanup, missing label cleanup, and
  ranging-owned cleanup.
- `make check`, `make lint`, `make test`, `make build`, shell syntax, plist/XML
  parsing, secret fixtures, CI wiring, and `git diff --check` pass locally.
- `swiftc` and `xcodebuild` are unavailable on this Linux runner, so hosted
  macOS compilation/project parsing and CodeQL remain required before merge.
- Fabric/Twitter authentication and physical beacon timing remain explicitly
  manual-device boundaries.
