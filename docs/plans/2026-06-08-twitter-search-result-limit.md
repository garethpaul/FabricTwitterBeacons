# Twitter Search Result Limit

date: 2026-06-08
status: completed

## Context

`TVSearchAPI.Search` requested up to 50 search results and returned every tweet
ID to the caller. The repository already had `limitTweetIDs`, but the search
flow did not use it before asking TwitterKit to load embedded tweets.

## Completed Scope

- Applied `limitTweetIDs(tweetArray, maxCount: 20)` before completing search.
- Extended the static baseline to require the bounded search result flow.
- Recorded the behavior in `CHANGES.md`.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`
