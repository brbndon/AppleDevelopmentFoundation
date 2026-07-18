import SwiftUI

/// A generic application shell that adapts native navigation structure by platform.
public struct AdaptiveAppShell<Sidebar: View, Detail: View>: View {
    private let sidebar: Sidebar
    private let detail: Detail

    /// Creates a shell with application-owned sidebar and detail content.
    public init(
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder detail: () -> Detail
    ) {
        self.sidebar = sidebar()
        self.detail = detail()
    }

    /// A split view that adapts its sidebar presentation to each platform's available space.
    public var body: some View {
        NavigationSplitView { List { sidebar } } detail: { detail }
    }
}

/// A labeled settings trigger for application-owned settings presentation.
public struct FoundationSettingsLink: View {
    private let title: LocalizedStringKey
    private let action: () -> Void

    /// Creates a native settings button with an accessible text label.
    public init(_ title: LocalizedStringKey = "Settings", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    /// The settings button.
    public var body: some View { Button(title, systemImage: "gearshape", action: action) }
}
