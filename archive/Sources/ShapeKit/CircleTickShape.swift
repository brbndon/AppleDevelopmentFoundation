import SwiftUI

/// A circle followed by a checkmark in one path for sequential trim reveals.
public struct CircleTickShape: Shape {
    /// Diameter of the circle subpath.
    public var circleSize: CGFloat
    /// Scale applied to the checkmark relative to its base geometry.
    public var scaleFactor: CGFloat

    /// Creates a circle-and-checkmark path.
    public init(circleSize: CGFloat = 60, scaleFactor: CGFloat = 0.3) {
        self.circleSize = circleSize
        self.scaleFactor = scaleFactor
    }

    /// Draws the circle subpath first, followed by the checkmark subpath.
    public func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        path.move(to: center)
        path.addEllipse(in: CGRect(
            x: center.x - circleSize / 2,
            y: center.y - circleSize / 2,
            width: circleSize,
            height: circleSize
        ))
        path.move(to: CGPoint(x: center.x - 38 * scaleFactor, y: center.y + 2 - scaleFactor))
        path.addLine(to: CGPoint(x: center.x - scaleFactor * 18, y: center.y + scaleFactor * 28))
        path.addLine(to: CGPoint(x: center.x + scaleFactor * 40, y: center.y - scaleFactor * 26))
        return path
    }
}

#Preview {
    CircleTickShape(circleSize: 64, scaleFactor: 0.34)
        .stroke(.green, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
        .padding()
}
