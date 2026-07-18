#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
template="$root/.agents/skills/codex-bootstrap/assets/consumer-AGENTS.md.template"
target=""
dry_run=false

usage() {
  echo "usage: $0 --target <consumer-repository> [--dry-run]" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { usage; exit 2; }
      target="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

[[ -n "$target" ]] || { echo "An explicit --target is required." >&2; usage; exit 2; }
[[ -d "$target" ]] || { echo "Consumer target is not an existing directory: $target" >&2; exit 2; }
[[ -f "$template" ]] || { echo "Consumer guidance template is missing: $template" >&2; exit 1; }

target="$(cd "$target" && pwd -P)"
[[ "$target" != "$root" ]] || {
  echo "Refusing to initialize the foundation repository as a consumer target: $target" >&2
  exit 2
}

destination="$target/AGENTS.md"
if [[ -e "$destination" || -L "$destination" ]]; then
  echo "Conflict; leaving existing consumer instructions untouched: $destination" >&2
  echo "Review the codex-bootstrap consumer guidance template and merge approved sections manually." >&2
  exit 3
fi

if "$dry_run"; then
  echo "Would create: $destination"
  echo "Template: .agents/skills/codex-bootstrap/assets/consumer-AGENTS.md.template"
  echo
  cat "$template"
  exit 0
fi

temporary="$(mktemp "$target/.AGENTS.md.tmp.XXXXXX")"
trap 'rm -f "$temporary"' EXIT
cp "$template" "$temporary"
chmod 0644 "$temporary"
if ! ln "$temporary" "$destination"; then
  echo "Conflict; leaving existing consumer instructions untouched: $destination" >&2
  exit 3
fi
rm -f "$temporary"
trap - EXIT

echo "Created project-local consumer guidance: $destination"
echo "Customize every angle-bracket placeholder before relying on project-specific commands."
