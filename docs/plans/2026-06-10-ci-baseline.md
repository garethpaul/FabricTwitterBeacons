# CI Baseline

status: completed

## Context

The repository had a local static `make check` baseline for the legacy
Fabric/Twitter beacon sample, but no hosted workflow ran it for pushes and pull
requests.

## Changes

- Added a GitHub Actions workflow on the supported `macos-15` runner that runs
  `make check` and its conditional `xcodebuild -list` project parse.
- Pinned checkout by commit, disabled checkout credential persistence, granted
  read-only repository access, enabled stale-run cancellation, and limited the
  job to ten minutes.
- Kept hosted checks offline and free of Fabric, Twitter, signing, or beacon
  credentials.
- Extended the baseline script and documentation so the hosted CI path stays
  visible and covered by the local guard.

## Verification

- `make check`
- Hosted macOS `xcodebuild -list` through `make check`
