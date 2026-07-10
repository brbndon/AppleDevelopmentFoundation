#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"; target="${CODEX_HOME:-$HOME/.codex}/AGENTS.md"; proposal="$root/Templates/NewApp/GlobalAppleDevelopmentInstructions.md"; install=false
[[ ${1:-} == "--install" ]] && install=true
if [[ ${1:-} && ${1:-} != "--install" ]]; then echo "usage: $0 [--install]" >&2; exit 2; fi
echo "Proposed addition:"; cat "$proposal"
if [[ -f "$target" ]]; then diff -u "$target" <(cat "$target"; printf '\n\n'; cat "$proposal") || true; else echo "Would create $target"; fi
if ! $install; then echo "No global file changed. Re-run with --install after reviewing the diff."; exit 0; fi
mkdir -p "$(dirname "$target")"; [[ -f "$target" ]] && cp "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
{ [[ -f "$target" ]] && cat "$target"; printf '\n\n'; cat "$proposal"; } > "$target.new"
mv "$target.new" "$target"; echo "Installed proposal; backup retained beside $target when an original existed."
