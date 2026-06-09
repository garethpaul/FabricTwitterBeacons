#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PROJECT="$ROOT_DIR/settee.xcodeproj/project.pbxproj"
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fabric-twitter-beacons-maintenance-baseline.md"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "settee.xcodeproj/project.pbxproj" \
  "settee/AppDelegate.swift" \
  "settee/RateLimit.swift" \
  "settee/ViewController.swift" \
  "settee/TVSearchAPI.swift" \
  "setteeTests/setteeTests.swift" \
  "docs/plans/2026-06-08-fabric-twitter-beacons-maintenance-baseline.md"; do
  require_file "$path"
done

if grep -Fq "abb870ac2c6cd77fc0a3ee166f786a86748f4eb9" "$PROJECT" ||
  grep -Fq "47d331d25396fd56e08c5c5891c16a003ba5647e584bf8fc07feb0e8ae92ab92" "$PROJECT" ||
  grep -Eq './Fabric\.framework/run [0-9a-f]{32,}' "$PROJECT"; then
  printf '%s\n' "Fabric run script must not contain committed Fabric credentials." >&2
  exit 1
fi

if ! grep -Fq "FABRIC_API_KEY" "$PROJECT" ||
  ! grep -Fq "FABRIC_BUILD_SECRET" "$PROJECT" ||
  ! grep -Fq 'Skipping Fabric upload' "$PROJECT"; then
  printf '%s\n' "Fabric run script must read credentials from local environment variables." >&2
  exit 1
fi

if grep -Fq "println(beacons)" "$ROOT_DIR/settee/AppDelegate.swift"; then
  printf '%s\n' "Raw beacon payloads must not be logged." >&2
  exit 1
fi

if grep -Fq "println(String(proximity))" "$ROOT_DIR/settee/WaitingController.swift"; then
  printf '%s\n' "Beacon proximity transitions must not be logged." >&2
  exit 1
fi

beacon_nil_guards=$(grep -R "if beacons == nil" "$ROOT_DIR/settee" | wc -l | tr -d ' ')
if [ "$beacon_nil_guards" -lt 2 ]; then
  printf '%s\n' "Beacon ranging callbacks must guard missing beacon arrays." >&2
  exit 1
fi

if grep -Fq "topN =" "$ROOT_DIR/settee/RateLimit.swift" ||
  ! grep -Fq "limitTweetIDs" "$ROOT_DIR/settee/RateLimit.swift"; then
  printf '%s\n' "RateLimit.swift must keep a complete bounded-list helper." >&2
  exit 1
fi

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_API_KEY" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_BUILD_SECRET" "$ROOT_DIR/README.md" ||
  ! grep -Fq "physical-device" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document baseline verification and local Fabric/beacon setup." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Fabric run script" "$ROOT_DIR/VISION.md" ||
  ! grep -iq "raw beacon payloads" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current Fabric and beacon privacy guardrails." >&2
  exit 1
fi

if ! grep -Fq "*.xcconfig" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq ".env" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' "Local credential files must stay ignored." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -project "$ROOT_DIR/settee.xcodeproj"
else
  printf '%s\n' "Skipping xcodebuild project listing: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

printf '%s\n' "FabricTwitterBeacons baseline checks passed."
