# Changes

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
