import SwiftUI

/// Applies a newspaper-style halftone conversion blended by progress.
public struct HalftoneModifier: ViewModifier {
    private let progress: Float
    private let dotSize: Float

    /// Creates a halftone effect with configurable blend progress and cell size.
    public init(progress: Float, dotSize: Float = 8) {
        self.progress = progress
        self.dotSize = dotSize
    }

    /// Applies the shader using the content's measured size.
    public func body(content: Content) -> some View {
        content.layerShader { size in
            ShaderKitLibrary.library.halftone(
                .float2(size.width, size.height),
                .float(dotSize),
                .float(progress)
            )
        }
    }
}

public extension View {
    /// Applies a halftone conversion blended from the source image.
    func halftone(progress: Float, dotSize: Float = 8) -> some View {
        modifier(HalftoneModifier(progress: progress, dotSize: dotSize))
    }
}

#Preview {
    Text("Dots")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.orange)
        .halftone(progress: 1)
}
