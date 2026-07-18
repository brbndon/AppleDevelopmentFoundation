# FoundationTasks

An iOS 17+ SwiftUI host app created with Xcode. It demonstrates local-package integration by using `DesignSystem` for semantic UI, `FormKit` for task-title validation, `NavigationKit` for app-owned routing, and `PersistenceKit` to create its SwiftData container. Its native tab bar separates active and completed tasks; Liquid Glass button styles automatically apply on iOS 26 and fall back to standard controls on earlier supported systems.

Open `FoundationTasks.xcodeproj` in Xcode and run the `FoundationTasks` scheme. The local package reference resolves to the `archive/` package root.
