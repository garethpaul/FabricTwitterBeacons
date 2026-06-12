# AGENTS.md

## Repository purpose

`garethpaul/FabricTwitterBeacons` is an Apple platform application or Objective-C/Swift sample. Tweets based on physical proximity to iBeacons.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `settee.xcodeproj` - Xcode project
- `Fabric.framework` - repository source or sample assets
- `settee` - repository source or sample assets
- `setteeTests` - repository source or sample assets
- `TwitterKit.framework` - repository source or sample assets

## Development commands

- Install dependencies: no repository-specific install command is documented.
- Full baseline: `make check`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- Local Apple development: `open settee.xcodeproj`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: C/C++ headers (21), Swift (12).
- Preserve legacy Xcode project settings and signing assumptions unless the change is explicitly about modernization.

## Testing guidance

- Test-related files detected: `setteeTests/setteeTests.swift`
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- Detected references to Twitter. Keep API keys, OAuth credentials, tokens, and account-specific values in local configuration only.
- Keep `FABRIC_API_KEY`, `FABRIC_BUILD_SECRET`, Twitter credentials, signing identities, and local `.xcconfig` files out of source control.
- Keep the checked-in app `Info.plist` limited to bundle metadata and reviewed privacy usage descriptions; do not add secrets to it.
- Treat iBeacon UUIDs and proximity behavior as sensitive physical-device configuration. Do not log beacon payloads or user proximity transitions without a reviewed need.
- Do not log Twitter usernames, tweet IDs, raw API errors, or account-specific response details from beacon-triggered flows.
- Beacon-triggered tweet loading skips empty search results and suppresses overlapping guest tweet-load requests.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
