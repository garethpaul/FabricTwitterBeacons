---
title: Physical-Device Beacon And Twitter Verification
type: verification
status: planned
date: 2026-06-13
---

# Physical-Device Beacon And Twitter Verification

## Summary

Define a repeatable physical-device checklist for the beacon authorization,
proximity, Twitter loading, stale-result, permalink, privacy, and failure paths.
Keep static Linux checks and hosted Xcode project parsing separate from runtime
evidence for the retired Fabric/TwitterKit stack.

---

## Problem Frame

The repository has strong static contracts but only template XCTest coverage.
Its remaining functional risk lives at boundaries that require compatible Xcode,
signing, a physical iOS device, a controlled iBeacon, and working legacy Twitter
credentials. Reviewers need an exact checklist and evidence format before making
runtime claims about authorization, proximity transitions, network results, or
tweet navigation.

---

## Requirements

- R1. Require a compatible macOS/Xcode toolchain, valid local signing, a
  physical iOS device, and a controlled test beacon using the configured UUID.
- R2. Verify only when-in-use location authorization, including denied,
  authorized, view-visible, and view-hidden ranging behavior.
- R3. Verify unknown/far/near/immediate transitions, immediate-only tweet loads,
  stale row clearing, and no overlapping load when ranging callbacks repeat.
- R4. Verify bounded Twitter search/load behavior with controlled test content,
  generic login/search/load failures, malformed/empty results, and no account,
  tweet, beacon payload, URL, or raw error details in logs.
- R5. Verify that leaving immediate proximity or hiding the screen before async
  completion cannot repopulate stale tweets.
- R6. Verify selected tweets navigate only to credential-free HTTPS permalinks
  with a hostname; invalid links must not push a web view or expose link details.
- R7. Record commit, toolchain/device versions, beacon ownership/configuration,
  credential ownership, test-account/content provenance, per-step results, and
  redacted evidence without committing secrets or physical identifiers.
- R8. State explicitly that the checklist is defined but unexecuted in this
  Linux maintenance session and that hosted project parsing is not runtime proof.
- R9. Enforce the checklist sections, critical assertions, completed local
  verification evidence, and roadmap update in the maintenance gate.

---

## Key Technical Decisions

- K1. Keep this pass documentation-and-contract only; do not modify retired
  Swift, Fabric, TwitterKit, beacon configuration, signing, or CI behavior.
- K2. Use section-scoped assertions with normalized Markdown whitespace so an
  unrelated phrase elsewhere cannot mask checklist drift.
- K3. Require tester-controlled hardware, accounts, and content. Never use or
  preserve production credentials, private tweet data, or beacon observations.
- K4. Treat static checks, Xcode project parsing, and physical-device execution
  as separate evidence classes.

---

## Scope Boundaries

### In Scope

- A reusable manual checklist and redacted evidence template.
- Maintenance contracts for prerequisites, authorization, proximity, Twitter,
  stale results, navigation, privacy/failure behavior, and evidence limitations.
- Contributor, security, roadmap, maintenance, and change guidance updates.

### Deferred to Follow-Up Work

- Executable beacon/Twitter integration tests after dependency modernization.
- Replacing UIWebView, Fabric, TwitterKit, or legacy Swift APIs.
- Moving the checked-in sample beacon UUID into local configuration.

### Non-Goals

- Claiming a device run from Linux or hosted `xcodebuild -list` evidence.
- Adding live credentials, test accounts, beacon identifiers, signing artifacts,
  captured tweets, screenshots, request bodies, or runtime logs to git.
- Calling Twitter, ranging a beacon, signing, building, or launching the app in
  this implementation session.

---

## Implementation Units

### U1. Device Verification Checklist

**Goal:** Define the exact physical-device flow and redacted evidence record.

**Requirements:** R1-R8

**Dependencies:** None

**Files:** `docs/manual-beacon-twitter-verification.md`

**Approach:** Organize prerequisites, authorization/lifecycle, proximity/load,
stale-result, permalink, failure/privacy, cleanup, and evidence sections around
the existing source contracts. Keep unexecuted status prominent.

**Patterns to follow:** `docs/plans/2026-06-12-stale-beacon-tweet-results.md`,
`docs/plans/2026-06-13-tweet-permalink-validation.md`

**Test scenarios:**

- Authorized visible screen starts ranging; hiding the screen stops it.
- Denied authorization never ranges or loads Twitter content.
- Immediate proximity loads bounded results; far/unknown state clears rows.
- Repeated immediate callbacks do not create overlapping guest loads.
- Leaving proximity or hiding the screen before completion leaves rows empty.
- Login, search, load, empty/malformed result, and invalid permalink failures
  remain generic and disclose no account, tweet, beacon, URL, or raw error data.
- A valid credential-free HTTPS permalink navigates; an invalid link does not.

**Verification:** Every requirement appears in the intended checklist section,
and no step claims execution without separately recorded device evidence.

### U2. Section-Scoped Maintenance Contract

**Goal:** Make checklist and evidence drift fail the maintained baseline.

**Requirements:** R9

**Dependencies:** U1

**Files:** `scripts/check-baseline.sh`,
`docs/plans/2026-06-13-device-beacon-twitter-verification.md`

**Approach:** Add required-file and section-aware phrase checks, completed-plan
evidence checks, and project-guidance contracts. Preserve every existing source,
privacy, CI, stale-result, and permalink assertion.

**Execution note:** Validate in an isolated copy before marking the real plan
completed, then apply hostile mutations to each high-risk checklist boundary.

**Test scenarios:**

- Removing the physical-device requirement fails.
- Weakening when-in-use, visible-screen, immediate-only, stale-result, bounded
  load, privacy-log, HTTPS permalink, redaction, or evidence-limit language fails.
- Restoring the completed roadmap item or planned status fails.

**Verification:** The unchanged repository passes all maintained Make targets;
each isolated hostile mutation fails for its intended contract.

### U3. Project Guidance

**Goal:** Make the checklist discoverable without overstating runtime coverage.

**Requirements:** R7-R9

**Dependencies:** U1, U2

**Files:** `README.md`, `AGENTS.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

**Approach:** Link the checklist, state the remaining device evidence, preserve
secret/privacy boundaries, and replace the completed manual-checklist roadmap
item with executable testing after dependency modernization.

**Test expectation:** No runtime behavior changes; documentation contracts and
exact-path review provide coverage.

**Verification:** All current guidance consistently distinguishes static,
hosted-project, and physical-device evidence.

---

## Risks And Dependencies

- Current Xcode may not compile the retired Swift/Fabric/TwitterKit project.
- Legacy Twitter guest authentication or APIs may no longer function even with
  locally controlled credentials.
- Beacon ranging requires compatible hardware, Bluetooth/location state, and a
  correctly configured controlled beacon.
- Manual evidence can expose physical presence, account data, tweets, beacon
  identifiers, or credentials unless it is carefully redacted and cleaned up.

---

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build` on Linux with the
  expected explicit `xcodebuild` skip.
- Parse both app and test plists and run shell syntax and diff checks.
- Apply isolated hostile mutations to device prerequisites, authorization,
  visible-screen ranging, immediate-only loading, stale completion, bounded
  results, generic logs, permalink rules, evidence redaction/limits, roadmap,
  and plan status.
- Inspect exact intended paths, unchanged source/project/framework/workflow
  files, credential-like additions, signing artifacts, and generated artifacts.
- Push normally, open a stacked PR on the green permalink branch, and take one
  bounded exact-head macOS/CodeQL snapshot without a polling loop.
