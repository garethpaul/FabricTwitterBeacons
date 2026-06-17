---
title: Execute the production tweet permalink policy
type: testing
date: 2026-06-16
status: completed
execution: code
---

# Execute the production tweet permalink policy

## Goal

Compile and execute the deterministic tweet-permalink decision used by the app
without requiring Fabric, TwitterKit, credentials, a simulator, or a beacon.

## Requirements

- Keep one Foundation-only permalink policy in app production source and the
  Xcode app target.
- Preserve the existing pre-navigation validator call and legacy public helper
  signatures.
- Compile the production policy with a standalone Swift harness from every Make
  gate when `swiftc` is available.
- Accept the four canonical Twitter/X hosts case-insensitively and reject a
  missing URL, non-HTTPS schemes, userinfo, passwords, ports, unlisted
  subdomains, host prefixes/suffixes, unrelated hosts, and hostless URLs.
- Keep the template XCTest target explicitly excluded from behavioral evidence.

## Work Completed

- Extracted `TweetPermalinkPolicy.swift` and added it to the Xcode app target.
- Added a standalone Swift harness and bounded temporary-build runner.
- Wired all Make aliases to execute the harness before the static baseline.
- Retargeted the independent Python oracle to production policy and added
  contracts for app delegation, target membership, runner wiring, test cases,
  documentation, and completed evidence.

## Verification Completed

- all four Make gates passed from the repository root.
- The absolute Makefile path passed from an external directory.
- The production policy mutation failed after weakening a host constraint.
- The navigation delegation mutation failed after bypassing the validator.
- The Xcode target membership mutation failed after removing the policy source.
- The accepted URL mutation failed after removing a canonical case.
- The hostile URL mutation failed after removing a rejected case.
- The plan evidence mutation failed after removing completed verification text.
- Shell syntax, project references, executable modes, diff checks, artifact
  scans, and changed-line credential-pattern scans passed.
- `swiftc` and Xcode are unavailable on this Linux host, so local gates verify
  deterministic source wiring and defer Swift execution to hosted macOS.
- The implementation was committed as
  `6b62a4e33010c9f64ae99e7ddfb938d266200347`.
- Canonical hosted verification passed on that exact implementation head:
  push run `27643147108` and pull-request run `27643148489` both completed
  successfully on macOS. PR #13 remained open, clean, and mergeable, and the
  branch had no open code-scanning alerts.
