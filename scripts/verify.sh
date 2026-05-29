#!/usr/bin/env bash
# Validate every fixture's SHA-256 against manifest.json.
# Exit 0 on success, non-zero on mismatch.

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v jq >/dev/null; then
    echo "verify: jq not in PATH; install with 'brew install jq'" >&2
    exit 2
fi

fail=0
jq -r '.fixtures[] | "\(.path) \(.sha256)"' manifest.json | \
while read -r path expected; do
    if [ ! -f "$path" ]; then
        echo "MISSING $path"
        fail=1
        continue
    fi
    actual=$(shasum -a 256 "$path" | awk '{print $1}')
    if [ "$actual" = "$expected" ]; then
        echo "OK      $path"
    else
        echo "DRIFT   $path"
        echo "  expected $expected"
        echo "  actual   $actual"
        fail=1
    fi
done
exit $fail
