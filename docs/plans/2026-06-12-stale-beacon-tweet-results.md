# Stale Beacon Tweet Result Guard

## Status: Completed

## Goal

Prevent asynchronous Twitter guest-login and tweet-load callbacks from
continuing or publishing results after the beacon screen is hidden or the user
is no longer in immediate proximity.

## Prioritized Engineering Work

1. **Bind tweet loading to the active beacon context (this change).** Check
   screen visibility and immediate proximity before starting guest login, after
   login completes, and before replacing displayed tweets.
2. **Move Twitter-driven UI state to the main queue (follow-up).** Make callback
   queue assumptions explicit and serialize table/loading state updates on the
   UI thread during a dedicated modernization pass.
3. **Avoid rebuilding navigation and waiting views (follow-up).** Reset existing
   UI elements instead of calling `setupView()` repeatedly as proximity changes.
4. **Modernize the retired TwitterKit integration (follow-up).** Replace or
   archive the unsupported SDK path with a separately reviewed product and API
   decision.

## Requirements

- R1. A single helper must define the active tweet context as a visible beacon
  screen with immediate proximity.
- R2. `loadTweets` must not start guest authentication when that context is
  inactive or the tweet ID list is empty.
- R3. Guest-login completion must stop before `loadTweetsWithIDs` if the context
  became inactive while authentication was pending.
- R4. Tweet-load completion must clear `isLoadingTweets` and discard loaded
  objects if the context became inactive while the request was pending.
- R5. Valid close-beacon results must retain typed `TWTRTweet` filtering and the
  existing table update behavior.
- R6. Generic logging, result limits, authorization, visible-screen ranging,
  and all existing failure completions must remain unchanged.
- R7. The static baseline and documentation must reject removal or reordering of
  the three active-context checks.

## Verification

- `make check`.
- Hosted `xcodebuild -list -project settee.xcodeproj` through GitHub Actions.
- `git diff --check`.
- Mutation check: removing the post-login context check must fail the static
  ordering guard.
- Mutation check: moving tweet assignment before the completion context check
  must fail the static ordering guard.

## Compatibility Boundary

The project uses a retired Swift/TwitterKit toolchain. Current hosted Xcode can
parse the project but does not compile or execute this code, so this focused
change uses the established source-contract verification boundary.

## Work Completed

- Added `hasActiveBeaconTweetContext()` as the single visible-screen and
  immediate-proximity predicate.
- Rechecked that predicate before guest authentication, after authentication,
  and after tweet loading before table assignment.
- Kept `isLoadingTweets` reset before the final stale-result exit so moving away
  or hiding the screen cannot wedge future close-beacon loads.
- Preserved typed `TWTRTweet` filtering and all existing generic failure logs,
  search completions, authorization, and result limits.
- Updated current project/privacy documentation and added count and source-order
  baseline guards.

## Verification Completed

- `make check` passes locally; Xcode listing is skipped because this Linux host
  does not provide `xcodebuild`.
- `git diff --check` passes.
- Removing the post-login context check makes `make check` fail.
- Moving tweet assignment before the final context check makes `make check`
  fail.
- GitHub Actions push run `27391974765` passed on `macos-15`.
- GitHub Actions pull-request run `27391975696` passed on `macos-15`; both runs
  completed `xcodebuild -list -project settee.xcodeproj`.
