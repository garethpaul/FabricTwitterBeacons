#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
guard="$repo_root/scripts/check-no-committed-fabric-secrets.sh"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

run_guard() {
  "$guard" "$1" >/dev/null 2>&1
}

make_hex() {
  local character=$1
  local length=$2
  printf "%${length}s" "" | tr ' ' "$character"
}

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

clean_fixture="$tmp_dir/clean"
mkdir -p "$clean_fixture"
cat > "$clean_fixture/project.pbxproj" <<'EOF'
shellScript = "./Fabric.framework/run \"$FABRIC_API_KEY\" \"$FABRIC_BUILD_SECRET\"";
EOF
run_guard "$clean_fixture" || fail "environment-variable configuration was rejected"

literal_fixture="$tmp_dir/literal"
mkdir -p "$literal_fixture"
api_key=$(make_hex a 40)
build_secret=$(make_hex b 64)
printf 'shellScript = "./Fabric.framework/run %s %s";\n' "$api_key" "$build_secret" > "$literal_fixture/project.pbxproj"
if run_guard "$literal_fixture"; then
  fail "literal Fabric credentials were accepted"
fi

fragment_fixture="$tmp_dir/fragments"
mkdir -p "$fragment_fixture"
printf 'fabric_api="%s""%s"\n' "${api_key:0:32}" "${api_key:32}" > "$fragment_fixture/check.sh"
printf 'fabric_secret="%s""%s"\n' "${build_secret:0:56}" "${build_secret:56}" >> "$fragment_fixture/check.sh"
if run_guard "$fragment_fixture"; then
  fail "adjacent credential fragments were accepted"
fi

bare_fixture="$tmp_dir/bare"
mkdir -p "$bare_fixture"
printf '%s\n%s\n' "$api_key" "$build_secret" > "$bare_fixture/values.txt"
fingerprint_fixture="$tmp_dir/fingerprints.sha256"
printf '%s\n' \
  "$(printf %s "$api_key" | shasum -a 256 | cut -d' ' -f1)" \
  "$(printf %s "$build_secret" | shasum -a 256 | cut -d' ' -f1)" \
  > "$fingerprint_fixture"
if FABRIC_FINGERPRINTS_FILE="$fingerprint_fixture" run_guard "$bare_fixture"; then
  fail "bare credential-shaped literals were accepted"
fi

binary_fixture="$tmp_dir/binary"
mkdir -p "$binary_fixture"
printf '\0%s\0%s\0' "$api_key" "$build_secret" > "$binary_fixture/blob.bin"
if FABRIC_FINGERPRINTS_FILE="$fingerprint_fixture" run_guard "$binary_fixture"; then
  fail "revoked values in a NUL-containing file were accepted"
fi

missing_gitleaks_fixture="$tmp_dir/missing-gitleaks"
mkdir -p "$missing_gitleaks_fixture/bin" "$missing_gitleaks_fixture/tree"
if PATH="$missing_gitleaks_fixture/bin:/usr/bin:/bin" "$guard" "$missing_gitleaks_fixture/tree" >/dev/null 2>&1; then
  fail "guard passed without Gitleaks"
fi

if run_guard "$tmp_dir/does-not-exist"; then
  fail "guard passed for a nonexistent scan target"
fi

run_guard "$repo_root" || fail "repository tree did not pass its own guard"

echo "Secret guard fixtures passed."
