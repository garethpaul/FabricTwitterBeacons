# Publish Twitter State On The Main Queue

status: planned

## Context

The legacy Twitter callbacks update `isLoadingTweets` and publish the table's
`tweets` array without an explicit main-queue boundary. TwitterKit callback
queue behavior is not a safe UIKit synchronization contract.

## Requirements

- R1. Handle guest-login completion state on the main queue before reading or
  mutating controller state.
- R2. Handle tweet-load completion on the main queue before clearing the
  in-flight flag, checking beacon context, or publishing table data.
- R3. Keep the stale beacon/screen context check before successful tweet
  publication.
- R4. Preserve empty-input, overlapping-load, login/load failure, typed-tweet,
  result-limit, beacon lifecycle, and generic-log behavior.
- R5. Add section-scoped static contracts that reject missing, misplaced, or
  post-publication main-queue dispatch.

## Verification Plan

- Run `make lint`, `make test`, `make build`, and `make check`.
- Parse the app and test plists, check shell syntax, and run `git diff --check`.
- Reject isolated mutations that remove either dispatch, move publication
  before dispatch or stale-context validation, weaken plan/docs evidence, or
  duplicate tweet publication.
- Inspect the exact intended diff, generated artifacts, and added secret-like
  values without using Twitter credentials, beacon hardware, or live requests.

## Non-Goals

- Changing Twitter endpoints, parameters, authentication, result limits, or
  permalink behavior.
- Changing beacon identifiers, authorization, ranging, or proximity behavior.
- Modernizing Swift, UIKit, Fabric, TwitterKit, project metadata, or signing.
