import AppFoundation
import DesignSystem
import Observation
import SwiftUI

public struct FeedbackMessage: Identifiable, Equatable, Sendable {
    public enum Kind: Sendable { case success, warning, error }
    public let id: UUID; public let kind: Kind; public let text: String
    public init(kind: Kind, text: String) { id = UUID(); self.kind = kind; self.text = text }
}

@MainActor @Observable public final class FeedbackCenter {
    public private(set) var message: FeedbackMessage?
    public init() {}
    public func show(_ message: FeedbackMessage) { self.message = message }
    public func dismiss() { message = nil }
}

public struct FeedbackBanner: View {
    public let message: FeedbackMessage; public var dismiss: (() -> Void)?
    public init(message: FeedbackMessage, dismiss: (() -> Void)? = nil) { self.message = message; self.dismiss = dismiss }
    private var badgeKind: StatusBadge.Kind { switch message.kind { case .success: .success; case .warning: .warning; case .error: .danger } }
    public var body: some View { FoundationCard { HStack { StatusBadge(message.kind == .success ? "Success" : message.kind == .warning ? "Notice" : "Error", kind: badgeKind); Text(message.text); Spacer(); if let dismiss { IconOnlyButton("Dismiss", systemImage: "xmark", action: dismiss) } } }.accessibilityElement(children: .combine) }
}
