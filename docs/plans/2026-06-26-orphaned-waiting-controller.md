# Orphaned Waiting Controller Implementation Plan

**Goal:** Remove the unreachable controller that retains obsolete always-on
location and unmanaged beacon-ranging behavior.

**Architecture:** Keep `ViewController` as the sole storyboard-backed beacon
controller. Enforce the deletion through the repository baseline so the stale
alternative flow cannot silently return.

**Tech Stack:** Swift 2-era UIKit source, Xcode project metadata, POSIX shell
baseline checks, Make verification aliases, Markdown maintenance records.

---

## Status: Completed

Completed on 2026-06-26. The orphaned controller was removed without changing
the storyboard or Xcode source phase, which already excluded it.

### Task 1: Add the failing absence contract

- Require the design and implementation records from `scripts/check-baseline.sh`.
- Fail when `settee/WaitingController.swift` exists.
- Run `make check` and record the expected failure against the current tree.

### Task 2: Remove the orphaned source

- Delete `settee/WaitingController.swift`.
- Preserve the storyboard and Xcode project because neither references it.
- Rerun the focused baseline and confirm it passes.

### Task 3: Synchronize repository guidance

- Document that obsolete alternate beacon controllers must not retain broader
  authorization or unmanaged ranging examples.
- Add a complete maintenance-cycle entry to `CHANGES.md`.

### Task 4: Validate and publish

- Run `make check`, `make lint`, `make test`, and `make build`.
- Run shell/Python syntax checks and `git diff --check`.
- Review hosted CI and merge only the exact green head.

## Verification Evidence

- RED: `make check` failed with
  `Orphaned WaitingController.swift must remain absent.` while the file existed.
- The first post-deletion baseline exposed a stale aggregate assertion that
  counted the orphan's nil guard; the contract was narrowed to the active
  `ViewController` callback.
- The first full Make gate then rejected a wrapped changelog marker; the
  wording was made literal so the synchronized-document contract is stable.
- An attempted broad shell-syntax sweep included the vendored Mach-O
  `Fabric.framework/run`; maintained shell validation was narrowed to repository
  scripts and fixtures after confirming the file type.
- `make check`, `make lint`, `make test`, `make build`, and external-directory
  Make invocation passed locally; `swiftc` and `xcodebuild` were unavailable and
  skipped truthfully.
- Maintained shell syntax, isolated Python byte-compilation, and
  `git diff --check` passed.
- Hostile restoration of `WaitingController.swift` and removal of the active
  beacon nil guard were both rejected.
- GREEN: `scripts/check-baseline.sh` passed after the deletion and contract
  correction.
- Hosted verification and exact-head review remain the publication gate.
