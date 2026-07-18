@testable import ShaderKit
import XCTest

final class ShaderKitTests: XCTestCase {
    @MainActor
    func testModifiersCanBeConstructed() {
        _ = BurnEffectModifier(progress: 1)
        _ = EmberRevealModifier(progress: 1)
        _ = PixelSnapModifier(progress: 1)
        _ = WaveRippleModifier(origin: .zero, progress: 1)
        _ = GlitchEffectModifier(intensity: 1)
        _ = ChromaticAberrationModifier(intensity: 1)
        _ = HalftoneModifier(progress: 1, dotSize: 8)
    }
}
