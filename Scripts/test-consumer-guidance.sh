#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
initializer="$root/Scripts/init-consumer-guidance.sh"
legacy_installer="$root/Scripts/install-global-instructions.sh"
template="$root/.agents/skills/codex-bootstrap/assets/consumer-AGENTS.md.template"
scratch="$(mktemp -d "${TMPDIR:-/tmp}/apple-development-foundation-guidance.XXXXXX")"
trap 'rm -rf "$scratch"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

# Lock Apple verification policy knobs on the template and any copied contract.
assert_apple_verification_policy() {
  local file="$1"
  [[ -f "$file" ]] || fail "missing file for policy assertion: $file"
  grep -q '## Apple verification policy' "$file" \
    || fail "missing Apple verification policy section in $file"
  grep -q 'XcodeBuildMCP CLI fallback:' "$file" \
    || fail "missing XcodeBuildMCP CLI fallback knob in $file"
  grep -q 'Repository-native raw `xcodebuild` / `xcrun` / `simctl`:' "$file" \
    || fail "missing raw Xcode tooling policy knob in $file"
  grep -q 'allowed values: `require-approval` | `allowed` | `denied`' "$file" \
    || fail "missing allowed policy enum values in $file"
  grep -q 'XcodeBuildMCP CLI fallback: `require-approval`' "$file" \
    || fail "CLI fallback default is not require-approval in $file"
  grep -q 'Repository-native raw `xcodebuild` / `xcrun` / `simctl`: `require-approval`' "$file" \
    || fail "raw tooling default is not require-approval in $file"
  grep -q 'Shell access or an installed' "$file" \
    || fail "missing shell-is-not-permission guidance in $file"
  grep -q '\*\*macOS targets:\*\*' "$file" \
    || fail "missing macOS verification branch in $file"
  grep -q 'test_macos' "$file" \
    || fail "missing test_macos in $file"
  grep -q 'build_run_macos' "$file" \
    || fail "missing build_run_macos in $file"
  grep -q 'build_macos' "$file" \
    || fail "missing build_macos compile fallback in $file"
  grep -q '\*\*iOS (simulator) targets:\*\*' "$file" \
    || fail "missing iOS simulator verification branch in $file"
}

assert_apple_verification_policy "$template"

consumer="$scratch/Consumer App With Spaces"
mkdir -p "$consumer"
consumer="$(cd "$consumer" && pwd -P)"

dry_output="$("$initializer" --target "$consumer" --dry-run)"
[[ "$dry_output" == *"Would create: $consumer/AGENTS.md"* ]] \
  || fail "dry run did not report the explicit destination"
[[ ! -e "$consumer/AGENTS.md" ]] || fail "dry run created consumer guidance"

"$initializer" --target "$consumer" >/dev/null
cmp -s "$template" "$consumer/AGENTS.md" || fail "created guidance differs from template"
assert_apple_verification_policy "$consumer/AGENTS.md"

printf 'existing consumer instructions\n' > "$consumer/AGENTS.md"
if "$initializer" --target "$consumer" >/dev/null 2>&1; then
  fail "initializer overwrote an existing AGENTS.md"
fi
[[ "$(cat "$consumer/AGENTS.md")" == "existing consumer instructions" ]] \
  || fail "existing AGENTS.md content changed after conflict"

directory_conflict="$scratch/directory-conflict"
mkdir -p "$directory_conflict/AGENTS.md"
if "$initializer" --target "$directory_conflict" >/dev/null 2>&1; then
  fail "initializer accepted an AGENTS.md directory conflict"
fi
[[ -d "$directory_conflict/AGENTS.md" ]] || fail "AGENTS.md directory conflict changed"

symlink_conflict="$scratch/symlink-conflict"
mkdir -p "$symlink_conflict"
ln -s "$consumer/AGENTS.md" "$symlink_conflict/AGENTS.md"
if "$initializer" --target "$symlink_conflict" >/dev/null 2>&1; then
  fail "initializer accepted an AGENTS.md symlink conflict"
fi
[[ -L "$symlink_conflict/AGENTS.md" ]] || fail "AGENTS.md symlink conflict changed"

if "$initializer" --target "$root" --dry-run >/dev/null 2>&1; then
  fail "initializer accepted the foundation repository as a consumer target"
fi

if "$initializer" --dry-run >/dev/null 2>&1; then
  fail "initializer accepted a missing --target"
fi

legacy_home="$scratch/legacy-codex-home"
if CODEX_HOME="$legacy_home" "$legacy_installer" --install >/dev/null 2>&1; then
  fail "retired global installer reported success"
fi
[[ ! -e "$legacy_home" ]] || fail "retired global installer modified global configuration"

echo "consumer guidance initializer tests passed"
