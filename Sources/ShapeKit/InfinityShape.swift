import SwiftUI

/// A scale-aware lemniscate path for loaders and trim-based reveals.
public struct InfinityShape: Shape {
    /// Creates an infinity path that fits the proposed drawing rectangle.
    public init() {}

    /// Draws two mirrored cubic lobes crossing at the center.
    public func path(in rect: CGRect) -> Path {
        let scale = min(rect.width / 200, rect.height / 144)
        let halfWidth = 100 * scale
        let halfHeight = 72 * scale
        let controlWidth = 200 * scale
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()
        path.move(to: CGPoint(x: center.x - halfWidth, y: center.y + halfHeight))
        path.addCurve(
            to: CGPoint(x: center.x - halfWidth, y: center.y - halfHeight),
            control1: CGPoint(x: center.x - controlWidth, y: center.y + halfHeight),
            control2: CGPoint(x: center.x - controlWidth, y: center.y - halfHeight)
        )
        path.addCurve(
            to: CGPoint(x: center.x + halfWidth, y: center.y + halfHeight),
            control1: CGPoint(x: center.x, y: center.y - halfHeight),
            control2: CGPoint(x: center.x, y: center.y + halfHeight)
        )
        path.addCurve(
            to: CGPoint(x: center.x + halfWidth, y: center.y - halfHeight),
            control1: CGPoint(x: center.x + controlWidth, y: center.y + halfHeight),
            control2: CGPoint(x: center.x + controlWidth, y: center.y - halfHeight)
        )
        path.addCurve(
            to: CGPoint(x: center.x - halfWidth, y: center.y + halfHeight),
            control1: CGPoint(x: center.x, y: center.y - halfHeight),
            control2: CGPoint(x: center.x, y: center.y + halfHeight)
        )
        return path
    }
}

#Preview {
    InfinityShape()
        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
        .padding()
}
