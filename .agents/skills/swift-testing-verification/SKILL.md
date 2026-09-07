---
name: swift-testing-verification
description: Use after a meaningful Apple-platform code change to select and run verification. Do not use for planning-only work or before an implementation exists.
---

# Swift testing and verification

Choose the smallest relevant tests; run package-wide tests for dependencies or public APIs; build affected iOS and macOS examples. Report exact commands/outcomes and distinguish existing failures from introduced failures.

Inputs: completed change and affected targets. Output: executed verification results, unavailable checks, and manual-only checks. Never claim a check passed without running it.

## Apple verification capability ladder

For Xcode projects, use the first authorized path:

1. XcodeBuildMCP MCP tools. Before the first build/run/test, call
   `session_show_defaults` and report project/workspace, scheme, configuration,
   and platform destination. Branch by platform:
   - **iOS simulator:** one exact `simulatorId`; serialize same-project simulator
     tests; prefer `test_sim` with
     `extraArgs: ["-parallel-testing-enabled", "NO"]`.
   - **macOS:** enable/use the `macos` workflow; prefer `test_macos` (and
     `build_run_macos` when a launch smoke is needed). Do not use `test_sim` or
     ui-automation screenshot/hierarchy tools for macOS — those are
     iOS-simulator-only. If no test target exists, require at least `build_macos`
     (or `build_run_macos`) and report the test skip and residual risk rather
     than claiming UI verification.
2. XcodeBuildMCP CLI only when active repository/user policy explicitly permits
   CLI fallback.
3. Repository-native raw Xcode tooling only when active policy authorizes it;
   obtain explicit approval when required. For macOS, include an explicit
   destination (for example `platform=macOS,arch=arm64`).
4. Report blocked when no authorized path exists.

Never infer authorization from shell access or installed binaries. Preserve the
same target context and test scope in an authorized fallback. Handoff must include
the project/workspace, scheme, configuration, exact destination, commands or tools,
outcomes, skipped checks, and residual risk.

## User-interface evidence

For a user-visible iOS/iPadOS change, use the consumer's UI inspection contract
after a launch smoke. Choose the smallest risk-based evidence matrix: the primary
affected route by default, plus an affected sheet, appearance variant, or large
Dynamic Type scenario only when that risk changed. For each selected scenario,
capture a screenshot, visually inspect the rendered image, and capture
`snapshot_ui` to verify semantic controls, labels, values, and scrollability.

For a non-UI change, run focused code tests only; do not require a launch smoke,
screenshots, visual inspection, or `snapshot_ui`. Do not repeat discovery,
stop/launch, or pre-fix captures after the cause is understood; retain post-fix
evidence and any artifact needed to explain a failure. Report manual-only checks
separately for user-visible changes.
