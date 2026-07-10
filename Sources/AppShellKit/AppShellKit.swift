import AppFoundation
import DesignSystem
import NavigationKit
import SwiftUI

/// A generic application shell that adapts native navigation structure by platform.
public struct AdaptiveAppShell<Sidebar: View, Detail: View>: View {
    private let sidebar: Sidebar; private let detail: Detail
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) { self.sidebar = sidebar(); self.detail = detail() }
    public var body: some View {
        #if os(macOS)
        NavigationSplitView { List { sidebar } } detail: { detail }
        #else
        NavigationStack { detail }
        #endif
    }
}

public struct FoundationSettingsLink: View {
    private let title: LocalizedStringKey; private let action: () -> Void
    public init(_ title: LocalizedStringKey = "Settings", action: @escaping () -> Void) { self.title = title; self.action = action }
    public var body: some View { Button(title, systemImage: "gearshape", action: action) }
}
