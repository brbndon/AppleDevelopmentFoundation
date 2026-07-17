---
name: codex-bootstrap
description: Use when bootstrapping a new iOS or macOS SwiftUI project or major feature set in the consumer workspace. Chain skills from this repo (design system, components, reviews). Do not use for one-off screens, editing this repo's archived package, or rebuilding AppleDevelopmentFoundation Sources unless explicitly asked.
---

# Codex bootstrap

Bootstrap a **consumer app or package** in the active workspace using sibling skills from this repo. Do not add code to AppleDevelopmentFoundation's archived `Sources/` unless the user explicitly requests package work.

## Step 1 — Intake

Confirm before writing files:

- Target platforms (iOS, macOS, or both) and minimum OS versions
- SwiftUI app vs Swift Package vs mixed (app + local packages)
- Primary peer destinations and whether the app needs tabs, a sidebar, or no persistent navigation yet
- Existing design system to reuse, or need for a minimal neutral token/component layer
- Auth, persistence, networking, or entitlements constraints (app-owned; not prescribed here)
- Planning-only vs implementation request

Inputs: bootstrap request + any existing design system or app constraints. If planning-only, output the plan and skill selection without writing files.

## Step 2 — Skeleton expectations

Create minimal clean structure in the **consumer workspace**:

- SwiftUI `@main` app entry with a single root view shell
- Native primary navigation only when the user supplied multiple peer destinations; use `swiftui-tab-navigation` for a tab shell
- Platform-appropriate project layout (Xcode project or SPM + app target)
- Empty or stub feature areas — no business domain models unless the user supplied them
- If a shared design-system module is needed, create it in the consumer repo (local SPM target or app group), not in AppleDevelopmentFoundation

Do not copy or rebuild modules from AppleDevelopmentFoundation `Sources/`. Do not run `./Scripts/create-module.sh` in the skills reference repo.

## Step 3 — Skill chaining order

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

## Step 4 — XcodeBuildMCP verification

Use XcodeBuildMCP (see repo `MCP.md`) — not raw `xcodebuild`/`simctl`:

1. `session_show_defaults` — establish or confirm project, scheme, simulator/device
2. `discover_projs` — only if defaults are missing or wrong
3. Build on simulator (iOS) or native target (macOS); prefer combined build-and-run for simulator launch
4. Run tests if the skeleton includes them
5. Optional: screenshot or view hierarchy to confirm the shell launches

Report scheme, simulator/device, and any failure with the next actionable tool call. Full checklist: [references/bootstrap-checklist.md](references/bootstrap-checklist.md).

## Step 5 — Handoff

Output:

- Initial project structure and key files created in the consumer workspace
- Which skills were applied and which to invoke next
- Verification results from XcodeBuildMCP
- Explicit stop: do not expand AppleDevelopmentFoundation archived package unless asked

## Stop conditions

Stop and ask when:

- User wants to rebuild or extend AppleDevelopmentFoundation's archived package
- No clear consumer workspace (which repo/app to bootstrap)
- Request is a single screen or copy change — use `swiftui-component-author` directly instead
