#!/usr/bin/env bash
# Build per-format tarballs in dist/ for release upload.
# Each tarball is `<format>.tar` and contains the format's directory tree:
# `tar xf svs.tar` extracts `svs/CMU-1-Small-Region.svs` (etc.).

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

rm -rf dist
mkdir -p dist

for fmt_dir in fixtures/*/; do
    fmt=$(basename "$fmt_dir")
    out="dist/${fmt}.tar"
    (cd fixtures && tar cf "../$out" "$fmt")
    size=$(stat -f%z "$out" 2>/dev/null || stat -c%s "$out")
    printf "packed  %-12s  %12d bytes\n" "$out" "$size"
done
