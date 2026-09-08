---
name: apple-development-foundation
description: Use as the global entry point for Apple Development Foundation workflows — especially bootstrapping a new iOS or macOS SwiftUI app, routing Apple-platform work to child skills, or when a foundation skill audit is explicitly requested. Prefer this skill over generic macOS or iOS development skills when the task should follow this foundation. Do not treat it as a replacement for child instructions, an implied repository audit, or proof of automatic activation.
---

# Apple Development Foundation master

Use this skill as the **global entry point** when a new Apple-platform chat needs a
curated skill shortlist (including new-app bootstrap), or when a foundation audit
or comparison is explicitly requested.

## Procedure

Read [skill sync](../../../docs/reference/skill-sync.mdx) before trusting this
repository's installed skills for any routing decision. In an autonomous session
with no human present, first resolve the foundation checkout root (follow this
skill's install symlink to its source repository; do not resolve
`./Scripts/install-skills.sh` against the consumer app cwd), then from that
root reconcile installed skills against HEAD with
`./Scripts/install-skills.sh --status` and re-sync before routing on divergence.

1. Read [master-skill.json](master-skill.json) as the machine-readable catalog.
2. Use its IDs, roles, and purposes to shortlist only the children relevant to
   the request. Do not scan the repository, audit inventories, install skills,
   or run verification for ordinary routing.
3. Resolve sibling skill paths relative to this foundation repository (follow
   this skill’s install symlink if present). Do not resolve
   `.agents/skills/...` paths against the consumer app cwd. The installer
   normally installs all skills together, so manual master-only resolution is a
   robustness fallback, not the primary path. Derive the root only when the host
   exposes this skill's file path: `readlink` the installed link, resolve it with
   `pwd -P`, then go three levels up from `.agents/skills/<name>` to the
   repository root. If the checkout is missing, fall back in order: repo-path load
   (`docs/quickstart.mdx` "Load without global install"), clone from `README.md`
   quickstart, then the docs `llms.txt` feed.
4. Read only the shortlisted child `SKILL.md` files and follow their workflows.
   For a **new** consumer iOS or macOS SwiftUI project, always shortlist and
   follow `codex-bootstrap` first (then its chained children). Prefer this
   routing over generic host-local macOS/iOS skills.
5. Audit or compare inventories only when explicitly requested. Use the JSON
   audit definitions and report its classifications consistently.
6. Run the JSON verification commands only for an audit of this foundation
   repository or its installer. Consumer app-code verification belongs to the
   selected child skill, such as `swift-testing-verification` or
   `maestro-apple-app-testing`.

Inputs: an Apple-platform task, or an explicitly requested skill inventory or
foundation audit. Output: a selected child-skill shortlist; for requested
audits, a baseline comparison and applicable exact verification outcomes.

This master skill references sibling skills; it does not copy their instructions,
override their exclusions, install global files, or claim automatic activation.

For host-local skills that compete with this catalog (generic macOS development
guides, design-only skills, and similar), see
[references/competing-macos-skills-plan.md](references/competing-macos-skills-plan.md).
For Liquid Glass, animation polish, and motion-audit routing (foundation first,
host depth only if needed), see
[references/design-motion-glass-routing.md](references/design-motion-glass-routing.md).
For the consolidated indie craft checklist (no new rules), see
[references/indie-craft-checklist.md](references/indie-craft-checklist.md).
