import DesignSystem
import SwiftUI

/// The visible lifecycle phase of a download button.
public enum DownloadPhase: Sendable, Equatable {
    /// The button is ready to start.
    case idle
    /// The button is displaying progress.
    case downloading
    /// The button is displaying completion.
    case completed
}

/// Customizable visual values for the download button's three panels.
public struct DownloadButtonStyle: Sendable {
    /// Button width in points.
    public var width: CGFloat
    /// Button height in points.
    public var height: CGFloat
    /// Panel corner radius in points.
    public var cornerRadius: CGFloat
    /// Idle panel background.
    public var idleColor: Color
    /// Downloading panel background.
    public var downloadingColor: Color
    /// Completed panel background.
    public var completedColor: Color
    /// Text and icon color used by the panels.
    public var foregroundColor: Color
    /// Progress stroke color.
    public var progressColor: Color
    /// Default duration for each slot-panel transition.
    public var transitionDuration: TimeInterval
    /// Duration of the simulated progress phase.
    public var progressDuration: TimeInterval
    /// Duration for which the completed panel remains visible.
    public var completedDuration: TimeInterval

    /// Creates a configurable download button style.
    public init(
        width: CGFloat = 320,
        height: CGFloat = 76,
        cornerRadius: CGFloat = 12,
        idleColor: Color = .primary,
        downloadingColor: Color = Color(hex: "128C7E"),
        completedColor: Color = Color(hex: "2878F0"),
        foregroundColor: Color = .white,
        progressColor: Color = Color(hex: "25D366"),
        transitionDuration: TimeInterval = 0.35,
        progressDuration: TimeInterval = 3.35,
        completedDuration: TimeInterval = 2.5
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.idleColor = idleColor
        self.downloadingColor = downloadingColor
        self.completedColor = completedColor
        self.foregroundColor = foregroundColor
        self.progressColor = progressColor
        self.transitionDuration = transitionDuration
        self.progressDuration = progressDuration
        self.completedDuration = completedDuration
    }
}
