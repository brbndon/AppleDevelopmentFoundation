import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

/// Imperative haptic helpers for UIKit-backed interactions.
///
/// SwiftUI controls should generally prefer `.sensoryFeedback(_:trigger:)`.
/// Use this type when feedback is driven by a UIKit gesture, delegate, or
/// another event that does not have a natural SwiftUI state trigger.
public enum ADFHaptics {
    /// Notification feedback categories.
    public enum NotificationFeedbackType: Sendable {
        case success
        case info
        case failure
    }

    /// Impact feedback weights.
    public enum ImpactFeedbackType: Sendable {
        case light
        case medium
        case heavy
    }

    /// Plays notification feedback when UIKit is available.
    public static func notification(_ type: NotificationFeedbackType) {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        switch type {
        case .success: generator.notificationOccurred(.success)
        case .info: generator.notificationOccurred(.warning)
        case .failure: generator.notificationOccurred(.error)
        }
        #endif
    }

    /// Plays selection feedback when UIKit is available.
    public static func selection() {
        #if canImport(UIKit)
        UISelectionFeedbackGenerator().selectionChanged()
        #endif
    }

    /// Plays impact feedback when UIKit is available.
    public static func impact(_ type: ImpactFeedbackType) {
        #if canImport(UIKit)
        let style: UIImpactFeedbackGenerator.FeedbackStyle
        switch type {
        case .light: style = .light
        case .medium: style = .medium
        case .heavy: style = .heavy
        }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
}
