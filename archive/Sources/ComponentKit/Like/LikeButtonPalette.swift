import SwiftUI

/// Colors used by `LikeButton`, kept separate so the animation is brand-neutral.
public struct LikeButtonPalette: Sendable, Equatable {
    /// Heart highlight color.
    public var heart: Color
    /// Heart shadow/deep color.
    public var heartDeep: Color
    /// Top background color.
    public var backgroundTop: Color
    /// Bottom background color.
    public var backgroundBottom: Color
    /// Particle colors cycled through the burst.
    public var particles: [Color]

    /// Creates a like-button palette.
    public init(
        heart: Color,
        heartDeep: Color,
        backgroundTop: Color,
        backgroundBottom: Color,
        particles: [Color]
    ) {
        self.heart = heart
        self.heartDeep = heartDeep
        self.backgroundTop = backgroundTop
        self.backgroundBottom = backgroundBottom
        self.particles = particles
    }

    /// A neutral warm palette suitable for previews and prototypes.
    public static let `default` = LikeButtonPalette(
        heart: .pink,
        heartDeep: .red,
        backgroundTop: Color(hex: "29111A"),
        backgroundBottom: Color(hex: "521C32"),
        particles: [.pink, .orange, .red, .white]
    )
}
