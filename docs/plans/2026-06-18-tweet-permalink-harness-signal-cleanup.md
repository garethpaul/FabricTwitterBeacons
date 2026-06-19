---
title: Tweet Permalink Harness Signal Cleanup
type: reliability
date: 2026-06-18
status: completed
execution: code
---

# Tweet Permalink Harness Signal Cleanup

## Status: Completed

## Summary

Make the standalone tweet-permalink policy runner remove its temporary build
directory when interrupted while `swiftc` is still running.

## Baseline

The runner removes its build directory after success and compiler failure, but
its exit-only signal traps leave `tweet-permalink-policy-tests.*` behind after
`TERM` under the repository's POSIX `/bin/sh` execution path.

## Requirements

- Invoke cleanup directly from each signal handler before returning the
  conventional signal-derived status.
- Keep normal exit cleanup and existing compiler/test behavior unchanged.
- Add a mutation-sensitive static contract that rejects exit-only handlers.
- Verify success, compiler failure, and bounded termination with isolated fake
  compilers and temporary directories.

## Verification Plan

- Run `sh -n` on the runner and baseline gate.
- Run all Make gates from the repository and `make check` from an external
  directory.
- Exercise success, compiler-failure, and `TERM` cleanup paths with bounded
  fake compilers.
- Mutate the direct cleanup call and a signal binding and prove the baseline
  rejects both changes.
- Record the implementation commit and exact-head hosted results only after
  they exist.

## Verification Results

- `sh -n` passed for the permalink policy runner and baseline gate.
- Repository `make check`, `make lint`, `make test`, and `make build` passed,
  and external-directory `make check` passed with truthful local skips for
  unavailable `swiftc` and `xcodebuild`.
- Isolated fake-compiler probes covered success, compiler failure status 42,
  and bounded `TERM` cleanup; every temporary audit directory was empty after
  completion.
- Mutations removing direct signal cleanup or restoring the exit-only `TERM`
  binding were rejected by the maintained baseline contract.
- Xcode target membership, executable mode, diff, generated-artifact, and
  high-confidence secret audits passed.
- Implementation commit `284056cd451bc3ef2093c87392bd40d9a8461435`
  passed exact-head push run `27746852183` and pull-request run `27746853979`
  on macOS.
