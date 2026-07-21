---
name: swiftui-component-author
description: Use when creating or refactoring a reusable SwiftUI component. Do not use for business-specific screens, non-UI services, or design-token-only changes.
---

# SwiftUI component author

Create or refactor a **reusable** SwiftUI component in the **consumer workspace**. Do not implement business-specific screens or token-only design work with this skill.

## Workflow

1. **Confirm scope.** Name the responsibility, at least two plausible consumers, supported platforms, and the configuration surface (parameters, styles, sizes). Stop if the request is a one-off screen, feature flow, or design-token-only change — use the appropriate feature or `apple-design-system` skill instead.
2. **Inspect first.** Read existing design-system tokens, sibling components, and repository UI conventions. Prefer extending an existing component over forking a near-duplicate.
3. **Prefer native controls.** Use system controls and semantic configuration. Avoid custom chrome that reimplements buttons, lists, or navigation unless the product requires it and accessibility parity is planned.
4. **Own state explicitly.** Prefer initializer parameters and environment injection. Use native observation for shared app state. Do not introduce a view model without a state-ownership or testability reason written in the handoff.
5. **Accessibility baseline (required).** Support Dynamic Type, VoiceOver labels/traits/grouping, keyboard and focus order where the platform has them, sufficient contrast, Reduce Motion, Differentiate Without Color, and a descriptive label for every icon-only control. Touch targets must remain usable.
6. **Keep the public API small.** Expose only configuration the consumers need. Document defaults and non-obvious parameters. Prefer semantic style enums over raw colors/fonts when tokens exist.
7. **Ship a preview or example** that exercises primary configurations and at least one accessibility-sensitive case (for example large Dynamic Type or an empty state).
8. **Test what the component owns.** Focused tests for configuration logic, state transitions, and public API contracts. Do not claim VoiceOver or visual polish passed without evidence — list manual checks.

## Stop conditions

- Business-specific screen copy, navigation shell, or domain workflow → implement as a feature, not a “component.”
- Token or branding-only request → `apple-design-system`.
- Genuine iOS/macOS divergence in interaction → chain `ios-macos-platform-adaptation`.
- Planning-only request → deliver design + verification plan without writing product code.

## Verification

Use `swift-testing-verification` and XcodeBuildMCP for the affected consumer target. Build the component’s host target; run focused tests. When the component is shared UI, follow with `apple-accessibility-review` before calling reusable work complete. Report residual risk for untested platforms and manual-only a11y checks.

Inputs: reusable component requirement and consumers. Output: a small documented component, self-contained preview/example, focused tests, and relevant build result. For planning-only requests, provide the component design and verification plan without implementation.
