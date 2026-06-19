#!/usr/bin/env sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
workflow="$repo_root/.github/workflows/check.yml"
makefile="$repo_root/Makefile"
status=0

if ! grep -Fq \
  'actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10 # v6.0.3' \
  "$workflow"; then
  printf '%s\n' "FAIL: checkout annotation must match the pinned v6.0.3 SHA" >&2
  status=1
fi

checkout_block=$(awk '
  /actions\/checkout@/ { in_checkout = 1 }
  in_checkout && /^      - / && !/actions\/checkout@/ { exit }
  in_checkout { print }
' "$workflow")
if ! printf '%s\n' "$checkout_block" | grep -Fq 'persist-credentials: false'; then
  printf '%s\n' "FAIL: checkout must not persist repository credentials" >&2
  status=1
fi

check_recipe=$(awk '
  /^check:/ { in_check = 1; next }
  in_check && /^[[:alnum:]_.-]+:/ { exit }
  in_check { print }
' "$makefile")

if ! printf '%s\n' "$check_recipe" | grep -Fq './tests/test-secret-guard.sh'; then
  printf '%s\n' "FAIL: make check must execute tests/test-secret-guard.sh" >&2
  status=1
fi

if [ "$status" -ne 0 ]; then
  exit "$status"
fi

printf '%s\n' "CI wiring checks passed."
