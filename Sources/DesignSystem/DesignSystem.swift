import SwiftUI

/// Semantic values used by components. Applications may apply a brand tint above this layer.
public enum FoundationTokens {
    /// Semantic spacing values in points.
    public enum Spacing {
        /// Compact spacing for icon-label pairs and closely related controls.
        public static let compact = 8.0
        /// Standard spacing for related content.
        public static let standard = 12.0
        /// Generous spacing between distinct sections.
        public static let roomy = 20.0
    }

    /// Semantic corner-radius values in points.
    public enum Radius {
        /// Radius for cards and grouped surfaces.
        public static let card = 16.0
        /// Radius for compact controls such as buttons, fields, and badges.
        public static let control = 10.0
    }

    /// Semantic colors paired with textual and symbolic state cues.
    public enum ColorRole {
        /// The application accent role, useful for controls and branded emphasis.
        public static let accent = Color.accentColor
        /// A success color that must be paired with a non-color cue.
        public static let success = Color.green
        /// A warning color that must be paired with a non-color cue.
        public static let warning = Color.orange
        /// A danger color that must be paired with a non-color cue.
        public static let danger = Color.red
    }
}

/// A prominent native text button with a large control size.
public struct FoundationButton: View {
    private let title: LocalizedStringKey
    private let role: ButtonRole?
    private let action: () -> Void

    /// Creates a labeled button with an optional semantic role.
    public init(_ title: LocalizedStringKey, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.action = action
    }

    /// The prominent native button.
    public var body: some View {
        Button(title, role: role, action: action)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
    }
}

/// A material-backed content container that preserves accessibility children.
public struct FoundationCard<Content: View>: View {
    private let content: Content

    /// Creates a card around application-owned content.
    public init(@ViewBuilder content: () -> Content) { self.content = content() }

    /// The accessible card surface.
    public var body: some View {
        content
            .padding(FoundationTokens.Spacing.roomy)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: .rect(cornerRadius: FoundationTokens.Radius.card))
            .accessibilityElement(children: .contain)
    }
}

/// A semantic section heading using scalable system typography.
public struct SectionHeader: View {
    /// The heading text.
    public let title: LocalizedStringKey

    /// Creates a section heading.
    public init(_ title: LocalizedStringKey) { self.title = title }

    /// The styled heading.
    public var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }
}

/// A compact status label with a textual, symbolic, and color cue.
public struct StatusBadge: View {
    /// The semantic state presented by a badge.
    public enum Kind: Sendable, Equatable {
        /// A neutral state.
        case neutral
        /// A successful state.
        case success
        /// A warning state.
        case warning
        /// A dangerous or failed state.
        case danger
    }

    /// The visible status text.
    public let title: LocalizedStringKey

    /// The semantic status kind.
    public let kind: Kind

    /// Creates a status badge.
    public init(_ title: LocalizedStringKey, kind: Kind = .neutral) {
        self.title = title
        self.kind = kind
    }

    private var color: Color {
        switch kind {
        case .neutral: .secondary
        case .success: FoundationTokens.ColorRole.success
        case .warning: FoundationTokens.ColorRole.warning
        case .danger: FoundationTokens.ColorRole.danger
        }
    }

    /// The combined accessible status label.
    public var body: some View {
        Label {
            Text(title)
        } icon: {
            Image(systemName: kind.systemImage)
                .accessibilityHidden(true)
        }
        .font(.caption.weight(.semibold))
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .foregroundStyle(color)
        .background(color.opacity(0.14), in: Capsule())
        .accessibilityElement(children: .combine)
    }
}

extension StatusBadge.Kind {
    internal var systemImage: String {
        switch self {
        case .neutral: "info.circle.fill"
        case .success: "checkmark.circle.fill"
        case .warning: "exclamationmark.triangle.fill"
        case .danger: "xmark.octagon.fill"
        }
    }
}

/// A standard loading, empty, or failure surface.
public struct StateView: View {
    /// The semantic state to present.
    public enum State {
        /// A loading state.
        case loading
        /// An empty state with title and explanation.
        case empty(title: LocalizedStringKey, message: LocalizedStringKey)
        /// An error state with title and explanation.
        case error(title: LocalizedStringKey, message: LocalizedStringKey)
    }

    /// The state presented by this view.
    public let state: State

    /// An optional retry action, shown only for error states.
    public var retry: (() -> Void)?

    /// Creates a standard state surface.
    public init(_ state: State, retry: (() -> Void)? = nil) {
        self.state = state
        self.retry = retry
    }

    /// The state-specific content.
    public var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView("Loading")
            case .empty(let title, let message):
                ContentUnavailableView(title, systemImage: "tray", description: Text(message))
            case .error(let title, let message):
                ContentUnavailableView(title, systemImage: "exclamationmark.triangle", description: Text(message))
                if let retry { Button("Try Again", action: retry) }
            }
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

/// An icon-only button with an explicit accessible label and a minimum visual size.
public struct IconOnlyButton: View {
    private let label: LocalizedStringKey
    private let systemImage: String
    private let action: () -> Void

    /// Creates an icon-only button with an accessible label.
    public init(_ label: LocalizedStringKey, systemImage: String, action: @escaping () -> Void) {
        self.label = label
        self.systemImage = systemImage
        self.action = action
    }

    /// The labeled native button.
    public var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .frame(minWidth: 44, minHeight: 44)
        }
        .accessibilityLabel(label)
        .buttonStyle(.bordered)
    }
}

/// A neutral surface for previews and examples.
public struct PreviewSurface<Content: View>: View {
    private let content: Content

    /// Creates a neutral preview surface.
    public init(@ViewBuilder content: () -> Content) { self.content = content() }

    /// The preview layout.
    public var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary.opacity(0.08))
    }
}
