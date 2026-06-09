---
title: Location Usage Plist
date: 2026-06-09
status: completed
execution: code
---

## Context

The Xcode target references `settee/Info.plist`, but the app plist was ignored
and absent from the working tree. The app requests always-on location
authorization for iBeacon ranging, so the checked-in app bundle metadata needs
reviewed location usage descriptions. Without the plist, local builds depend on
untracked state and privacy copy can drift.

## Goals

- Restore the app `Info.plist` referenced by the Xcode project.
- Include location usage descriptions for beacon ranging.
- Keep local credentials and per-machine Xcode files ignored while allowing the
  app plist to be tracked.
- Extend the static baseline so the plist and privacy strings remain present.

## Implementation

- Added a minimal `settee/Info.plist` with bundle metadata, storyboard entries,
  and location usage descriptions for beacon proximity.
- Updated `.gitignore` to explicitly allow the app plist while keeping local
  credential patterns ignored.
- Extended `scripts/check-baseline.sh` to require the plist, project reference,
  location keys, and completed plan.
- Updated README, VISION, and CHANGES with the new build/privacy guardrail.

## Verification

- `scripts/check-baseline.sh`
- `make check`
- `git diff --check`

Full Xcode build and simulator verification are still skipped locally because
XcodeBuildMCP and `xcodebuild` are not installed in this environment.
