#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
scan_path=${1:-$repo_root}
config="$repo_root/.gitleaks.toml"
fingerprints=${FABRIC_FINGERPRINTS_FILE:-$repo_root/config/fabric-credential-fingerprints.sha256}

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "Gitleaks is required for credential scanning." >&2
  exit 1
fi

if [[ ! -f "$config" ]]; then
  echo "Gitleaks configuration is missing: $config" >&2
  exit 1
fi

if [[ ! -e "$scan_path" ]]; then
  echo "Credential scan target does not exist: $scan_path" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Python 3 is required for revoked-credential fingerprint scanning." >&2
  exit 1
fi

python3 "$repo_root/scripts/check-revoked-fabric-fingerprints.py" \
  "$fingerprints" \
  "$scan_path"

gitleaks dir \
  --no-banner \
  --redact=100 \
  --config "$config" \
  "$scan_path"
