# View Lifecycle Manual Invocation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Remove the unused refresh path that manually invokes UIKit lifecycle callbacks and prevent its reintroduction.

**Architecture:** Keep UIKit as the sole lifecycle callback owner. Preserve explicit controller helpers for presentation reset and existing `viewWillAppear` ownership for ranging and animation.

**Tech Stack:** Swift 2-era UIKit source, POSIX shell baseline checks, Make verification aliases, Markdown maintenance documentation.

---

## Status: Completed

Completed on 2026-06-25. The source fix was reviewed at commit
`e5b8c17e6bbd84558c3412ae87684f9e35e14fd7`. Hosted macOS Check runs
`28212364799` and `28212366285` passed, and CodeQL run `28212365061` passed for
actions and Python. The local Codex review helper selected
`codex review --base origin/master` but could not authenticate to the OpenAI API
(HTTP 401); exact-head manual review found and removed two trailing blank lines,
then reported no remaining actionable findings.

### Task 1: Add the failing regression contract

- Require this design and implementation record from `scripts/check-baseline.sh`.
- Reject `func refreshView`, `self.viewDidLoad()`, and
  `self.viewWillAppear(true)` in `settee/ViewController.swift`.
- Run `make check` and record the expected failure against the current source.

### Task 2: Remove the unsafe method

- Delete the unused `refreshView()` implementation.
- Preserve the framework-owned lifecycle overrides and explicit reset helper.
- Run the narrow baseline again and confirm it passes.

### Task 3: Synchronize repository guidance

- Document that UIKit lifecycle callbacks are framework-owned.
- Direct refresh/reset work to explicit helpers rather than lifecycle methods.
- Add a complete maintenance-cycle record to `CHANGES.md`.

### Task 4: Validate and publish

- Run `make check`, `make lint`, `make test`, and `make build`.
- Review the exact diff and hosted CI result.
- Push a focused PR and merge only after review and green checks.

## Verification Evidence

- `make check`, `make lint`, `make test`, and `make build` passed locally;
  `swiftc` and `xcodebuild` were unavailable and skipped truthfully.
- Python byte-compilation, shell syntax checks, and `git diff --check` passed.
- Three isolated hostile mutations for the removed method and direct lifecycle
  calls were rejected.
- Hosted macOS Check compiled the executable Swift policies, ran the baseline
  and fixture suites, parsed the Xcode project, and found no Gitleaks findings.
- CodeQL passed for the repository's actions and Python analysis surfaces.
