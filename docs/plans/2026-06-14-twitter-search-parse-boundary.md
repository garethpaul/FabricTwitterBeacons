---
title: Twitter Search Parse Boundary
type: security
status: completed
date: 2026-06-14
---

# Twitter Search Parse Boundary

## Summary

Reject Twitter search responses unless they are HTTP 200 with a present body no
larger than 1 MiB. This keeps error pages and oversized payloads out of the
legacy JSON parser while preserving the existing empty-result failure contract.

## Prioritized Engineering Tasks

1. Add a pure response acceptance helper for HTTP status and body size.
2. Apply the helper before allocating result containers or parsing JSON.
3. Add a focused source-order and boundary matrix contract.
4. Synchronize operational and security guidance with the parse boundary.

## Requirements

- R1. Only HTTP 200 responses may reach Twitter search JSON parsing.
- R2. Missing bodies and bodies larger than 1 MiB must fail closed.
- R3. Rejected responses must complete with an empty result and generic logging.
- R4. Existing transport, malformed JSON, result-limit, and beacon-generation
  behavior must remain unchanged.
- R5. Static contracts must prove guard ordering and boundary values.

## Non-Goals

- Replacing retired Fabric or TwitterKit dependencies.
- Streaming or cancelling response downloads inside the vendor API client.
- Changing the search query, result count, or beacon behavior.
- Claiming live Twitter or signed-device validation from Linux.

## Verification

- The focused boundary contract passed for HTTP 200 bodies at zero and exactly
  1 MiB and rejected missing status/body, non-200 statuses, and 1 MiB plus one
  byte.
- Six hostile mutations were rejected across the byte limit, HTTP status,
  present-body guard, callback use, pre-parse ordering, and completed-plan
  evidence.
- `make check`, `make lint`, `make test`, and `make build` passed the portable
  maintenance baseline from the repository root and `make check` passed through
  the absolute Makefile path from an external working directory.
- Local Xcode compilation, simulator execution, physical beacon ranging, and
  live Twitter requests were not run because this host is Linux and has no
  configured Apple toolchain, signing identity, or service credentials.
- Exact intended-path, generated-artifact, whitespace, conflict-marker,
  project-file preservation, and changed-line credential-pattern audits passed.
