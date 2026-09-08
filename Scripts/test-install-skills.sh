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

CODEX_HOME="$home" "$installer" >"$scratch/fresh-output.txt"
fresh_output="$(cat "$scratch/fresh-output.txt")"
assert_link "$skills/apple-platform-planner"
assert_link "$skills/swiftui-tab-navigation"
assert_exists "$skills/.apple-development-foundation-links"
[[ "$fresh_output" == *'Installed 17 skills to '* ]] \
  || fail "fresh install did not report installed count"
[[ "$fresh_output" == *'Next: in Codex, invoke $apple-development-foundation'* ]] \
  || fail "fresh install did not report next steps"
[[ "$fresh_output" == *'docs/quickstart.mdx'* ]] \
  || fail "fresh install did not report quickstart path"

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
dry_output="$(CODEX_HOME="$dry_home" "$installer" --dry-run)"
assert_missing "$dry_home"
[[ "$dry_output" != *'Installed 17 skills to '* ]] \
  || fail "dry run incorrectly reported installed count"

unrelated="$skills/unrelated-file"
touch "$unrelated"
CODEX_HOME="$home" "$installer" --uninstall >/dev/null
assert_missing "$skills/apple-platform-planner"
assert_missing "$skills/swiftui-tab-navigation"
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

# --status: installed-vs-HEAD reconciliation
status_root="$scratch/status repo"
mkdir -p "$status_root/Scripts"
cp -R "$root/.agents" "$status_root/.agents"
cp "$installer" "$status_root/Scripts/install-skills.sh"
if command -v git >/dev/null 2>&1; then
  git init -q "$status_root"
  git -C "$status_root" -c user.email=test@example.com -c user.name=test add -A
  git -C "$status_root" -c user.email=test@example.com -c user.name=test commit -qm init
fi
status_home="$scratch/status home"
CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" >/dev/null
CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status >/dev/null \
  || fail "clean install did not report synced"
status_output="$(CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status || true)"
[[ "$status_output" == *'ok: apple-platform-planner'* ]] \
  || fail "status did not report ok for installed skill"

rm "$status_home/skills/apple-platform-planner"
CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status >/dev/null \
  && fail "missing link was not detected"

ln -s "$status_root/.agents/skills/apple-design-system" "$status_home/skills/apple-platform-planner"
status_output="$(CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status || true)"
[[ "$status_output" == *'wrong-target: apple-platform-planner'* ]] \
  || fail "wrong-target link was not detected"
rm "$status_home/skills/apple-platform-planner"
CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" >/dev/null

mv "$status_root/.agents/skills/swiftui-tab-navigation" "$scratch/tab-nav-keep"
CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status >/dev/null \
  && fail "dangling link was not detected"
mv "$scratch/tab-nav-keep" "$status_root/.agents/skills/swiftui-tab-navigation"

if command -v git >/dev/null 2>&1; then
  echo "drift marker" >> "$status_root/.agents/skills/apple-design-system/SKILL.md"
  CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status >/dev/null \
    && fail "content drift was not detected"
  git -C "$status_root" checkout -q -- .agents/skills/apple-design-system/SKILL.md
fi

ln -s "$status_root/.agents/skills/apple-accessibility-review" "$status_home/skills/ghost-skill"
printf 'ghost-skill\t%s/.agents/skills/apple-accessibility-review\n' "$status_root" \
  >> "$status_home/skills/.apple-development-foundation-links"
status_output="$(CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status || true)"
[[ "$status_output" == *'stale: ghost-skill'* ]] \
  || fail "stale link was not detected"
rm "$status_home/skills/ghost-skill"
# Keep state file consistent for the remaining status checks.
grep -v '^ghost-skill' "$status_home/skills/.apple-development-foundation-links" > "$scratch/links-tmp"
mv "$scratch/links-tmp" "$status_home/skills/.apple-development-foundation-links"

rm "$status_home/skills/apple-design-system"
touch "$status_home/skills/apple-design-system"
status_output="$(CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status || true)"
[[ "$status_output" == *'wrong-target: apple-design-system (path exists but is not a symlink)'* ]] \
  || fail "non-symlink collision was not detected"
rm "$status_home/skills/apple-design-system"
ln -s "$status_root/.agents/skills/apple-design-system" "$status_home/skills/apple-design-system"

CODEX_HOME="$status_home" "$status_root/Scripts/install-skills.sh" --status --uninstall >/dev/null \
  && fail "combined --status --uninstall was not rejected"

echo "skills installer tests passed"
