import DesignSystem
import Observation
import SwiftUI

/// A short user-facing feedback message.
public struct FeedbackMessage: Identifiable, Equatable, Sendable {
    /// The semantic feedback kind.
    public enum Kind: Sendable, Equatable {
        /// Indicates that an operation succeeded.
        case success
        /// Indicates a non-fatal condition.
        case warning
        /// Indicates an operation failed.
        case error
    }

    /// A newly generated identifier for this message.
    public let id: UUID

    /// The presentation kind.
    public let kind: Kind

    /// Application-owned, user-presentable text that must not contain private diagnostics.
    public let text: String

    /// Creates a feedback message.
    public init(kind: Kind, text: String) {
        id = UUID()
        self.kind = kind
        self.text = text
    }
}

/// Main-actor-owned state for displaying one feedback message.
@MainActor @Observable public final class FeedbackCenter {
    /// The currently visible message, if any.
    public private(set) var message: FeedbackMessage?

    /// Creates a feedback center with no message.
    public init() {}

    /// Replaces the visible message.
    public func show(_ message: FeedbackMessage) { self.message = message }

    /// Clears the visible message.
    public func dismiss() { message = nil }
}

/// An accessible banner for a user-facing feedback message.
public struct FeedbackBanner: View {
    /// The message displayed by this banner.
    public let message: FeedbackMessage

    /// An optional application-owned dismissal action.
    public var dismiss: (() -> Void)?

    /// Creates a banner for `message`.
    public init(message: FeedbackMessage, dismiss: (() -> Void)? = nil) {
        self.message = message
        self.dismiss = dismiss
    }

    private var badgeKind: StatusBadge.Kind {
        switch message.kind {
        case .success: .success
        case .warning: .warning
        case .error: .danger
        }
    }

    /// The accessible banner layout.
    public var body: some View {
        FoundationCard {
            HStack {
                StatusBadge(
                    message.kind == .success ? "Success" : message.kind == .warning ? "Notice" : "Error",
                    kind: badgeKind
                )
                Text(message.text)
                Spacer()
                if let dismiss {
                    IconOnlyButton("Dismiss", systemImage: "xmark", action: dismiss)
                }
            }
        }
        .accessibilityElement(children: .contain)
    }
}
