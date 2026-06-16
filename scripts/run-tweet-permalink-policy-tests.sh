#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/tweet-permalink-policy-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}
trap cleanup 0
trap 'exit 129' 1
trap 'exit 130' 2
trap 'exit 143' 15

"$SWIFTC" \
    -D EXECUTABLE_POLICY_TESTS \
    "$ROOT/settee/TweetPermalinkPolicy.swift" \
    "$ROOT/Tests/TweetPermalinkPolicyTests/main.swift" \
    -o "$BUILD_DIR/tweet-permalink-policy-tests"

"$BUILD_DIR/tweet-permalink-policy-tests"
