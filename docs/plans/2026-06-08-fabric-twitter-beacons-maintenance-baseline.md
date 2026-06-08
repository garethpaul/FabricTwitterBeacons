# Fabric Twitter Beacons Maintenance Baseline

date: 2026-06-08
status: completed

## Context

Fabric Twitter Beacons is a legacy iOS sample that connects iBeacon proximity
events with TwitterKit/Fabric API calls. The main maintenance risks are
credential leakage, privacy-sensitive beacon logging, and unclear verification
steps for a toolchain that may require old Xcode and SDK versions.

## Completed Scope

- Replaced committed Fabric run-script identifiers with local
  `FABRIC_API_KEY` and `FABRIC_BUILD_SECRET` environment variables.
- Removed raw beacon payload logging from the app delegate.
- Added `scripts/check-baseline.sh` and `make check` for repeatable static
  verification without requiring Twitter, Fabric, or beacon hardware.
- Documented local credential handling, physical-device verification, and
  historical dependency constraints.
- Ignored local environment and Xcode configuration files that may contain
  credentials.

## Verification

- `make check`

## Follow-Ups

- Verify beacon behavior on a physical iOS device with local Fabric/Twitter
  credentials configured outside source control.
- Decide whether vendored Fabric/TwitterKit frameworks should remain archived
  with the sample or move to a documented artifact boundary.
- Modernize the Swift and Fabric/Twitter dependencies only in a dedicated pass.
