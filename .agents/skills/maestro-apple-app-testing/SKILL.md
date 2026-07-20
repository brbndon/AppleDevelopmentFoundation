---
name: maestro-apple-app-testing
description: Use when building, debugging, authoring, or journey-level testing an Apple app with Maestro, including iOS simulator flows, UI inspection, screenshots, flaky-flow diagnosis, and focused regression of the affected flow(s). Prefer the single edited or directly affected flow over tagged or full suites. Do not use for non-testing product implementation or standalone unit tests.
---

# Maestro Apple app testing

Use this as the main workflow for iOS app testing with Maestro. Combine it with the
project's XcodeBuildMCP and Apple-development skills; this skill owns the end-to-end
testing loop, not product implementation.

## Inputs and output

Inputs: the active Apple app workspace, its Xcode project or package, available
simulators/devices, existing `.maestro/` flows, and the requested behavior or bug.

Output: repeatable Maestro flows or focused edits, executed test results, screenshots
and debug artifacts when useful, and a concise report of coverage, failures, and
remaining manual checks. Never claim a test passed without running it.

## Scope Maestro to changed journeys

Do not run Maestro merely because code changed. Use it when a task edits a Maestro
flow or changes user-visible UI, interaction, navigation, or journey behavior. For
non-UI code, run Maestro only when the changed logic directly affects a known user
journey; use focused unit, integration, or build verification for documentation,
tooling, refactors, and logic outside a user journey.

Map the change to its existing flow(s) before testing. Run only the one edited or
directly affected flow during normal work; if a shared change genuinely affects
multiple journeys, run only those directly affected flows and state why. Do not run
tagged suites or every flow as a routine final check. Run a complete suite only when
the user explicitly requests it or an explicit release/CI policy requires it.

## Workflow

1. Inspect the active workspace, existing `.maestro/` flows, app identifiers,
   accessibility identifiers, and available test fixtures. Reuse existing conventions.
2. Check the toolchain with `command -v maestro`, `maestro --version`, and
   `maestro list-devices`. If Maestro or its configured MCP server is unavailable,
   report the exact blocker before writing speculative flows.
3. For Swift/Xcode builds, runs, simulator management, and UI inspection, use the
   available XcodeBuildMCP tools. Before the first build, run, or test action, call
   `session_show_defaults` and report the active project, scheme, configuration, and
   simulator. Resolve and reuse one exact simulator ID; do not use `OS=latest`.
4. Build and launch the app with the project's established XcodeBuildMCP workflow.
   Use Maestro MCP for live hierarchy inspection, screenshots, interaction, and
   debugging; use `maestro test` for repeatable YAML execution and CI-like coverage.
5. Author flows with stable `testID`/accessibility selectors, explicit assertions,
   automatic waiting, conditional handling for permissions/onboarding, and reusable
   subflows. Inspect system-generated controls such as SwiftUI tab buttons before
   selecting them: an identifier inside `.tabItem` may not propagate to the generated
   button, so use its confirmed accessibility label when no identifier is exposed.
   Do not use arbitrary sleeps when a state assertion or wait can express the condition.
6. When authoring or repairing a flow, cover its relevant happy path, validation and
   error states, loading/empty states, relaunch and persistence behavior,
   navigation/back behavior, permissions, keyboard/input, and accessibility-visible
   labels. Keep that coverage in the focused flow; do not expand to unrelated flows.
7. On failure, preserve or request debug output, screenshots, hierarchy, and video
   when useful; classify the failure as app behavior, test selector/flow, fixture,
   simulator/device, build, or environment. Reproduce once before changing a flow.
8. Finish by reporting exact commands, simulator/device ID, flows and tags run,
   pass/fail counts, artifact locations, and untested or manually verified areas.

## Maestro MCP rules

The official Maestro CLI includes the MCP server. Prefer the configured local server
with `maestro mcp` for interactive debugging. Use MCP to inspect the current screen and
confirm selectors before editing a flow; use CLI flows for deterministic regression
coverage. Keep MCP and CLI pointed at the same simulator/device and app state.

If a task requires Android or web coverage, adapt the workflow to the active platform
and report platform-specific gaps rather than assuming iOS selectors or behavior.

## Verification contract

Run the single smallest relevant flow after each flow or journey change. Do not add a
tagged or complete-suite run unless the user explicitly requests it or a documented
release/CI gate requires it. Use `--debug-output` or equivalent artifacts for
failures. Do not modify production data or use real credentials; use fixtures, test
accounts, and environment variables supplied by the workspace.
