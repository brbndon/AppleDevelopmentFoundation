import SwiftUI
import DesignSystem

/// A premium, highly interactive glass slider that adapts dynamically to platform versions.
///
/// On iOS 26+, it utilizes native Liquid Glass rendering APIs (`.glassEffect()`, `GlassEffectContainer`, `.interactive()`).
/// On iOS 17-25, it falls back to a premium layout using `.ultraThinMaterial`.
public struct AppleGlassSlider: View {
    @Binding private var value: Double
    private let bounds: ClosedRange<Double>
    private let step: Double?
    private let label: String
    private let onEditingChanged: (Bool) -> Void

    @State private var isDragging = false

    /// Creates an AppleGlassSlider.
    /// - Parameters:
    ///   - value: The binding to the slider's value.
    ///   - bounds: The range of values. Defaults to `0...1`.
    ///   - step: The step increment value. Defaults to `nil`.
    ///   - label: An accessibility label describing the slider's purpose.
    ///   - onEditingChanged: Callback invoked when editing begins and ends.
    public init(
        value: Binding<Double>,
        in bounds: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        label: String,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._value = value
        self.bounds = bounds
        self.step = step
        self.label = label
        self.onEditingChanged = onEditingChanged
    }

    private var percentage: Double {
        let range = bounds.upperBound - bounds.lowerBound
        guard range > 0 else { return 0 }
        return (value - bounds.lowerBound) / range
    }

    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let trackHeight: CGFloat = 8
            let thumbSize: CGFloat = 28
            
            ZStack(alignment: .leading) {
                // Background Track
                trackBackgroundView()
                    .frame(height: trackHeight)
                    .frame(maxWidth: .infinity)
                
                // Active Track Fill
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: CGFloat(percentage) * width, height: trackHeight)
                
                // Thumb
                thumbView()
                    .offset(x: CGFloat(percentage) * width - (thumbSize / 2))
                    .contentShape(Rectangle()) // Expand touch area
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                if !isDragging {
                                    isDragging = true
                                    onEditingChanged(true)
                                }
                                updateValue(for: width, dragX: gesture.location.x)
                            }
                            .onEnded { _ in
                                isDragging = false
                                onEditingChanged(false)
                            }
                    )
            }
            .frame(height: 44) // Vertical touch target expansion
        }
        .frame(height: 44)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label)
        .accessibilityValue(Text(String(format: "%.0f%%", percentage * 100)))
        .accessibilityAdjustableAction { direction in
            let range = bounds.upperBound - bounds.lowerBound
            let delta = step ?? (range / 10.0)
            switch direction {
            case .increment:
                value = min(bounds.upperBound, value + delta)
            case .decrement:
                value = max(bounds.lowerBound, value - delta)
            @unknown default:
                break
            }
        }
    }

    private func updateValue(for width: CGFloat, dragX: CGFloat) {
        let percent = Double(max(0, min(1, dragX / width)))
        let rawValue = bounds.lowerBound + percent * (bounds.upperBound - bounds.lowerBound)
        
        let newValue: Double
        if let step = step {
            let steps = round((rawValue - bounds.lowerBound) / step)
            newValue = max(bounds.lowerBound, min(bounds.upperBound, bounds.lowerBound + steps * step))
        } else {
            newValue = max(bounds.lowerBound, min(bounds.upperBound, rawValue))
        }
        
        if value != newValue {
            value = newValue
        }
    }

    @ViewBuilder
    private func trackBackgroundView() -> some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .glassEffect()
            }
        } else {
            Capsule()
                .fill(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    private func thumbView() -> some View {
        if #available(iOS 26.0, *) {
            GlassEffectContainer {
                Circle()
                    .fill(Color.white)
                    .frame(width: 28, height: 28)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .glassEffect()
                    .interactive()
            }
        } else {
            Circle()
                .fill(Color.white)
                .frame(width: 28, height: 28)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                )
        }
    }
}

#Preview {
    PreviewSurface {
        VStack(spacing: 20) {
            AppleGlassSlider(
                value: .constant(0.4),
                in: 0...1,
                label: "Volume"
            )
            .padding()
        }
    }
}
