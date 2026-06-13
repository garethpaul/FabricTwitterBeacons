# Publish Twitter State On The Main Queue

status: completed

## Context

The legacy Twitter callbacks update `isLoadingTweets` and publish the table's
`tweets` array without an explicit main-queue boundary. TwitterKit callback
queue behavior is not a safe UIKit synchronization contract.

## Requirements

- R1. Enter `loadTweets` from search completion on the main queue before
  reading or mutating controller state.
- R2. Handle guest-login completion state on the main queue before reading or
  mutating controller state.
- R3. Handle tweet-load completion on the main queue before clearing the
  in-flight flag, checking beacon context, or publishing table data.
- R4. Keep the stale beacon/screen context check before successful tweet
  publication.
- R5. Preserve empty-input, overlapping-load, login/load failure, typed-tweet,
  result-limit, beacon lifecycle, and generic-log behavior.
- R6. Add section-scoped static contracts that reject missing, misplaced, or
  post-publication main-queue dispatch.

## Verification Plan

- Run `make lint`, `make test`, `make build`, and `make check`.
- Parse the app and test plists, check shell syntax, and run `git diff --check`.
- Reject isolated mutations that remove any dispatch, move publication
  before dispatch or stale-context validation, weaken plan/docs evidence, or
  duplicate tweet publication.
- Inspect the exact intended diff, generated artifacts, and added secret-like
  values without using Twitter credentials, beacon hardware, or live requests.

## Non-Goals

- Changing Twitter endpoints, parameters, authentication, result limits, or
  permalink behavior.
- Changing beacon identifiers, authorization, ranging, or proximity behavior.
- Modernizing Swift, UIKit, Fabric, TwitterKit, project metadata, or signing.

## Work Completed

- Added an explicit main-queue boundary between search completion and
  `loadTweets` before its controller-state checks and mutations.
- Added an explicit main-queue boundary at guest-login completion before
  controller-state validation or mutation.
- Added an explicit main-queue boundary at tweet-load completion before
  clearing the in-flight flag, rejecting stale beacon context, or assigning
  table data.
- Added section-scoped ordering and count contracts plus matching project
  guidance without changing requests, authentication, beacons, or navigation.

## Verification Completed

- `make lint`, `make test`, `make build`, and `make check` passed the maintained
  static baseline; `xcodebuild was unavailable` on this Linux host and no
  current-SDK compile or runtime result is claimed.
- Both app and test plists parsed, shell syntax and `git diff --check` passed,
  and the exact intended-file review found no generated artifacts or added
  secret-like values.
- Nine isolated hostile mutations were rejected: missing search dispatch,
  missing guest dispatch, missing result dispatch, reset-before-dispatch,
  publish-before-stale-check, duplicate publication, missing docs, stale plan
  status, and missing evidence.
- No Twitter credentials, live authentication, beacon hardware, network
  requests, account data, signing material, or physical-device state were used.
