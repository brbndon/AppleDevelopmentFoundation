#!/usr/bin/env bash
set -euo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd -P)"
for command in xcodebuild xcrun swift sed; do
  command -v "$command" >/dev/null 2>&1 || { echo "Required command is unavailable: $command" >&2; exit 1; }
done
install=false; dry_run=false
for arg in "$@"; do case "$arg" in --install-skills) install=true;; --dry-run) dry_run=true;; *) echo "usage: $0 [--install-skills] [--dry-run]" >&2; exit 2;; esac; done
echo "Xcode:"; xcodebuild -version
echo "Swift:"; swift --version
echo "SDKs:"; xcodebuild -showsdks
echo "Available simulators:"; xcrun simctl list devices available | sed -n '1,60p'
echo "Codex:"; (codex --version || true)
echo "Existing global instructions: ${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
echo "Existing user skill directory: ${CODEX_HOME:-$HOME/.codex}/skills"
[[ -f Package.swift ]] || { echo "Package.swift is missing" >&2; exit 1; }
if $install; then args=(); $dry_run && args+=(--dry-run); ./Scripts/install-skills.sh "${args[@]}"; else echo "Skills not installed (pass --install-skills to opt in)."; fi
