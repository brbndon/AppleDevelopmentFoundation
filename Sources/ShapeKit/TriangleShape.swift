import SwiftUI

/// An isosceles triangle outline intended for trim-based loader animation.
public struct TriangleShape: Shape {
    /// Creates a triangle that fits the proposed drawing rectangle.
    public init() {}

    /// Draws one continuous triangle outline with its base at 85% height.
    public func path(in rect: CGRect) -> Path {
        let baseY = rect.minY + rect.height * 0.85
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: baseY))
        path.addLine(to: CGPoint(x: rect.maxX, y: baseY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    TriangleShape()
        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineJoin: .round))
        .padding()
}
