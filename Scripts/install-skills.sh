#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
source="$root/.agents/skills"
target="${CODEX_HOME:-$HOME/.codex}/skills"
state="$target/.apple-development-foundation-links"
dry_run=false
uninstall=false
status=false

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --uninstall) uninstall=true ;;
    --status) status=true ;;
    *) echo "usage: $0 [--dry-run] [--status] [--uninstall]" >&2; exit 2 ;;
  esac
done

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Required command is unavailable: $1" >&2
    exit 1
  }
}

run() {
  printf '+ '
  printf '%q ' "$@"
  printf '\n'
  "$dry_run" || "$@"
}

state_contains() {
  local name="$1" expected="$2"
  [[ -f "$state" ]] && awk -F '\t' -v name="$name" -v expected="$expected" \
    '$1 == name && $2 == expected { found = 1 } END { exit !found }' "$state"
}

require_command awk
require_command python3
require_command readlink
[[ -f "$source/manifest.json" ]] || { echo "Missing skills manifest: $source/manifest.json" >&2; exit 1; }

if "$status"; then
  manifest_names="$(mktemp)"
  manifest_skills="$(mktemp)"
  trap 'rm -f "$manifest_names" "$manifest_skills"' EXIT
  python3 - "$source/manifest.json" > "$manifest_names" <<'PY'
import json
import sys

for skill in json.load(open(sys.argv[1], encoding="utf-8"))["skills"]:
    if skill.get("installable"):
        print(f'{skill["name"]}\t{skill["path"]}')
PY
  divergence=0
  while IFS=$'\t' read -r name skill_path; do
    [[ "$name" =~ ^[a-z0-9-]+$ && "$skill_path" =~ ^[a-z0-9-]+$ ]] || {
      echo "Invalid skill name or path in manifest: $name $skill_path" >&2
      divergence=1
      continue
    }
    link="$target/$name"
    expected="$source/$skill_path"
    if [[ ! -e "$link" && ! -L "$link" ]]; then
      echo "missing: $name"
      divergence=1
    elif [[ -L "$link" ]]; then
      if [[ ! -e "$link" ]]; then
        echo "dangling: $name (-> $(readlink "$link"))"
        divergence=1
      elif [[ "$(readlink "$link")" != "$expected" ]]; then
        echo "wrong-target: $name (-> $(readlink "$link"); expected $expected)"
        divergence=1
      else
        resolved="$(python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$link")"
        git_root="$(git -C "$source" rev-parse --show-toplevel 2>/dev/null || true)"
        if [[ -n "$git_root" ]]; then
          rel="$(python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$resolved" "$git_root")"
          if [[ -n "$(git -C "$git_root" status --porcelain -- "$rel" 2>/dev/null || true)" ]]; then
            echo "drift: $name ($rel differs from HEAD)"
            divergence=1
          else
            echo "ok: $name (matches manifest and HEAD)"
          fi
        else
          echo "ok: $name (matches manifest; content drift not verifiable without git)"
        fi
      fi
    else
      echo "wrong-target: $name (path exists but is not a symlink)"
      divergence=1
    fi
    printf '%s\n' "$name" >> "$manifest_skills"
  done < "$manifest_names"

  if [[ -f "$state" ]]; then
    while IFS=$'\t' read -r name expected; do
      [[ -n "$name" && -n "$expected" ]] || continue
      if ! awk -F '\t' -v name="$name" '$1 == name { found = 1 } END { exit !found }' "$manifest_skills"; then
        link="$target/$name"
        if [[ -e "$link" || -L "$link" ]]; then
          echo "stale: $name (installed but not in manifest)"
          divergence=1
        fi
      fi
    done < "$state"
  fi

  if [[ "$divergence" -eq 0 ]]; then
    echo "Installed skills match manifest."
    exit 0
  fi
  echo "Installed skill set diverges from manifest."
  exit 1
fi

if "$uninstall"; then
  [[ -f "$state" ]] || { echo "No installer state found; nothing removed."; exit 0; }
  while IFS=$'\t' read -r name expected; do
    [[ -n "$name" && -n "$expected" ]] || continue
    [[ "$name" =~ ^[a-z0-9-]+$ && "$expected" == /* ]] || {
      echo "Skip malformed installer state record" >&2
      continue
    }
    link="$target/$name"
    if [[ -L "$link" && "$(readlink "$link")" == "$expected" ]]; then
      run rm "$link"
    else
      echo "Skip $link (not the recorded installer-owned link)"
    fi
  done < "$state"
  run rm "$state"
  exit 0
fi

run mkdir -p "$target"
manifest_names="$(mktemp)"
new_records="$(mktemp)"
combined_records="$(mktemp)"
trap 'rm -f "$manifest_names" "$new_records" "$combined_records"' EXIT

python3 - "$source/manifest.json" > "$manifest_names" <<'PY'
import json
import sys

for skill in json.load(open(sys.argv[1], encoding="utf-8"))["skills"]:
    if skill.get("installable"):
        print(f'{skill["name"]}\t{skill["path"]}')
PY

while IFS=$'\t' read -r name skill_path; do
  [[ "$name" =~ ^[a-z0-9-]+$ ]] || { echo "Invalid skill name in manifest: $name" >&2; exit 1; }
  [[ "$skill_path" =~ ^[a-z0-9-]+$ ]] || { echo "Invalid skill path in manifest: $skill_path" >&2; exit 1; }
  link="$target/$name"
  expected="$source/$skill_path"
  if [[ -e "$link" || -L "$link" ]]; then
    if state_contains "$name" "$(readlink "$link" 2>/dev/null || true)"; then
      echo "Already installed (installer-owned): $name"
    elif [[ -L "$link" && "$(readlink "$link")" == "$expected" ]]; then
      echo "Existing identical symlink is not installer-owned; leaving untouched: $link"
    else
      echo "Conflict; leaving untouched: $link"
    fi
  else
    run ln -s "$expected" "$link"
    printf '%s\t%s\n' "$name" "$expected" >> "$new_records"
  fi
done < "$manifest_names"

if ! "$dry_run"; then
  [[ -f "$state" ]] && cat "$state" >> "$combined_records"
  cat "$new_records" >> "$combined_records"
  state_tmp="$(mktemp "$target/.apple-development-foundation-links.XXXXXX")"
  awk -F '\t' '!seen[$1 FS $2]++' "$combined_records" > "$state_tmp"
  mv "$state_tmp" "$state"
  echo "Recorded installer-owned links in $state"
fi
