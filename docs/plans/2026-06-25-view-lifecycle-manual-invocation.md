# View Lifecycle Manual Invocation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** Remove the unused refresh path that manually invokes UIKit lifecycle callbacks and prevent its reintroduction.

**Architecture:** Keep UIKit as the sole lifecycle callback owner. Preserve explicit controller helpers for presentation reset and existing `viewWillAppear` ownership for ranging and animation.

**Tech Stack:** Swift 2-era UIKit source, POSIX shell baseline checks, Make verification aliases, Markdown maintenance documentation.

---

## Status: In Progress

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

