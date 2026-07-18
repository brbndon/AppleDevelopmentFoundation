import SwiftUI

/// A filled sine-wave surface for liquid loaders and progress masks.
///
/// Animate `curve` to translate the wave horizontally. The explicit
/// `animatableData` implementation ensures SwiftUI interpolates that phase.
public struct WaveFill: Shape, Animatable {
    /// Horizontal phase offset of the wave.
    public var curve: CGFloat
    /// Wave amplitude in points.
    public let curveHeight: CGFloat
    /// Frequency multiplier; larger values create more ripples.
    public let curveLength: CGFloat

    /// Creates a liquid wave shape.
    public init(curve: CGFloat, curveHeight: CGFloat, curveLength: CGFloat) {
        self.curve = curve
        self.curveHeight = curveHeight
        self.curveLength = curveLength
    }

    /// The phase value interpolated during animation.
    public var animatableData: CGFloat {
        get { curve }
        set { curve = newValue }
    }

    /// Draws the wave and closes it below the visible rectangle.
    public func path(in rect: CGRect) -> Path {
        guard rect.height > 0 else { return Path() }
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY * 2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * 2))
        for x in stride(from: rect.minX, through: rect.maxX, by: 1) {
            let relativeX = x - rect.minX
            let y = sin(((relativeX / rect.height) + curve) * curveLength * .pi)
                * curveHeight + rect.midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 2))
        return path
    }
}

#Preview {
    WaveFill(curve: 0.2, curveHeight: 8, curveLength: 3)
        .fill(.blue.opacity(0.65))
        .frame(width: 220, height: 100)
}
