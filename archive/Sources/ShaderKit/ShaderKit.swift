import SwiftUI

/// Reusable SwiftUI view modifiers backed by stitchable Metal shaders.
public enum ShaderKit {}

enum ShaderKitLibrary {
    static let library = ShaderLibrary.bundle(Bundle.module)
}
