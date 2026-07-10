#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"; source="$root/.agents/skills"; target="${CODEX_HOME:-$HOME/.codex}/skills"; state="$target/.apple-development-foundation-links"
dry_run=false; uninstall=false
for arg in "$@"; do case "$arg" in --dry-run) dry_run=true;; --uninstall) uninstall=true;; *) echo "usage: $0 [--dry-run] [--uninstall]" >&2; exit 2;; esac; done
run() { echo "+ $*"; $dry_run || "$@"; }
if $uninstall; then
  [[ -f "$state" ]] || { echo "No installer state found; nothing removed."; exit 0; }
  while IFS= read -r name; do link="$target/$name"; if [[ -L "$link" && "$(readlink "$link")" == "$source/$name" ]]; then run rm "$link"; else echo "Skip $link (not this installer's link)"; fi; done < "$state"
  run rm "$state"; exit 0
fi
run mkdir -p "$target"
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
python3 - "$source/manifest.json" > "$tmp" <<'PY'
import json, sys
for skill in json.load(open(sys.argv[1]))['skills']:
    if skill.get('installable'): print(skill['name'])
PY
while IFS= read -r name; do link="$target/$name"; if [[ -e "$link" || -L "$link" ]]; then if [[ -L "$link" && "$(readlink "$link")" == "$source/$name" ]]; then echo "Already installed: $name"; else echo "Conflict; leaving untouched: $link"; fi; else run ln -s "$source/$name" "$link"; fi; done < "$tmp"
if ! $dry_run; then cp "$tmp" "$state"; echo "Recorded installer-owned links in $state"; fi
