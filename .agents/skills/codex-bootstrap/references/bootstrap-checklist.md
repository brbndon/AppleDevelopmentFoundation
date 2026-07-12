# Bootstrap checklist

Use during and after `$codex-bootstrap` in the **consumer workspace**.

## Intake

- [ ] Platforms and minimum OS versions confirmed
- [ ] SwiftUI app vs package layout decided
- [ ] Design system reuse vs new minimal layer decided
- [ ] Planning-only vs implementation confirmed

## Structure

- [ ] `@main` app entry and root shell view exist
- [ ] No code landed in AppleDevelopmentFoundation `Sources/`
- [ ] Shared modules live in consumer repo only

## Skills applied (as needed)

- [ ] `apple-platform-planner` — broad scope
- [ ] `apple-design-system` — tokens and defaults
- [ ] `swiftui-component-author` — reusable components
- [ ] `ios-macos-platform-adaptation` — platform split
- [ ] Review skills after relevant code exists

## XcodeBuildMCP verification

- [ ] `session_show_defaults` called
- [ ] Project/scheme/simulator context confirmed
- [ ] Build succeeded on target platform
- [ ] Tests run (if present)
- [ ] Optional: screenshot or view hierarchy confirms launch

## Handoff

- [ ] Next skills listed for the user
- [ ] Failures reported with next actionable MCP tool call
- [ ] User reminded: archived package in skills repo is out of scope
