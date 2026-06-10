## Fabric Twitter Beacons Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

Fabric Twitter Beacons is an iOS sample that combines iBeacon proximity with
TwitterKit/Fabric API calls.

The repository is useful as a historical mobile sample for location/proximity
events, Twitter REST integration, and early Fabric setup. Setup notes live in
[`README.md`](README.md).

The goal is to preserve the sample while making beacon identity, Twitter
credentials, and proximity-triggered behavior explicit.

The current focus is:

Priority:

- Keep iBeacon UUID/configuration assumptions visible
- Preserve the Twitter/Fabric integration flow
- Avoid committing Fabric, Twitter, or signing credentials
- Keep physical-device requirements documented
- Keep GitHub Actions aligned with the local `make check` baseline

Current baseline:

- `scripts/check-baseline.sh` verifies that the Fabric run script reads
  `FABRIC_API_KEY` and `FABRIC_BUILD_SECRET` from the local environment instead
  of committed identifiers.
- Raw beacon payloads are not logged from the app delegate.
- The app `Info.plist` is tracked with reviewed location usage descriptions for
  beacon ranging.
- Twitter diagnostics avoid usernames, tweet IDs, and raw client error details.
- Malformed Twitter search JSON completes with an empty result instead of
  force-unwrapping the response body.
- Twitter search transport failures complete with empty results so
  beacon-triggered callers can skip tweet loading consistently.
- Malformed Twitter REST JSON fails closed without force-unwrapping the legacy
  helper response body.
- Beacon-triggered tweet loading skips empty search results and prevents
  overlapping guest tweet-load requests.
- Loaded TwitterKit tweet responses are type-checked before replacing the
  visible table contents, avoiding force-cast crashes and duplicate stale rows.
- Local `.env` and `.xcconfig` files stay ignored because they may contain
  Fabric, Twitter, signing, or beacon configuration.
- Xcode project listing is attempted when `xcodebuild` is installed; otherwise
  static checks remain the minimum verification path.
- GitHub Actions runs the local baseline and Xcode project parse on a fixed
  macOS runner for pushes, pull requests, and manual dispatches.

Next priorities:

- Add clearer README verification steps for beacon and Twitter behavior
- Move beacon and Twitter configuration into documented local settings
- Modernize Fabric/Twitter dependencies only in a dedicated pass
- Add tests or manual checklists around rate limits and proximity handling

Contribution rules:

- One PR = one focused beacon, Twitter, build, or documentation change.
- Verify beacon behavior on physical hardware when changing proximity logic.
- Keep credentials out of `Info.plist` and source control.
- Do not add automatic posting behavior without explicit user confirmation.
- Keep `.github/workflows/check.yml` in sync with the local maintenance and
  Xcode project-parse baseline.

## Security And Privacy

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Beacon proximity and Twitter identity are sensitive. Changes should avoid
logging device location, beacon IDs, user tokens, or account details.

Any tweet or API action should remain explicit and user-controlled.

## What We Will Not Merge (For Now)

- Hardcoded real Twitter, Fabric, or beacon credentials
- Silent tweeting or account actions
- Background proximity tracking without privacy notes
- Dependency migrations bundled with behavior changes

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
