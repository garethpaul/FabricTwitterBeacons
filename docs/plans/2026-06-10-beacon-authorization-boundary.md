# Beacon Authorization Boundary

status: completed

## Context

The beacon screen requested always-on location access and immediately started
ranging even when authorization had not been granted. Its behavior is entirely
foreground UI, so the broader permission and eager ranging were unnecessary.

## Objectives

- Request only when-in-use location authorization.
- Start ranging only after authorization is available.
- Stop ranging when the beacon screen is not visible.
- Keep the least-privilege permission and lifecycle behavior in the static
  maintenance baseline.

## Work Completed

- Replaced the always-authorization request with a when-in-use request.
- Deferred initial ranging until authorization is already granted or arrives
  through the location-manager authorization callback.
- Added view lifecycle handling that stops ranging on disappearance and resumes
  it on appearance only for an authorized app.
- Required both authorization and current screen visibility in the location
  manager callback so a late permission response cannot restart off-screen
  ranging.
- Removed always-location usage keys from the app property list.
- Updated the baseline and privacy documentation.

## Verification

- `plutil -lint settee/Info.plist`
- `make check`
- `make lint`
- `make test`
- `make build`
- `git diff --check`
- Hosted `xcodebuild -list -project settee.xcodeproj`
