import SwiftUI

/// An animatable download arrow that can pinch its head and stretch its shaft.
///
/// Animate `animatableX` and `lineDifference` together to morph the arrow into
/// a falling or compressed state.
public struct DownloadArrowShape: Shape {
    /// Base dimension used for shaft and head geometry.
    public let lineWidth: CGFloat
    /// Horizontal inset applied to both arrowhead strokes.
    public var animatableX: CGFloat
    /// Vertical extension applied to the top of the shaft.
    public var lineDifference: CGFloat

    /// Creates an animatable download arrow.
    public init(lineWidth: CGFloat, animatableX: CGFloat = 0, lineDifference: CGFloat = 0) {
        self.lineWidth = lineWidth
        self.animatableX = animatableX
        self.lineDifference = lineDifference
    }

    /// The paired morph values interpolated by SwiftUI.
    public var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(animatableX, lineDifference) }
        set {
            animatableX = newValue.first
            lineDifference = newValue.second
        }
    }

    /// Draws the shaft and two diagonal arrowhead strokes.
    public func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        path.move(to: CGPoint(x: center.x, y: center.y - lineWidth / 2 + lineDifference))
        path.addLine(to: CGPoint(x: center.x, y: center.y + lineWidth / 2))
        path.addLine(to: CGPoint(
            x: center.x - lineWidth / 3 + animatableX,
            y: center.y - 45 + lineWidth / 2 + animatableX
        ))
        path.move(to: CGPoint(x: center.x, y: center.y + lineWidth / 2))
        path.addLine(to: CGPoint(
            x: center.x + lineWidth / 3 - animatableX,
            y: center.y - 45 + lineWidth / 2 + animatableX
        ))
        return path
    }
}

#Preview {
    DownloadArrowShape(lineWidth: 72)
        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
        .frame(width: 140, height: 140)
}
