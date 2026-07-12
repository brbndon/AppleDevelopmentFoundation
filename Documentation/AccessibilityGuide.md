# Accessibility Guide

> **Archived.** Historical accessibility reference only. See [ARCHIVE.md](../ARCHIVE.md). Do not expand this package unless explicitly asked.

All reusable components must use system text styles or scalable metrics, semantic colors plus non-color status cues, native `Button`s for actions, and clear labels for icon-only controls. `IconOnlyButton` provides a 44-point minimum visual target; callers must preserve adequate surrounding hit area when composing custom controls. `StatusBadge` combines text, a distinct decorative symbol, and color; `FoundationCard` contains rather than collapses interactive descendants; `FeedbackBanner` retains a separately reachable dismissal button; `FlowContainer` exposes a labelled percentage progress value.

Review VoiceOver grouping/order, text at accessibility sizes, full keyboard access and focus on macOS, iOS touch targets, dark appearance, Increased Contrast, Differentiate Without Color, Reduce Motion, and pointer/hover behavior. XCTest cannot prove these SwiftUI semantics in this package: review the executable examples on both platforms, including accessibility text sizes and keyboard-only macOS navigation, before release. Do not hide meaningful images from assistive technologies.
