# Security Policy

## Supported Versions

The supported security scope for `FabricTwitterBeacons` is the current default branch, `master`. Older commits, tags, branches, forks, demos, and generated artifacts are not actively supported unless the repository explicitly marks them as maintained.

Project summary: Tweets based on physical proximity to iBeacons. 

## Reporting a Vulnerability

Please report suspected vulnerabilities through GitHub's private vulnerability reporting or by opening a draft GitHub Security Advisory for `garethpaul/FabricTwitterBeacons` when that option is available. If GitHub does not show a private reporting option for this repository, contact the repository owner through GitHub and avoid posting exploit details publicly until the issue can be assessed.

Do not open a public issue that includes exploit code, secrets, personal data, or detailed reproduction steps for an unpatched vulnerability.

## What to Include

Helpful reports include:

- the affected file, endpoint, permission, dependency, or workflow
- a concise impact statement explaining what an attacker could do
- reproduction steps using test data and accounts you control
- the branch, commit SHA, platform version, device, runtime, or dependency versions used
- logs, screenshots, or proof-of-concept snippets that demonstrate impact without exposing private data

## Project Security Posture

- This repository appears to be an Apple platform application or Swift sample. The active security scope is the code and documentation on the default branch.
- Review found authentication, token, or session-related code paths; changes in those areas should receive security-focused review before merge.
- Review found external API integrations or credential-adjacent configuration; changes in those areas should receive security-focused review before merge.
- Review found network clients, sockets, web APIs, or service endpoints; changes in those areas should receive security-focused review before merge.
- Review found mobile permission or privacy-sensitive data handling; changes in those areas should receive security-focused review before merge.
- Review found file, document, data, or media parsing flows; changes in those areas should receive security-focused review before merge.
- Review found database, model, query, or persistence-related code; changes in those areas should receive security-focused review before merge.
- No primary dependency manifest was detected in the repository root. If dependencies are added later, include a manifest and prefer reproducible installation instructions.
- GitHub Actions runs `make check` and the Xcode project parse on a fixed macOS
  runner with pinned checkout, read-only repository access, no persisted checkout
  credentials, and no Fabric or Twitter credentials.

## Mobile Privacy Notes

If this project requests device permissions such as location, camera, microphone, contacts, Bluetooth, health data, or local storage access, reports should describe the permission involved and whether sensitive data can be accessed, persisted, or transmitted unexpectedly. Please avoid testing against real third-party user data or accounts you do not control.

Beacon ranging should use only when-in-use location authorization, should not
start before authorization is granted, and should stop when its screen is no
longer visible.

The beacon controller should keep visible-use ranging and logo animation in one
`viewWillAppear` override so the lifecycle compiles and both behaviors remain ordered.

Twitter search and legacy REST JSON parsing should fail closed without
force-unwrapping malformed response bodies or logging account-specific details.
Twitter search JSON parsing additionally requires HTTP 200 and at most 1 MiB of
response data before the parser is invoked.

Twitter search transport failures should complete with empty results so
beacon-triggered tweet loading does not wait on a failed request path.

Loaded TwitterKit tweet responses should be type-checked before updating the
visible table so malformed response objects do not crash the beacon-triggered
display path or duplicate stale rows.

Selected tweet permalinks should require credential-free HTTPS URLs with a
hostname before any in-app web request or navigation is created.

Beacon-triggered Twitter callbacks should recheck visible-screen and immediate
proximity context before authentication continues or loaded tweets become
visible.

Each close-range session should carry a beacon generation token through search,
login, and load callbacks so an older leave-and-return cycle cannot publish.
Published tweets are cleared when the close-beacon context is lost so stale
account-derived content does not remain visible outside its ranging context.

Hidden-screen ranging callbacks must not start Twitter search after ranging is
stopped for view disappearance.

Twitter search, login, and load callback state plus visible table publication
should occur on the main queue, with stale beacon context rejected before tweet
assignment.

Runtime beacon/Twitter claims require the signed physical-device checklist in
`docs/manual-beacon-twitter-verification.md`, tester-controlled hardware and
accounts, and redacted evidence. Static checks and hosted project listing do not
prove authorization, ranging, proximity, Twitter, or navigation behavior.

## Dependency and Supply Chain Security

Dependency updates should come from trusted package managers and should keep lockfiles in sync when lockfiles exist. Do not commit credentials, private keys, tokens, generated secrets, or machine-local configuration. If a vulnerability depends on a compromised package, typosquatting risk, insecure transitive dependency, or unsafe build step, include the package name, affected version, and the path through which it is used.

## Safe Research Guidelines

Good-faith research is welcome when it stays within these boundaries:

- use only accounts, devices, data, and infrastructure that you own or have explicit permission to test
- avoid destructive actions, persistence, spam, phishing, social engineering, or denial-of-service testing
- minimize access to personal data and stop testing immediately if private data is exposed
- do not exfiltrate secrets or third-party data; report the minimum evidence needed to verify impact
- keep vulnerability details confidential until the maintainer has assessed the report

## Maintainer Response

The maintainer will review complete reports as availability allows, prioritize issues by exploitability and impact, and coordinate a fix or mitigation when the affected code is still maintained. For sample, archived, or educational repositories, the likely remediation may be documentation, dependency updates, or clearly marking unsupported code rather than a production-style patch release.
