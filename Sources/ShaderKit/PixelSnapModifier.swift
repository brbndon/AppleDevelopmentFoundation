import SwiftUI

/// Applies a pixelation effect that resolves as progress increases.
public struct PixelSnapModifier: ViewModifier {
    private let progress: Float

    /// Creates a pixel snap effect with progress from coarse (`0`) to clear (`1`).
    public init(progress: Float) {
        self.progress = progress
    }

    /// Applies the shader using the content's measured size.
    public func body(content: Content) -> some View {
        content.layerShader { size in
            ShaderKitLibrary.library.pixelSnap(.float(progress), .float2(size.width, size.height))
        }
    }
}

public extension View {
    /// Applies a resolving pixel-snap effect.
    func pixelSnap(progress: Float) -> some View {
        modifier(PixelSnapModifier(progress: progress))
    }
}

#Preview {
    Text("Pixel")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.indigo)
        .pixelSnap(progress: 1)
}
