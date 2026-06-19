#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SWIFTC=${SWIFTC:-swiftc}
BUILD_DIR=$(mktemp -d "${TMPDIR:-/tmp}/tweet-permalink-policy-tests.XXXXXX")

cleanup() {
    rm -rf -- "$BUILD_DIR"
}

handle_signal() {
    status=$1
    trap - 0 1 2 15
    cleanup
    exit "$status"
}

trap cleanup 0
trap 'handle_signal 129' 1
trap 'handle_signal 130' 2
trap 'handle_signal 143' 15

"$SWIFTC" \
    -D EXECUTABLE_POLICY_TESTS \
    "$ROOT/settee/TwitterSearchPolicy.swift" \
    "$ROOT/settee/TweetPermalinkPolicy.swift" \
    "$ROOT/Tests/TweetPermalinkPolicyTests/main.swift" \
    -o "$BUILD_DIR/tweet-permalink-policy-tests"

"$BUILD_DIR/tweet-permalink-policy-tests"
