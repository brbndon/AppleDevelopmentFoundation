---
name: codex-bootstrap
description: Use when bootstrapping a new iOS or macOS SwiftUI project or major feature set in the consumer workspace. Chain skills from this repo (design system, components, reviews). Do not use for one-off screens, editing this repo's archived package, or rebuilding AppleDevelopmentFoundation archive/Sources unless explicitly asked.
---

# Codex bootstrap

Bootstrap a **consumer app or package** in the active workspace using sibling skills from this repo. Do not add code to AppleDevelopmentFoundation's `archive/Sources/` unless the user explicitly requests package work.

## Step 1 — Intake

Confirm before writing files:

- Explicit consumer repository path and whether project-local operating guidance is authorized
- Target platforms (iOS, macOS, or both) and minimum OS versions
- SwiftUI app vs Swift Package vs mixed (app + local packages)
- Primary peer destinations and whether the app needs tabs, a sidebar, or no persistent navigation yet
- Existing design system to reuse, or need for a minimal neutral token/component layer
- Auth, persistence, networking, or entitlements constraints (app-owned; not prescribed here)
- Planning-only vs implementation request

Inputs: bootstrap request + any existing design system or app constraints. If planning-only, output the plan and skill selection without writing files.

## Step 2 — Project-local operating guidance

Before creating project files:

1. Inspect the consumer repository's root `AGENTS.md` and every applicable scoped
   `AGENTS.md`. Summarize the instructions that already govern the bootstrap.
2. Preserve existing instructions exactly. Never replace, append to, or merge an
   existing `AGENTS.md` without the user's explicit authorization for that edit.
3. If no consumer `AGENTS.md` exists, propose the neutral contract from
   [assets/consumer-AGENTS.md.template](assets/consumer-AGENTS.md.template) and
   create it only when project-local guidance is within the authorized bootstrap
   scope. The foundation repository's
   `Scripts/init-consumer-guidance.sh --target <consumer> --dry-run` can preview
   the file; the non-dry-run form refuses conflicts by default.
4. Customize project/workspace, scheme, configuration, platforms, deployment
   versions, exact simulator or `.xcodebuildmcp/config.yaml`, repository-native
   formatter/linter/test commands, and **Apple verification policy** knobs from
   inspected consumer configuration and team preference. The knobs are
   XcodeBuildMCP CLI fallback and repository-native raw `xcodebuild` / `xcrun` /
   `simctl`, each `require-approval` | `allowed` | `denied`. Template default is
   `require-approval` for both — keep that unless the user authorizes a different
   policy. Leave an explicit placeholder when a value cannot be established; do
   not invent it.
5. If existing guidance lacks this engineering baseline (including the Apple
   verification policy section and both knobs), show the missing sections and ask
   for authorization before merging them. A bootstrap can continue under existing
   instructions when guidance changes are not authorized.

Never modify global `~/.codex/AGENTS.md` or infer the foundation repository itself
as the consumer target.

## Step 3 — Skeleton expectations

Create minimal clean structure in the **consumer workspace**:

- SwiftUI `@main` app entry with a single root view shell
- Native primary navigation only when the user supplied multiple peer destinations; use `swiftui-tab-navigation` for a tab shell
- Platform-appropriate project layout (Xcode project or SPM + app target)
- Empty or stub feature areas — no business domain models unless the user supplied them
- If a shared design-system module is needed, create it in the consumer repo (local SPM target or app group), not in AppleDevelopmentFoundation

Do not copy or rebuild modules from AppleDevelopmentFoundation `archive/Sources/`. Do not run `./archive/Scripts/create-module.sh` in the skills reference repo.

## Step 4 — Skill chaining order

Apply skills in this order; skip steps that do not apply:

1. **`apple-platform-planner`** — scope the feature set and platform split when the request is broad
2. **`swiftui-tab-navigation`** — when the app has multiple persistent peer destinations
3. **`apple-design-system`** — semantic tokens, neutral defaults, appearance/contrast/motion
4. **`swiftui-component-author`** — reusable components built on the design system
5. **`ios-macos-platform-adaptation`** — when iOS and macOS behavior diverges
6. **`swift-concurrency-review`** — after async/actor code exists
7. **`apple-security-privacy-review`** — after file access, logging, imports, or permissions
8. **`apple-accessibility-review`** — after shared UI components exist
9. **`swift-testing-verification`** — before calling bootstrap complete

For extraction from an existing app, use **`reusable-code-extractor`** into the consumer's shared module — not into this reference repo.

## Step 5 — XcodeBuildMCP verification

Use XcodeBuildMCP (see repo `MCP.md`) — not raw `xcodebuild`/`simctl`. Enable the
`macos` workflow in `.xcodebuildmcp/config.yaml` when macOS tools are missing
(simulator tools alone are the MCP default).

1. `session_show_defaults` — establish or confirm project/workspace, scheme,
   configuration, and platform destination; report that context before the first
   action
2. `discover_projs` — only if defaults are missing or wrong
3. Branch by target platform (do not use iOS simulator tools for macOS-only apps):
   - **iOS (simulator):** resolve and reuse one exact `simulatorId`; prefer
     `build_run_sim` for launch; before tests, wait for same-project
     `xcodebuild` / `xctest` / test-runner processes; run `test_sim` without a
     redundant preceding build and default to
     `extraArgs: ["-parallel-testing-enabled", "NO"]`; optional `screenshot` /
     `snapshot_ui` (ui-automation workflow; iOS simulator only)
   - **macOS:** use the `macos` workflow — prefer `build_run_macos` for a launch
     smoke when useful; run `test_macos` when a test target exists (required
     verification when tests are present). Default
     `extraArgs: ["-parallel-testing-enabled", "NO"]`. Do **not** call
     `test_sim`, `build_run_sim`, or ui-automation screenshot/hierarchy tools —
     XcodeBuildMCP ui-automation is iOS-simulator-only. If no test target exists
     yet, report that `test_macos` was skipped and residual risk
   - **Both:** verify each platform with its own tool path above

If an MCP capability is unavailable, follow this ladder without skipping tiers.
Read the consumer `AGENTS.md` **Apple verification policy** knobs; shell access or
an installed binary is never permission by itself:

1. XcodeBuildMCP MCP tools.
2. Matching XcodeBuildMCP CLI workflow only when the CLI policy is `allowed`, or
   `require-approval` with fresh user approval for this step. Skip when `denied`.
3. Repository-native raw `xcodebuild` / `xcrun` / `simctl` only when the raw-tooling
   policy is `allowed`, or `require-approval` with fresh user approval. Skip when
   `denied`. For macOS fallbacks, state destination architecture explicitly
   (for example `platform=macOS,arch=arm64`).
4. Report blocked when no authorized path exists, including the policy values in
   force, checks not run, next action, and residual risk.

Never infer fallback permission from shell access or an installed command. Preserve
the same project/workspace, scheme, configuration, exact destination, serialized
test scope, and reporting in any authorized fallback.

Report scheme, destination (simulatorId or macOS), and any failure with the next
actionable tool call. Full checklist:
[references/bootstrap-checklist.md](references/bootstrap-checklist.md).

## Step 6 — Handoff

Output:

- Initial project structure and key files created in the consumer workspace
- Whether consumer `AGENTS.md` was created, preserved, or left as a proposed merge
- Which skills were applied and which to invoke next
- Verification results or blocker from the authorized capability ladder, including
  project/workspace, scheme, configuration, exact simulator/device, tools/commands,
  and residual risk
- Explicit stop: do not expand AppleDevelopmentFoundation archived package unless asked

## Stop conditions

Stop and ask when:

- User wants to rebuild or extend AppleDevelopmentFoundation's archived package
- No clear consumer workspace (which repo/app to bootstrap)
- Project-local guidance is requested but permission to create or merge it is unclear
- Request is a single screen or copy change — use `swiftui-component-author` directly instead
