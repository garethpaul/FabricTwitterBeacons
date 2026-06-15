---
title: Twitter Permalink Host Boundary
type: security
date: 2026-06-15
status: pending
execution: code
---

# Twitter Permalink Host Boundary

## Summary

Restrict in-app tweet navigation to canonical Twitter and X permalink hosts.
The existing validator requires HTTPS, no URL user information, and a present
host, but it still accepts unrelated HTTPS domains and non-default ports from a
malformed or compromised tweet model.

## Prioritized Engineering Tasks

1. Add a small pure helper that recognizes only exact canonical permalink
   hosts.
2. Reject non-default ports before returning a navigation URL.
3. Add a focused static boundary matrix for canonical hosts, lookalikes,
   unrelated domains, and explicit ports.
4. Keep project security and device-verification guidance synchronized with the
   navigation boundary.

## Requirements

- R1. Tweet navigation may accept only HTTPS URLs on `twitter.com`,
  `www.twitter.com`, `x.com`, or `www.x.com`.
- R2. Host matching must be case-insensitive and exact; suffix, prefix, and
  subdomain lookalikes must fail closed.
- R3. URLs with user information or an explicit port must fail closed.
- R4. Validation must complete before `UIWebView` construction, request
  loading, or navigation-controller publication.
- R5. Existing beacon generation, Twitter search, tweet loading, and valid
  permalink behavior must remain unchanged.
- R6. The maintained gate must reject removal or weakening of the host and port
  checks, loss of representative boundary cases, and incomplete plan evidence.

## Non-Goals

- Replacing the retired Fabric, TwitterKit, or `UIWebView` dependencies.
- Changing the tweet search query, result limits, beacon behavior, or table UI.
- Claiming Xcode, simulator, physical-device, Fabric, or live Twitter behavior
  from Linux validation.

## Verification

- Pending implementation and focused static boundary validation.
- Pending hostile mutation checks for host allowlisting, exact matching,
  explicit-port rejection, pre-navigation ordering, documentation, and plan
  completion evidence.
- Pending repository and external-directory `make check` validation.
- Pending exact intended-path, generated-artifact, project-file, whitespace,
  conflict-marker, and changed-line credential-pattern audits.
