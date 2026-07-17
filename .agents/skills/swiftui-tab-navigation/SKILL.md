---
name: swiftui-tab-navigation
description: Use when adding, replacing, or refactoring an app-level SwiftUI tab shell, including adopting the system Liquid Glass tab-bar appearance on iOS 26. Do not use for page-style TabView content, segmented controls, business-specific screen implementation, or navigation that has no peer destinations.
---

# SwiftUI tab navigation

Build primary navigation from native SwiftUI containers in the **consumer workspace**. Inspect repository guidance, deployment targets, root routing, existing deep links, tests, and platform conventions before editing.

## Workflow

1. Confirm that the destinations are persistent peers. Use `TabView` for peer app destinations; keep transient actions, onboarding steps, and drill-down destinations out of the tab bar.
2. Prefer the system tab container. On supported iOS versions, native tab chrome adopts the current system appearance, including Liquid Glass on iOS 26. Do not imitate it with `glassEffect`, materials, overlays, or a custom safe-area bar.
3. Keep loading, onboarding, unrecoverable failures, and other pre-content routing outside the tab shell. Give each tab its own `NavigationStack` when it owns drill-down navigation.
4. Add typed selection state only when programmatic tab changes, restoration, inspection destinations, or deep links require it. Preserve existing direct inspection and deep-link routes.
5. Use concise text plus SF Symbols in each tab label. Keep selection semantics and interaction native; apply only semantic app tinting.
6. If iOS and macOS need genuinely different primary-navigation conventions, invoke `ios-macos-platform-adaptation`; do not force an iOS tab bar onto a macOS app that calls for a sidebar, windows, or commands.
7. Read [references/native-tab-shell.md](references/native-tab-shell.md) when implementing the shell or updating UI automation.

## Verification

Use `swift-testing-verification` and XcodeBuildMCP with one exact target. Build and run, capture a screenshot or hierarchy on the newest supported runtime, exercise every tab and nested back path, and verify any minimum-OS fallback the project supports. Run affected XCTest or Maestro journeys after selector changes.

Inspect the runtime hierarchy before choosing UI-test selectors. SwiftUI creates the actual tab buttons; an accessibility identifier placed inside `.tabItem` may not propagate to those generated controls. Prefer an exposed stable identifier when present, otherwise use the visible accessibility label and scope XCTest queries to `tabBars`.

Inputs: an existing or requested primary navigation shell, its peer destinations, supported platforms, and current routing/tests. Output: a native tab shell in the consumer app, preserved routing behavior, updated navigation tests, and visual/build evidence on relevant runtimes.
