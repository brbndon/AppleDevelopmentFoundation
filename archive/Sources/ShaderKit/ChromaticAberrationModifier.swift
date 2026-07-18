import SwiftUI

/// Applies radial RGB channel separation with a subtle animated pulse.
public struct ChromaticAberrationModifier: ViewModifier {
    private let intensity: Float
    @State private var startDate = Date()

    /// Creates a chromatic aberration effect measured in shader sample points.
    public init(intensity: Float) {
        self.intensity = intensity
    }

    /// Applies the shader with geometry-derived size and elapsed time.
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            content.layerShader(maxSampleOffset: CGSize(width: 50, height: 50)) { size in
                ShaderKitLibrary.library.chromaticAberration(
                    .float2(size.width, size.height),
                    .float(intensity),
                    .float(Float(elapsed))
                )
            }
        }
    }
}

public extension View {
    /// Applies radial chromatic aberration with the supplied intensity.
    func chromaticAberration(intensity: Float) -> some View {
        modifier(ChromaticAberrationModifier(intensity: intensity))
    }
}

#Preview {
    Text("RGB")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.pink)
        .chromaticAberration(intensity: 12)
}
