import AppFoundation
import SwiftUI

/// Semantic values used by components. Applications may apply a brand tint above this layer.
public enum FoundationTokens {
    public enum Spacing { public static let compact = 8.0; public static let standard = 12.0; public static let roomy = 20.0 }
    public enum Radius { public static let card = 16.0; public static let control = 10.0 }
    public enum ColorRole { public static let accent = Color.accentColor; public static let success = Color.green; public static let warning = Color.orange; public static let danger = Color.red }
}

public struct FoundationButton: View {
    private let title: LocalizedStringKey
    private let role: ButtonRole?
    private let action: () -> Void
    public init(_ title: LocalizedStringKey, role: ButtonRole? = nil, action: @escaping () -> Void) { self.title = title; self.role = role; self.action = action }
    public var body: some View { Button(title, role: role, action: action).buttonStyle(.borderedProminent).controlSize(.large) }
}

public struct FoundationCard<Content: View>: View {
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View { content.padding(FoundationTokens.Spacing.roomy).frame(maxWidth: .infinity, alignment: .leading).background(.regularMaterial, in: .rect(cornerRadius: FoundationTokens.Radius.card)).accessibilityElement(children: .contain) }
}

public struct SectionHeader: View {
    public let title: LocalizedStringKey
    public init(_ title: LocalizedStringKey) { self.title = title }
    public var body: some View { Text(title).font(.headline).foregroundStyle(.secondary).textCase(.uppercase) }
}

public struct StatusBadge: View {
    public enum Kind: Sendable { case neutral, success, warning, danger }
    public let title: LocalizedStringKey; public let kind: Kind
    public init(_ title: LocalizedStringKey, kind: Kind = .neutral) { self.title = title; self.kind = kind }
    private var color: Color { switch kind { case .neutral: .secondary; case .success: FoundationTokens.ColorRole.success; case .warning: FoundationTokens.ColorRole.warning; case .danger: FoundationTokens.ColorRole.danger } }
    public var body: some View { Label { Text(title) } icon: { Image(systemName: kind == .success ? "checkmark.circle.fill" : "circle.fill") }.font(.caption.weight(.semibold)).padding(.horizontal, 8).padding(.vertical, 5).foregroundStyle(color).background(color.opacity(0.14), in: Capsule()).accessibilityElement(children: .combine) }
}

public struct StateView: View {
    public enum State { case loading, empty(title: LocalizedStringKey, message: LocalizedStringKey), error(title: LocalizedStringKey, message: LocalizedStringKey) }
    public let state: State; public var retry: (() -> Void)?
    public init(_ state: State, retry: (() -> Void)? = nil) { self.state = state; self.retry = retry }
    public var body: some View { Group { switch state { case .loading: ProgressView("Loading"); case .empty(let title, let message): ContentUnavailableView(title, systemImage: "tray", description: Text(message)); case .error(let title, let message): ContentUnavailableView(title, systemImage: "exclamationmark.triangle", description: Text(message)); if let retry { Button("Try Again", action: retry) } } }.multilineTextAlignment(.center).padding() }
}

public struct IconOnlyButton: View {
    private let label: LocalizedStringKey; private let systemImage: String; private let action: () -> Void
    public init(_ label: LocalizedStringKey, systemImage: String, action: @escaping () -> Void) { self.label = label; self.systemImage = systemImage; self.action = action }
    public var body: some View { Button(action: action) { Image(systemName: systemImage).frame(minWidth: 28, minHeight: 28) }.accessibilityLabel(label).buttonStyle(.bordered) }
}

public struct PreviewSurface<Content: View>: View {
    private let content: Content
    public init(@ViewBuilder content: () -> Content) { self.content = content() }
    public var body: some View { content.padding().frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.secondary.opacity(0.08)) }
}
