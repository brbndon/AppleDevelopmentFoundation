import SwiftUI

/// Applies a continuously time-driven noisy burn-away transition.
public struct BurnEffectModifier: ViewModifier {
    private let progress: Double
    @State private var startDate = Date()

    /// Creates a burn effect with progress from fully visible (`1`) to removed (`0`).
    public init(progress: Double) {
        self.progress = progress
    }

    /// Applies the burn shader with geometry-derived size and elapsed time.
    public func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            content.layerShader { size in
                ShaderKitLibrary.library.burnEffect(
                    .float2(size.width, size.height),
                    .float(Float(progress)),
                    .float(Float(elapsed))
                )
            }
        }
    }
}

public extension View {
    /// Applies a noisy burn-away effect; `progress` is typically animated from `1` to `0`.
    func burnEffect(progress: Double) -> some View {
        modifier(BurnEffectModifier(progress: progress))
    }
}

#Preview {
    Text("Burn")
        .font(.largeTitle.bold())
        .padding(40)
        .background(.orange)
        .burnEffect(progress: 1)
}
