import SwiftUI

/// Applies a continuously time-driven digital glitch effect.
public struct GlitchEffectModifier: ViewModifier {
    private let intensity: Float
    @State private var startDate = Date()

    /// Creates a glitch effect with intensity from clean (`0`) to heavy (`1`).
    public init(intensity: Float) {
        self.intensity = intensity
    }

    /// Applies the shader with a documented horizontal sampling allowance.
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            content.layerShader(maxSampleOffset: CGSize(width: 30, height: 0)) { size in
                ShaderKitLibrary.library.glitchEffect(
                    .float2(size.width, size.height),
                    .float(Float(elapsed)),
                    .float(intensity)
                )
            }
        }
    }
}

public extension View {
    /// Applies a time-varying horizontal digital glitch.
    func glitchEffect(intensity: Float) -> some View {
        modifier(GlitchEffectModifier(intensity: intensity))
    }
}

#Preview {
    Text("Glitch")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.green)
        .glitchEffect(intensity: 0.8)
}
