#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd -P)"
installer="$root/Scripts/install-skills.sh"
scratch="$(mktemp -d "${TMPDIR:-/tmp}/apple-development-foundation-skills.XXXXXX")"
trap 'rm -rf "$scratch"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
assert_link() { [[ -L "$1" ]] || fail "expected symlink: $1"; }
assert_exists() { [[ -e "$1" || -L "$1" ]] || fail "expected path: $1"; }
assert_missing() { [[ ! -e "$1" && ! -L "$1" ]] || fail "expected no path: $1"; }

home="$scratch/Codex Home With Spaces"
skills="$home/skills"

CODEX_HOME="$home" "$installer" >/dev/null
assert_link "$skills/apple-platform-planner"
assert_exists "$skills/.apple-development-foundation-links"

repeat_output="$(CODEX_HOME="$home" "$installer")"
[[ "$repeat_output" == *'Already installed (installer-owned): apple-platform-planner'* ]] \
  || fail "repeat installation was not recognized"

external_home="$scratch/external-identical"
mkdir -p "$external_home/skills"
ln -s "$root/.agents/skills/apple-platform-planner" "$external_home/skills/apple-platform-planner"
external_output="$(CODEX_HOME="$external_home" "$installer")"
[[ "$external_output" == *'Existing identical symlink is not installer-owned'* ]] \
  || fail "external identical link was claimed"
grep -q '^apple-platform-planner' "$external_home/skills/.apple-development-foundation-links" \
  && fail "external identical link was recorded"

conflict_home="$scratch/conflicts"
mkdir -p "$conflict_home/skills/apple-design-system"
touch "$conflict_home/skills/swiftui-component-author"
ln -s "/missing/skill" "$conflict_home/skills/swift-concurrency-review"
CODEX_HOME="$conflict_home" "$installer" >/dev/null
[[ -d "$conflict_home/skills/apple-design-system" ]] || fail "conflicting directory changed"
[[ -f "$conflict_home/skills/swiftui-component-author" ]] || fail "conflicting file changed"
assert_link "$conflict_home/skills/swift-concurrency-review"

dry_home="$scratch/dry run"
CODEX_HOME="$dry_home" "$installer" --dry-run >/dev/null
assert_missing "$dry_home"

unrelated="$skills/unrelated-file"
touch "$unrelated"
CODEX_HOME="$home" "$installer" --uninstall >/dev/null
assert_missing "$skills/apple-platform-planner"
assert_exists "$unrelated"
assert_missing "$skills/.apple-development-foundation-links"

CODEX_HOME="$home" "$installer" >/dev/null
rm "$skills/apple-platform-planner"
mkdir "$skills/apple-platform-planner"
CODEX_HOME="$home" "$installer" --uninstall >/dev/null
[[ -d "$skills/apple-platform-planner" ]] || fail "manual replacement was removed"

moved_root="$scratch/source before move"
mkdir -p "$moved_root/Scripts"
cp -R "$root/.agents" "$moved_root/.agents"
cp "$installer" "$moved_root/Scripts/install-skills.sh"
moved_home="$scratch/moved home"
CODEX_HOME="$moved_home" "$moved_root/Scripts/install-skills.sh" >/dev/null
mv "$moved_root" "$scratch/source after move"
CODEX_HOME="$moved_home" "$scratch/source after move/Scripts/install-skills.sh" --uninstall >/dev/null
assert_missing "$moved_home/skills/apple-platform-planner"

echo "skills installer tests passed"
