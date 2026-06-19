# Fabric credential default remediation

Status: Ready for independent security pull request

## Scope

Create one security pull request directly from the guarded `master` commit
`8eff8686df683f2c79560185fe48e5bb2062def3`. The pull request removes the two
historical Fabric credential values from the current default tree, retains only
non-reversible fingerprints, and adds fail-closed contextual, fragment, binary,
and missing-tool checks.

This forward-only repair does not rewrite public history, authenticate with the
values, or prove rotation, revocation, expiry, or non-reuse. Manual rotation or
revocation remains urgent.

## Landing order

1. Review and merge the independent default-based security pull request before
   any stack propagation.
2. After it lands, merge the resulting default-branch security commit into the
   existing stack in order: PR #1, then PRs #3 through #13.
3. Use merge commits only. Do not rebase, force-push, recreate, or delete any
   existing stack branch.
4. At every edge, verify that the merge contains the exact landed security
   commit and that the branch's pre-existing application patch remains intact.
5. Run `./tests/test-secret-guard.sh`, `make check`, and hosted checks on every
   propagated head before continuing to the next branch.

## Safety guards

- Stop if the default branch or any PR head differs from the reviewed SHA.
- Stop if propagation creates a non-merge rewrite or changes stack ancestry.
- Stop if either historical credential appears in the current tree, generated
  fixtures, logs, comments, or pull request text.
- Preserve all branches and existing pull request heads until the independent
  security pull request has landed and propagation is explicitly authorized.
