import SwiftUI

/// Applies a continuously animated ripple expanding from a supplied origin.
public struct WaveRippleModifier: ViewModifier {
    private let origin: CGPoint
    private let progress: Float
    @State private var startDate = Date()

    /// Creates a ripple effect. `origin` is expressed in the content's local coordinates.
    public init(origin: CGPoint, progress: Float) {
        self.origin = origin
        self.progress = progress
    }

    /// Applies the distortion shader with measured size and elapsed time.
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            content.distortionShader(maxSampleOffset: CGSize(width: 20, height: 20)) { size in
                ShaderKitLibrary.library.waveRipple(
                    .float2(size.width, size.height),
                    .float2(origin.x, origin.y),
                    .float(Float(elapsed)),
                    .float(progress)
                )
            }
        }
    }
}

public extension View {
    /// Applies a decaying wave ripple from `origin`.
    func waveRipple(origin: CGPoint, progress: Float) -> some View {
        modifier(WaveRippleModifier(origin: origin, progress: progress))
    }
}

#Preview {
    Text("Ripple")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.cyan)
        .waveRipple(origin: CGPoint(x: 60, y: 40), progress: 0.5)
}
