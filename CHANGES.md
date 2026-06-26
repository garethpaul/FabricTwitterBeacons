# Changes

## 2026-06-26 14:34 UTC - P1 - publish loaded tweet presentation atomically

### Summary

Successful typed-tweet publication now removes the waiting label and spinner in
the same active main-queue callback instead of waiting for another physical
beacon-ranging event.

### Work completed

- Added one typed-tweet publication helper that replaces table contents and
  hides waiting UI only for non-empty typed results.
- Removed successful-publication cleanup from `didRangeBeacons`.
- Added ordered source contracts, synchronized lifecycle/privacy guidance, and
  an implementation plan.

### Validation

- RED `make check` rejected the missing publication helper.
- GREEN all local Make aliases, shell syntax, project/plist parsing, secret/CI
  fixtures, and `git diff --check` pass.
- Five isolated source mutations were rejected. Swift/Xcode remain hosted-only
  on this runner, and hosted checks are still required.

### Blockers

- Fabric/Twitter authentication and physical beacon timing remain manual-device
  verification boundaries.

### Next action

- Review the exact head and merge only after hosted macOS and CodeQL checks
  pass.

## 2026-06-26 06:08 PDT - P2 - Remove orphaned always-on beacon controller

### Summary

Removed an unreachable legacy controller that still requested always-on
location access and started beacon ranging without screen-lifecycle cleanup.
The active storyboard-backed controller and app target were unchanged.

### Work completed

- Confirmed `settee/WaitingController.swift` had no storyboard, project-file,
  source-phase, or code references.
- Added an accepted design and completed implementation plan.
- Added a fail-closed baseline contract requiring the orphaned `WaitingController`
  to remain absent.
- Deleted the obsolete source and narrowed the active callback nil-guard check
  so it no longer relies on dead code.
- Synchronized README, security, vision, and agent guidance.

### Threads

- Started: None — the reachability audit and deletion were narrow and
  self-contained.
- Continued: None.
- Stopped: None.

### Files changed

- `settee/WaitingController.swift` — removed unreachable always-on location and
  unmanaged ranging code.
- `scripts/check-baseline.sh` — enforces absence and checks the active callback
  directly.
- `README.md`, `SECURITY.md`, `VISION.md`, and `AGENTS.md` — document the sole
  maintained beacon-controller ownership boundary.
- `docs/plans/2026-06-26-orphaned-waiting-controller-design.md` and
  `docs/plans/2026-06-26-orphaned-waiting-controller.md` — record the decision,
  implementation, and validation evidence.

### Validation

- RED `make check` — failed on the newly prohibited orphaned file.
- First GREEN attempt — exposed and recorded a stale aggregate assertion that
  counted the orphan's nil guard.
- First full-gate attempt — caught a wrapped documentation marker; the marker
  was made literal without changing the documented contract.
- An extra shell-syntax sweep initially included `Fabric.framework/run`; file
  inspection confirmed it is a vendored Mach-O executable, so maintained shell
  validation was correctly limited to `scripts/*.sh` and `tests/*.sh`.
- `scripts/check-baseline.sh` — passed after checking the active
  `ViewController` callback directly.
- `make check`, `make lint`, `make test`, `make build`, and external-directory
  `make -f ... check` — passed; unavailable `swiftc` and `xcodebuild` checks
  skipped truthfully.
- Maintained shell syntax, isolated Python byte-compilation, and
  `git diff --check` — passed.
- Hostile orphan restoration and active nil-guard removal mutations — rejected.
- Hosted CI and exact-head review remain pending before merge.

### Bugs / findings

- P2 privacy/maintainability: unreachable source retained broader location
  authorization and unmanaged ranging behavior that conflicted with the active
  safety model and could be accidentally restored to the target.
- P2 test quality: the baseline's nil-guard count depended on the dead
  controller instead of asserting the active callback directly.

### Blockers

- Local `swiftc` and `xcodebuild` availability still determine whether platform
  checks execute; hosted macOS CI remains authoritative when they are absent.

### Next action

- Open the focused PR, run exact-head review and hosted checks, then merge if
  the reviewed head remains green.

## 2026-06-25 18:59 PDT - P2 - Remove manual UIKit lifecycle invocation

### Summary

Removed an unused refresh method that directly invoked UIKit lifecycle
callbacks and could duplicate controller setup if called. Added a fail-closed
source contract and synchronized lifecycle ownership guidance.

### Work completed

- Added an accepted design and implementation plan for framework-owned UIKit
  lifecycle callbacks.
- Observed `make check` fail on the existing `refreshView()` method before
  removing it.
- Removed the unsafe manual `viewDidLoad()` and `viewWillAppear(true)` calls.
- Added static and documentation contracts that direct reset behavior to
  explicit helpers.

### Threads

- Started: None — completed directly because the change was narrow and
  self-contained.
- Continued: None.
- Stopped: None.

### Files changed

- `settee/ViewController.swift` — removed the unused unsafe refresh method.
- `scripts/check-baseline.sh` — rejects manual lifecycle invocation and requires
  synchronized guidance.
- `README.md`, `SECURITY.md`, `VISION.md`, and `AGENTS.md` — document
  framework-owned lifecycle callbacks.
- `docs/manual-beacon-twitter-verification.md` — checks for duplicated setup
  after leaving and returning to the screen.
- `docs/plans/2026-06-25-view-lifecycle-manual-invocation-design.md` and
  `docs/plans/2026-06-25-view-lifecycle-manual-invocation.md` — record the
  decision and implementation steps.
- `CHANGES.md` — records the complete maintenance cycle and validation evidence.

### Validation

- `make check` — passed after the intended pre-fix failure.
- `make lint`, `make test`, and `make build` — passed; `swiftc` and
  `xcodebuild` were unavailable and their platform checks skipped truthfully.
- `python3 -m py_compile scripts/*.py` and shell syntax checks — passed.
- Three isolated hostile source mutations — rejected `func refreshView`,
  `self.viewDidLoad()`, and `self.viewWillAppear(true)`.
- `git diff --check` — passed.
- Hosted macOS Check runs `28212364799` and `28212366285` — passed, including
  production Swift policy compilation, baseline checks, Xcode project parsing,
  and Gitleaks.
- CodeQL run `28212365061` — passed for actions and Python analysis.
- Codex review helper with `codex review --base origin/master` — blocked by
  local OpenAI API authentication (HTTP 401); exact-head manual review removed
  two trailing blank lines and found no remaining actionable findings.

### Bugs / findings

- P2: `refreshView()` modeled UIKit callbacks as ordinary refresh functions,
  which could duplicate setup, authorization, ranging, and animation if used.

### Blockers

- None for the patch. Local `swiftc`, `xcodebuild`, and Codex API authentication
  remain unavailable, with hosted CI and exact-head manual review used instead.

### Next action

- Merge PR #17 after the final documentation-only head passes hosted checks.

## 2026-06-19

- Removed the known Fabric credential values from the maintained PR stack and
  replaced literal checks with fail-closed Gitleaks and SHA-256 fingerprint
  guards. Public history still requires provider-side revocation and activity
  review.
- Rejected scalar search entries, non-canonical or duplicate tweet IDs, and
  stopped parsing after 20 unique IDs before dispatching TwitterKit loads.
- Cleared beacon-scoped tweets when the screen hides so returning users do not
  see stale nearby content before a fresh ranging result.
- Restricted selected Twitter/X URLs to canonical username/status paths and
  added executable policy tests plus hostile mutation coverage.

## 2026-06-16

- Extracted the canonical Twitter/X permalink predicate into app production
  source and added a standalone Swift harness that executes the same policy
  against accepted and hostile URLs when `swiftc` is available.
- Extended the maintained baseline to require app-target membership, navigation
  delegation, harness wiring, and complete URL-case coverage.

## 2026-06-15

- Enforced canonical Twitter and X hosts with no explicit port for in-app tweet
  navigation, rejecting unrelated domains and host lookalikes before web-view
  creation.

## 2026-06-14

- Reserved active beacon generations before Twitter search dispatch to prevent
  duplicate search chains from repeated ranging or refresh events.
- Required HTTP 200 and at most 1 MiB of response data before Twitter search
  JSON parsing.
- Clear stale published tweets and restore waiting UI when close-beacon context
  is lost, without rerunning full controller setup.
- Added a beacon generation token for search, login, load, and in-flight request
  ownership across leave-and-return cycles.

## 2026-06-13

- Ignored queued ranging callbacks after the beacon screen hides so they cannot
  start new Twitter searches.
- Consolidated duplicate `viewWillAppear` overrides while preserving visible-use
  beacon ranging and the navigation-logo animation.
- Publish asynchronous Twitter controller and table state on the main queue,
  retaining stale beacon-context validation before tweet assignment.
- Validated selected tweet permalinks as credential-free HTTPS URLs with a host
  before creating an in-app web request.
- Added a truthful signed-device checklist for beacon authorization, proximity,
  bounded Twitter loading, stale callbacks, permalink navigation, failures,
  cleanup, and redacted evidence; the Linux session did not execute it.

## 2026-06-12

- Made the Makefile verification entry point independent of the caller's
  working directory and added a static contract for the exact path handling.
- Bound asynchronous guest login and tweet loading to a visible, immediately
  close beacon context.
- Discarded callbacks that finish after the screen disappears or proximity
  changes while still clearing the in-flight loading flag.

## 2026-06-10

- Reduced beacon permission to when-in-use access, deferred ranging until
  authorization, and stopped ranging when the beacon screen disappears.
- Added a pinned, read-only `macos-15` GitHub Actions workflow that runs
  `make check` and the hosted Xcode project parse.
- Added stale-run cancellation and a ten-minute job timeout without introducing
  Fabric, Twitter, signing, or beacon credentials.
- Disabled checkout credential persistence so the hosted job does not leave its
  GitHub token available to later steps.
- Extended the baseline checker and docs to require the hosted CI verification
  path.

## 2026-06-09

- Type-checked loaded TwitterKit tweet objects before replacing visible table
  rows, avoiding force-cast crashes and duplicate stale rows.
- Completed Twitter search transport/setup failures with empty results.
- Restored the app `Info.plist` with location usage descriptions for beacon
  ranging and added static baseline coverage for it.
- Replaced raw Twitter error, username, and tweet-ID logs with generic
  diagnostics.
- Added a static baseline guard and plan for the Twitter logging boundary.
- Guarded malformed Twitter search JSON so the search flow completes with an
  empty result instead of force-unwrapping the response.
- Guarded malformed Twitter REST JSON in the legacy helper without
  force-unwrapping the response.
- Guarded beacon-triggered tweet loading against empty IDs and overlapping
  guest load requests.

## 2026-06-08

- Removed beacon proximity logging from the waiting screen and guarded beacon
  ranging callbacks against missing beacon arrays.
- Replaced committed Fabric run-script credentials with local `FABRIC_API_KEY`
  and `FABRIC_BUILD_SECRET` environment variables.
- Added a static `make check` baseline for Fabric credential handling, beacon
  logging, local credential ignores, and project-listing verification when
  Xcode is installed.
- Removed raw beacon payload logging and replaced the unfinished rate-limit
  helper stub.
- Applied the tweet ID limit helper to search results before loading embedded
  tweets.
