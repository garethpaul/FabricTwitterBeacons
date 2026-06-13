---
title: Tweet Permalink Validation
type: security
status: completed
date: 2026-06-13
---

# Tweet Permalink Validation

## Summary

Validate TwitterKit tweet permalinks before loading them in the in-app web view
so malformed, non-HTTPS, hostless, or credential-bearing URLs fail closed.

## Priority

1. Prevent loaded tweet objects from initiating unsafe external navigation.
2. Keep rejection logs generic and free of tweet, account, or URL details.
3. Preserve beacon ranging, tweet loading, table rendering, and valid HTTPS
   permalink behavior.

## Requirements

- R1. Tweet navigation must accept only HTTPS URLs with a non-empty hostname.
- R2. URLs containing username or password userinfo must be rejected.
- R3. Invalid permalinks must not create a request, web view, or navigation push.
- R4. Rejection logging must not include the URL, tweet ID, username, or raw
  TwitterKit object details.
- R5. Static source and ordering contracts must prove validation occurs before
  `NSURLRequest` and `UIWebView.loadRequest`.
- R6. Existing visible-screen beacon context, stale-result guards, typed tweet
  loading, and generic Twitter failure logs must remain unchanged.

## Non-Goals

- Replacing deprecated `UIWebView` or retired TwitterKit/Fabric dependencies.
- Adding universal links, an external browser, or authentication flows.
- Changing which tweets are searched, loaded, or displayed.
- Claiming physical-device navigation without Xcode, signing, Twitter service
  access, and a controlled test account.

## Implementation Units

### 1. Permalink Boundary

Files: `settee/ViewController.swift`

- Add a focused optional `NSURL` validator.
- Require HTTPS, a hostname, and no username/password userinfo.
- Guard the selection handler before constructing the request or web view.

### 2. Static Security Contract

Files: `scripts/check-baseline.sh`

- Require each URL validation condition and the generic rejection message.
- Prove the guard precedes request creation and web-view navigation.
- Require completed verification evidence and updated security guidance.

### 3. Project Guidance

Files: `README.md`, `SECURITY.md`, `VISION.md`, `CHANGES.md`

- Document fail-closed tweet permalink navigation and device-test limits.

## Verification Plan

- Run `make check`, `make lint`, `make test`, and `make build`.
- Remove the scheme check, remove the userinfo check, and bypass the guard; the
  static gate must reject each mutation.
- Run shell syntax, plist parsing, `git diff --check`, and intended-file secret
  scans.
- Take one bounded exact-head macOS and CodeQL snapshot after push; do not poll.

## Verification

- A copied Linux baseline passed with local `xcodebuild` explicitly unavailable.
- Replacing the HTTPS requirement produced the expected `scheme mutation failed` result.
- Removing username/password rejection produced the expected `userinfo mutation failed` result.
- Loading `tweet.permalink` directly produced the expected `guard bypass mutation failed` result.
- The rooted full gate, shell syntax, plist parsing, diff check, and intended-file
  secret scan passed.
- The exact pushed head still requires the bounded hosted macOS check and CodeQL
  snapshot because Swift compilation and TwitterKit navigation cannot run here.

## Work Completed

- Added an optional permalink validator requiring HTTPS, a hostname, and no
  username/password userinfo.
- Guarded tweet selection before web-view, request, or navigation creation.
- Added exact source and ordering contracts plus generic rejection logging.
- Updated project security, privacy, maintenance, and change guidance.
