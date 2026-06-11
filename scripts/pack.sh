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
    # COPYFILE_DISABLE + --exclude keep macOS AppleDouble (._*) resource-fork
    # junk and .DS_Store out of the tarball — they break consumers that glob
    # the fixture directory (e.g. opening ._Philips-4.tiff as a slide).
    (cd fixtures && COPYFILE_DISABLE=1 tar --exclude='._*' --exclude='.DS_Store' -cf "../$out" "$fmt")
    size=$(stat -f%z "$out" 2>/dev/null || stat -c%s "$out")
    printf "packed  %-12s  %12d bytes\n" "$out" "$size"
done
