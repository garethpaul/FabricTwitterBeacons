#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/twitter-search-policy-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}

trap cleanup 0 1 2 15

"$SWIFTC" \
    -D EXECUTABLE_POLICY_TESTS \
    "$ROOT/settee/TwitterSearchPolicy.swift" \
    "$ROOT/Tests/TwitterSearchPolicyTests/main.swift" \
    -o "$BUILD_DIR/twitter-search-policy-tests"

"$BUILD_DIR/twitter-search-policy-tests"
