#!/usr/bin/env python3
import re
import shutil
import subprocess
import sys
from pathlib import Path


HEX_RUN = re.compile(rb"[0-9a-fA-F]{40,}")
QUOTED_HEX = re.compile(rb'''["']([0-9a-fA-F]+)["']''')
FINGERPRINT = re.compile(r"[0-9a-f]{64}")
MAX_FRAGMENT_GAP = 256
MAX_RECONSTRUCTED_LENGTH = 128


def load_fingerprints(path: Path) -> set[str]:
    fingerprints = {
        line.strip().lower()
        for line in path.read_text(encoding="ascii").splitlines()
        if line.strip()
    }
    if not fingerprints or any(not FINGERPRINT.fullmatch(value) for value in fingerprints):
        raise ValueError("fingerprint file is empty or malformed")
    return fingerprints


def windows(run: bytes, start: int):
    for length in (40, 64):
        for offset in range(0, len(run) - length + 1):
            yield start + offset, run[offset : offset + length]


def candidate_values(data: bytes):
    for match in HEX_RUN.finditer(data):
        yield from windows(match.group(), match.start())
    fragments = list(QUOTED_HEX.finditer(data))
    for index, first in enumerate(fragments):
        run = first.group(1)
        previous_end = first.end()
        for following in fragments[index + 1 :]:
            if following.start() - previous_end > MAX_FRAGMENT_GAP:
                break
            run += following.group(1)
            if len(run) > MAX_RECONSTRUCTED_LENGTH:
                break
            yield from windows(run, first.start())
            previous_end = following.end()


def files_under(path: Path):
    if path.is_file():
        yield path
        return
    for candidate in path.rglob("*"):
        if ".git" in candidate.parts or not candidate.is_file():
            continue
        yield candidate


def sha256(value: bytes) -> str:
    result = subprocess.run(
        ["shasum", "-a", "256"],
        input=value,
        capture_output=True,
        check=True,
    )
    return result.stdout.decode("ascii").split()[0]


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: check-revoked-fabric-fingerprints.py FINGERPRINTS SCAN_PATH", file=sys.stderr)
        return 2

    fingerprint_path = Path(sys.argv[1])
    scan_path = Path(sys.argv[2])
    if not fingerprint_path.is_file() or not scan_path.exists():
        print("fingerprint file or scan target is missing", file=sys.stderr)
        return 2
    if shutil.which("shasum") is None:
        print("shasum is required for credential fingerprint scanning", file=sys.stderr)
        return 2

    try:
        fingerprints = load_fingerprints(fingerprint_path)
    except (OSError, UnicodeError, ValueError) as error:
        print(f"unable to load credential fingerprints: {error}", file=sys.stderr)
        return 2

    findings = []
    digests = {}
    for path in files_under(scan_path):
        try:
            data = path.read_bytes()
        except OSError as error:
            print(f"unable to read scan target {path}: {error}", file=sys.stderr)
            return 2
        for offset, value in candidate_values(data):
            try:
                digest = digests.get(value)
                if digest is None:
                    digest = sha256(value)
                    digests[value] = digest
            except (OSError, subprocess.SubprocessError, UnicodeError) as error:
                print(f"unable to hash credential candidate: {error}", file=sys.stderr)
                return 2
            if digest in fingerprints:
                findings.append((path, offset, digest[:12]))

    if findings:
        for path, offset, prefix in findings:
            print(
                f"revoked Fabric credential fingerprint {prefix} found in {path} at byte {offset}",
                file=sys.stderr,
            )
        return 1

    print("No revoked Fabric credential fingerprints found.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
