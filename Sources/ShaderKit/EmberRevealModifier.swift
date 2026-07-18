import SwiftUI

/// Applies a noisy reveal that expands from the center with an ember edge.
public struct EmberRevealModifier: ViewModifier {
    private let progress: Float

    /// Creates an ember reveal with progress from hidden (`0`) to visible (`1`).
    public init(progress: Float) {
        self.progress = progress
    }

    /// Applies the shader using the content's measured size.
    public func body(content: Content) -> some View {
        content.layerShader { size in
            ShaderKitLibrary.library.emberReveal(.float(progress), .float2(size.width, size.height))
        }
    }
}

public extension View {
    /// Applies a center-out ember reveal transition.
    func emberReveal(progress: Float) -> some View {
        modifier(EmberRevealModifier(progress: progress))
    }
}

#Preview {
    Text("Reveal")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.orange)
        .emberReveal(progress: 1)
}
