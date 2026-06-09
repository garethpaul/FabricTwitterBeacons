# Beacon Ranging Privacy Guards

date: 2026-06-08
status: completed

## Context

The app already avoids logging raw beacon payloads in the app delegate, but the
waiting controller still printed proximity transitions. The ranging callbacks
also received implicitly unwrapped beacon arrays and immediately filtered them.

## Completed Scope

- Removed the waiting-screen proximity transition log.
- Added nil guards before filtering ranged beacon arrays in the main and
  waiting controllers.
- Extended the static baseline to fail if proximity logging returns or the
  ranging callbacks lose their nil guards.

## Verification

- `make check`
- `scripts/check-baseline.sh`
- `git diff --check`
