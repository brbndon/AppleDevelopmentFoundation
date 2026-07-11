#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WEBSITE_DIR="$ROOT_DIR/Website"

required_files=(index.html styles.css README.md package.json package-lock.json vite.config.js src/main.jsx src/App.jsx)
for file in "${required_files[@]}"; do
    test -f "$WEBSITE_DIR/$file" || { echo "Missing Website/$file" >&2; exit 1; }
done

rg -q 'id="root"' "$WEBSITE_DIR/index.html"
rg -q 'src/main\.jsx' "$WEBSITE_DIR/index.html"
rg -q 'id="main-content"' "$WEBSITE_DIR/src/App.jsx"
rg -q 'id="quick-start"' "$WEBSITE_DIR/src/App.jsx"
rg -q 'id="modules"' "$WEBSITE_DIR/src/App.jsx"
rg -q 'id="apis"' "$WEBSITE_DIR/src/App.jsx"
rg -q 'id="agents"' "$WEBSITE_DIR/src/App.jsx"
rg -q 'id="ownership"' "$WEBSITE_DIR/src/App.jsx"
rg -q 'prefers-reduced-motion' "$WEBSITE_DIR/styles.css"
rg -q 'aria-expanded' "$WEBSITE_DIR/src/App.jsx"
rg -q 'navigator\.clipboard' "$WEBSITE_DIR/src/App.jsx"
rg -q '@tailwindcss/vite' "$WEBSITE_DIR/vite.config.js"
rg -q '@import "tailwindcss"' "$WEBSITE_DIR/styles.css"

test -x "$WEBSITE_DIR/node_modules/.bin/vite" || { echo "Website dependencies are not installed; run npm ci --prefix Website" >&2; exit 1; }
npm run build --prefix "$WEBSITE_DIR"
test -f "$WEBSITE_DIR/dist/index.html"

echo "Website verification passed: ${#required_files[@]} required files, SPA build, and accessibility/interaction anchors present."
