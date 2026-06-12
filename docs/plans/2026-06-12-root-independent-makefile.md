# Root-Independent Makefile Verification

## Status: Completed

## Problem

The absolute Makefile can be invoked from another directory, but its current
recipe runs `./scripts/check-baseline.sh` relative to the caller. That makes the
documented verification entry point fail outside the repository and leaves the
existing static checker unable to detect the regression.

## Plan

1. Resolve the repository root from `MAKEFILE_LIST` and run the baseline script
   through an absolute Make variable.
2. Extend the baseline checker to require the root and script definitions and
   the completed maintenance plan.
3. Document the external-directory command in the README and changelog.
4. Run local and external `make check`, shell syntax, a hostile Makefile
   mutation, and hosted exact-head verification.

## Verification

- The Makefile now resolves `scripts/check-baseline.sh` from `MAKEFILE_LIST`,
  and the static checker requires the exact root and script definitions.
- `make check` passed from the repository root, and
  `make -f /home/gjones/code/private/repos/garethpaul/FabricTwitterBeacons/Makefile check`
  passed from `/tmp`.
- `sh -n scripts/check-baseline.sh` and `git diff --check` passed.
- A hostile mutation restoring `./scripts/check-baseline.sh` was rejected by
  the static contract.
- Implementation head `a6704dedb12dce0dbf8f2fe8bea606337c14613e`
  passed canonical push run `27427657562` and pull-request run `27427659834`
  on the fixed macOS runner.
