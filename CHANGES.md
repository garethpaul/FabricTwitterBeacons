# Changes

## 2026-06-10

- Reduced beacon permission to when-in-use access, deferred ranging until
  authorization, and stopped ranging when the beacon screen disappears.
- Added a pinned, read-only `macos-15` GitHub Actions workflow that runs
  `make check` and the hosted Xcode project parse.
- Added stale-run cancellation and a ten-minute job timeout without introducing
  Fabric, Twitter, signing, or beacon credentials.
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
