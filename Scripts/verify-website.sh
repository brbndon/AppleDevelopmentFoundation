#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEBSITE_DIR="$ROOT_DIR/Website"

required_files=(index.html styles.css script.js README.md)
for file in "${required_files[@]}"; do
    test -f "$WEBSITE_DIR/$file" || { echo "Missing Website/$file" >&2; exit 1; }
done

rg -q 'id="main-content"' "$WEBSITE_DIR/index.html"
rg -q 'id="quick-start"' "$WEBSITE_DIR/index.html"
rg -q 'id="modules"' "$WEBSITE_DIR/index.html"
rg -q 'id="apis"' "$WEBSITE_DIR/index.html"
rg -q 'id="agents"' "$WEBSITE_DIR/index.html"
rg -q 'id="ownership"' "$WEBSITE_DIR/index.html"
rg -q 'prefers-reduced-motion' "$WEBSITE_DIR/styles.css"
rg -q 'aria-expanded' "$WEBSITE_DIR/index.html"
rg -q 'navigator.clipboard' "$WEBSITE_DIR/script.js"

echo "Website verification passed: ${#required_files[@]} required files and accessibility/interaction anchors present."
