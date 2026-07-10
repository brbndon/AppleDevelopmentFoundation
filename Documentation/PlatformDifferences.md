# Platform Differences

Use `NavigationStack` for iOS and `NavigationSplitView` for the macOS shell. Put file panels, PhotosPicker, full-screen covers, commands, inspectors, and window behavior in small `#if os(iOS)` / `#if os(macOS)` extensions rather than branching an entire shared view. iOS prioritizes touch targets and compact presentations; macOS prioritizes keyboard, commands, sidebar/detail, hover, and windows. Verify both platforms whenever a public UI behavior differs.
