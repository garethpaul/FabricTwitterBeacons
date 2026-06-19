# Beacon And Twitter Physical-Device Verification

Use this checklist before claiming that beacon authorization, ranging,
proximity-triggered Twitter loading, stale-result suppression, or tweet
navigation works at runtime.

## Status And Evidence Boundary

This checklist is defined but was not executed during the Linux maintenance
session that added it. Record a separate result for the exact tested commit.
Static Linux checks and hosted Xcode project listing do not satisfy this
physical-device run. Do not convert `make check`, `xcodebuild -list`, or a green hosted job into
evidence that the app built, signed, ranged a beacon, authenticated to Twitter,
loaded tweets, or navigated a permalink.

Use only hardware, accounts, credentials, beacon configuration, and test content
owned by the tester or explicitly authorized for testing. Never attach raw
beacon observations, Twitter credentials, account identifiers, tweet IDs,
private tweets, request/response bodies, signing material, or unredacted logs.

## Prerequisites

- A compatible macOS and Xcode version that can compile this legacy Swift,
  Fabric, and TwitterKit project, plus valid local signing.
- A physical iOS device with Bluetooth and Location Services enabled; a
  simulator is not sufficient for beacon ranging.
- A controlled test beacon configured for the sample region and owned by the
  tester. Record a redacted configuration label, not its UUID/major/minor values.
- A tester-controlled Twitter account and locally supplied legacy credentials,
  if the retired guest authentication and search APIs remain available.
- Prefer an authorized fixture build with controlled public test tweets. The
  checked-in fixed hashtag search may surface third-party public content; do not
  copy, screenshot, publish, or retain that content as test evidence.
- A clean checkout at the exact commit with no `.env`, `.xcconfig`, signing,
  credential, captured tweet, or runtime-log file staged for commit.

## Authorization And Screen Lifecycle

1. Build and run the app on the physical device from `settee.xcodeproj`.
2. On a fresh permission state, confirm the app requests only when-in-use
   location authorization and does not request always-on location access.
3. Deny location access. Confirm ranging does not start, no Twitter load begins,
   and the app remains responsive without logging beacon or account details.
4. Grant when-in-use access while the beacon screen is visible. Confirm ranging
   starts only after authorization.
5. Navigate away or background/hide the beacon screen. Confirm ranging stops and
   no hidden-screen callback starts or displays Twitter results.
6. Return to the visible beacon screen while still authorized. Confirm ranging
   resumes without another permission escalation.

## Proximity And Tweet Loading

1. Begin with no detected beacon or `unknown` proximity. Confirm no tweet load
   occurs and no raw beacon payload or proximity transition is logged.
2. Move through far and near states. Confirm no Twitter guest load begins before
   the controlled beacon reaches immediate proximity.
3. Enter immediate proximity. Confirm one bounded search/load begins and the
   visible table is replaced only with successfully loaded TwitterKit tweets.
4. Keep the device at immediate proximity across repeated ranging callbacks.
   Confirm overlapping guest/tweet loads do not start.
5. Move from immediate to near proximity after rows are visible. Confirm stale
   tweet rows clear and the waiting state returns. For far, unknown, or missing
   beacon transitions, confirm no new load starts and record any retained-row
   behavior as an observed limitation rather than claiming it was cleared.
6. Repeat with an empty or malformed search result where the controlled test
   setup permits it. Confirm no tweet load starts and the app remains usable.

## Stale Async Results

1. Start a controlled immediate-proximity load, then leave immediate proximity
   before guest authentication or tweet loading completes.
2. Confirm the late callback does not repopulate the table and a later valid
   immediate-proximity transition can start a new load.
3. Repeat by hiding or leaving the beacon screen before completion. Confirm the
   hidden screen remains empty and no navigation or extra load begins.
4. Record only pass/fail timing observations; do not capture raw responses,
   tweet identifiers, account names, beacon identifiers, or error objects.

## Permalink Navigation

1. Select a controlled loaded tweet with a credential-free HTTPS permalink on
   canonical Twitter and X hosts with no explicit port and a non-empty hostname.
   Confirm exactly one in-app web view is pushed.
2. Use a controlled invalid, non-HTTPS, hostless, or credential-bearing test URL,
   plus explicit-port, unrelated-host, subdomain, and suffix-lookalike URLs, only
   through an authorized test fixture/build. Confirm no request is loaded, no
   web view is pushed, and the rejected URL or tweet details are not logged.
3. Return to the beacon screen and confirm navigation does not broaden location
   authorization or trigger an overlapping Twitter load.

## Failure And Privacy Checks

- Exercise unavailable/invalid guest authentication with tester-owned local
  configuration. Confirm the failure is generic and contains no account,
  credential, token, or raw error details.
- Exercise controlled search and tweet-load failures where the legacy service
  permits it. Confirm empty/no replacement results and generic diagnostics.
- Confirm runtime logs contain no beacon UUID/major/minor values, proximity
  history, Twitter usernames, tweet IDs/text, permalink values, response bodies,
  credentials, tokens, signing identities, or raw API errors.
- If retired Fabric/TwitterKit services cannot authenticate or search, record the
  exact compatibility/service blocker. Do not mark dependent steps passed.

## Cleanup And Evidence Record

Remove local credentials, `.env`/`.xcconfig` values, signing exports, captured
traffic, screenshots, logs, and controlled test content after the run. Rotate a
credential immediately if it appears in any capture or transcript.

Record the commit SHA, macOS/Xcode/iOS versions, physical device model, whether
build/signing succeeded, redacted beacon ownership/configuration label, Twitter
test-account ownership, service availability, and pass/fail/blocked result for
every checklist item. Evidence must be scrubbed of beacon identifiers, physical
location, account/tweet identifiers or content, URLs, credentials, device IDs,
and signing details.

Keep static evidence separate: `make check` and hosted Xcode project listing
prove source/project contracts only, not physical-device authorization, beacon
ranging, proximity transitions, Twitter service behavior, or navigation.
