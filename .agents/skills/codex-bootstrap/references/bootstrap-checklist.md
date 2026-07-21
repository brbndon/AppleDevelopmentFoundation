# Bootstrap checklist

Use during and after `$codex-bootstrap` in the **consumer workspace**.

## Intake

- [ ] Explicit consumer repository path confirmed
- [ ] Project-local `AGENTS.md` creation or modification authorization confirmed
- [ ] Platforms and minimum OS versions confirmed
- [ ] SwiftUI app vs package layout decided
- [ ] Primary navigation convention and peer destinations decided
- [ ] Design system reuse vs new minimal layer decided
- [ ] Planning-only vs implementation confirmed

## Consumer operating guidance

- [ ] Existing root and scoped `AGENTS.md` files inspected
- [ ] Existing consumer instructions preserved unless an explicit merge was authorized
- [ ] New guidance previewed from `assets/consumer-AGENTS.md.template` when applicable
- [ ] Project/workspace, scheme, configuration, platforms, deployment versions,
      iOS simulatorId and/or macOS destination notes, and repository-native check
      commands customized or left as explicit placeholders
- [ ] Apple verification policy knobs set or reviewed (XcodeBuildMCP CLI fallback
      and raw `xcodebuild` / `xcrun` / `simctl`: each `require-approval` |
      `allowed` | `denied`; keep template default `require-approval` unless the
      team authorized otherwise)
- [ ] Global `~/.codex/AGENTS.md` left untouched

## Structure

- [ ] `@main` app entry and root shell view exist
- [ ] Native tabs are used only for persistent peer destinations; system tab chrome is not recreated manually
- [ ] No code landed in AppleDevelopmentFoundation `archive/Sources/`
- [ ] Shared modules live in consumer repo only

## Skills applied (as needed)

- [ ] `apple-platform-planner` — broad scope
- [ ] `swiftui-tab-navigation` — native app-level tab shell when applicable
- [ ] `apple-design-system` — tokens and defaults
- [ ] `swiftui-component-author` — reusable components
- [ ] `ios-macos-platform-adaptation` — platform split
- [ ] Review skills after relevant code exists

## XcodeBuildMCP verification

- [ ] `session_show_defaults` called
- [ ] Project/workspace, scheme, configuration, and platform destination confirmed
- [ ] Platform branch followed (iOS simulator tools vs macOS `macos` workflow)
- [ ] iOS: exact `simulatorId`; no competing same-project simulator test process;
      `build_run_sim` / `test_sim` as applicable
- [ ] macOS: `macos` workflow enabled; `build_run_macos` and/or `test_macos` as
      applicable — not `test_sim` / ui-automation
- [ ] Tests run serially with parallel testing disabled by default (if present)
- [ ] Optional iOS-only: screenshot or view hierarchy confirms launch
- [ ] macOS: no screenshot/hierarchy required (ui-automation is iOS-only); if no
      tests yet, `test_macos` skip and residual risk reported
- [ ] If MCP was unavailable, fallback followed consumer policy enums (`allowed`,
      or `require-approval` with fresh approval for that step; never when `denied`);
      otherwise the task was reported blocked with policy values in force
- [ ] Any fallback preserved project/workspace, scheme, configuration, exact
      destination, serialized test scope, commands/tools, and residual risk

## Handoff

- [ ] Next skills listed for the user
- [ ] Consumer guidance reported as created, preserved, or proposed
- [ ] Failures reported with next actionable MCP tool call
- [ ] User reminded: archived package in skills repo is out of scope
