# AGENTS.md

## Repository purpose

`garethpaul/FabricTwitterBeacons` is a legacy Swift iOS sample that ranges a configured iBeacon while its screen is visible and loads nearby Twitter search results through the retired Fabric/TwitterKit stack.

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

- `setteeTests/setteeTests.swift` contains only template assertions; do not treat it as meaningful beacon, Twitter, privacy, or lifecycle coverage. The maintained regression gate is `make check`.
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
- Request only when-in-use location authorization, start ranging only after authorization while the beacon screen is visible, and stop ranging when authorization is absent or the screen disappears.
- Treat iBeacon UUIDs and proximity behavior as sensitive physical-device configuration. Do not log beacon payloads or user proximity transitions without a reviewed need.
- Do not log Twitter usernames, tweet IDs, raw API errors, or account-specific response details from beacon-triggered flows.
- Beacon-triggered tweet loading must limit result IDs, skip empty searches, suppress overlapping guest loads, complete failures with empty results, fail closed on malformed JSON, and type-check loaded TwitterKit objects before replacing visible rows.
- Hosted macOS CI proves the Xcode project parses and the static contracts pass; it does not prove signing, Fabric/Twitter authentication, beacon ranging, or physical-device behavior.
- Use `docs/manual-beacon-twitter-verification.md` for physical-device verification. Preserve its when-in-use authorization, visible-screen ranging, immediate-only loading, stale-result, bounded load, permalink, privacy, cleanup, redacted-evidence, and unexecuted-status boundaries.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
