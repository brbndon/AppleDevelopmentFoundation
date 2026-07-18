# Platform Differences

> **Archived.** Historical platform differences reference only. See the [archive README](../README.md). Do not expand this package unless explicitly asked.

`AdaptiveAppShell` uses `NavigationSplitView` so its sidebar is never silently discarded; SwiftUI adapts it to the available iOS and macOS space. Applications choose a `NavigationStack` when that is the appropriate iOS-only presentation. Put file panels, PhotosPicker, full-screen covers, commands, inspectors, and window behavior in small `#if os(iOS)` / `#if os(macOS)` extensions rather than branching an entire shared view. iOS prioritizes 44-point touch targets and compact presentations; macOS prioritizes keyboard, commands, sidebar/detail, hover, and windows. Verify both platforms whenever a public UI behavior differs.
