import SwiftUI

/// Applies a layer shader with the content's measured size as its first uniform.
public struct LayerShaderModifier: ViewModifier {
    private let maxSampleOffset: CGSize
    private let shader: (CGSize) -> Shader

    /// Creates a size-aware layer shader modifier.
    public init(
        maxSampleOffset: CGSize = .zero,
        shader: @escaping (CGSize) -> Shader
    ) {
        self.maxSampleOffset = maxSampleOffset
        self.shader = shader
    }

    /// Applies the shader inside `visualEffect`, preserving the view's layout.
    public func body(content: Content) -> some View {
        content.visualEffect { content, geometry in
            content.layerEffect(shader(geometry.size), maxSampleOffset: maxSampleOffset)
        }
    }
}

/// Applies a distortion shader with the content's measured size as its first uniform.
public struct DistortionShaderModifier: ViewModifier {
    private let maxSampleOffset: CGSize
    private let shader: (CGSize) -> Shader

    /// Creates a size-aware distortion shader modifier.
    public init(
        maxSampleOffset: CGSize,
        shader: @escaping (CGSize) -> Shader
    ) {
        self.maxSampleOffset = maxSampleOffset
        self.shader = shader
    }

    /// Applies the distortion inside `visualEffect`, preserving the view's layout.
    public func body(content: Content) -> some View {
        content.visualEffect { content, geometry in
            content.distortionEffect(shader(geometry.size), maxSampleOffset: maxSampleOffset)
        }
    }
}

public extension View {
    /// Applies a layer shader whose size uniform follows the content's geometry.
    func layerShader(
        maxSampleOffset: CGSize = .zero,
        shader: @escaping (CGSize) -> Shader
    ) -> some View {
        modifier(LayerShaderModifier(maxSampleOffset: maxSampleOffset, shader: shader))
    }

    /// Applies a distortion shader whose size uniform follows the content's geometry.
    func distortionShader(
        maxSampleOffset: CGSize,
        shader: @escaping (CGSize) -> Shader
    ) -> some View {
        modifier(DistortionShaderModifier(maxSampleOffset: maxSampleOffset, shader: shader))
    }
}
