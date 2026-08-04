import SwiftUI

// MARK: - Drop-in template (portable)
//
// Source of truth for the pattern: Harborlight DotMatrixLoader + FeatureLoadingView.
// Defaults use system colors so this file has no app-specific design-system dependency.
// Map `tint` / `idleTint` to your tokens when integrating.

/// 3×3 dot-matrix loading animation.
///
/// Eight dots sweep a smooth highlight around the ring. The orb center is a
/// continuous liquid-glass morph driven by overlapping harmonics (no keyframe holds).
public struct DotMatrixLoader: View {
    public enum Center {
        case plain
        case pulse
        case symbol(String)
        case emoji(String)
        /// Continuous liquid-glass orb (recommended full-surface loading mark).
        case orb
    }

    private static let ring: [SIMD2<Int>] = [
        .init(-1, -1), .init(0, -1), .init(1, -1),
        .init(1, 0),
        .init(1, 1), .init(0, 1), .init(-1, 1),
        .init(-1, 0)
    ]

    public let center: Center
    public var dotSize: CGFloat
    public var spacing: CGFloat
    public var period: TimeInterval
    public var tint: Color
    public var idleTint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        center: Center = .pulse,
        dotSize: CGFloat = 12,
        spacing: CGFloat = 10,
        period: TimeInterval = 1.8,
        tint: Color = .accentColor,
        idleTint: Color = .secondary
    ) {
        self.center = center
        self.dotSize = dotSize
        self.spacing = spacing
        self.period = period
        self.tint = tint
        self.idleTint = idleTint
    }

    /// Full-surface loading mark (generous air around the orb).
    public static var feature: DotMatrixLoader {
        DotMatrixLoader(center: .orb, dotSize: 11, spacing: 28, period: 2.8)
    }

    /// Compact mark for cards and inline chrome.
    public static var compact: DotMatrixLoader {
        DotMatrixLoader(center: .orb, dotSize: 8, spacing: 16, period: 2.8)
    }

    private var step: CGFloat {
        switch center {
        case .orb: max(dotSize + spacing, orbSize * 0.82)
        default: dotSize + spacing
        }
    }

    private var orbSize: CGFloat {
        switch center {
        case .orb: max(dotSize * 4.4, 58)
        default: dotSize
        }
    }

    private var ringDotSize: CGFloat {
        switch center {
        case .orb: dotSize * 0.82
        default: dotSize
        }
    }

    private var bounds: CGFloat {
        let ringExtent = step * 2 + ringDotSize
        switch center {
        case .orb: return max(ringExtent, orbSize * 1.35)
        default: return ringExtent
        }
    }

    public var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 60, paused: reduceMotion)) { context in
            let time = reduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate / period
            ZStack {
                ForEach(Array(Self.ring.enumerated()), id: \.offset) { index, coord in
                    ringDot(at: coord, index: index, time: time)
                }
                centerDot(time: time)
            }
            .frame(width: bounds, height: bounds)
            .accessibilityLabel("Loading")
            .accessibilityRemoveTraits(.isImage)
        }
    }

    private func ringDot(at coord: SIMD2<Int>, index: Int, time: Double) -> some View {
        let intensity = wave(angle: (Double(index) / Double(Self.ring.count)) * 2 * .pi, time: time)
        let size = ringDotSize
        return Circle()
            .fill(tint)
            .frame(width: size, height: size)
            .scaleEffect(0.82 + 0.32 * intensity)
            .opacity(0.28 + 0.72 * intensity)
            .offset(x: CGFloat(coord.x) * step, y: CGFloat(coord.y) * step)
    }

    @ViewBuilder
    private func centerDot(time: Double) -> some View {
        let breath = 1 + 0.28 * (0.5 + 0.5 * cos(2 * .pi * time + .pi))
        let tilt = sin(2 * .pi * time) * 10
        switch center {
        case .plain:
            Circle()
                .fill(idleTint)
                .frame(width: dotSize, height: dotSize)
                .scaleEffect(1 + 0.15 * (breath - 1))
        case .pulse:
            Circle()
                .fill(tint)
                .frame(width: dotSize, height: dotSize)
                .scaleEffect(breath)
        case .symbol(let name):
            Image(systemName: name)
                .font(.system(size: dotSize * 1.15, weight: .semibold))
                .foregroundStyle(tint)
                .scaleEffect(breath)
                .rotationEffect(.degrees(tilt))
        case .emoji(let character):
            Text(character)
                .font(.system(size: dotSize * 1.35))
                .scaleEffect(breath)
                .rotationEffect(.degrees(tilt))
        case .orb:
            LiquidOrbMorph(time: time, size: orbSize)
        }
    }

    private func wave(angle: Double, time: Double) -> Double {
        let cursor = time * 2 * .pi
        let delta = min(abs(angle - cursor), 2 * .pi - abs(angle - cursor))
        return 0.5 + 0.5 * cos(delta)
    }
}

// MARK: - Feature loading surface

/// Full-surface loading chrome: liquid orb + title + detail.
public struct FeatureLoadingView: View {
    public var title: String
    public var detail: String
    public var compact: Bool

    public init(
        title: String = "Loading",
        detail: String = "Refreshing…",
        compact: Bool = false
    ) {
        self.title = title
        self.detail = detail
        self.compact = compact
    }

    public var body: some View {
        VStack(spacing: 24) {
            if compact {
                DotMatrixLoader.compact
            } else {
                DotMatrixLoader.feature
            }
            VStack(spacing: 10) {
                Text(title)
                    .font(.title3.weight(.semibold))
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(detail)")
    }
}

// MARK: - Continuous liquid orb

private struct LiquidOrbMorph: View {
    let time: Double
    let size: CGFloat

    private var canvasSize: CGFloat { size * 1.55 }

    var body: some View {
        let field = LiquidField.sample(at: time)
        Canvas { context, canvasSize in
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let logical = min(canvasSize.width, canvasSize.height) / 1.55
            let baseR = logical * 0.36 * field.scale
            let blob = softBlobPath(center: center, baseRadius: baseR, field: field)

            var glow = context
            glow.opacity = 0.28 + 0.36 * field.glow
            glow.addFilter(.blur(radius: baseR * (0.55 + 0.15 * field.glow)))
            glow.fill(blob, with: .color(Color(red: 0.40, green: 0.72, blue: 1.0)))

            var bloom = context
            bloom.opacity = 0.16 + 0.20 * field.glow
            bloom.addFilter(.blur(radius: baseR * 0.85))
            bloom.fill(blob, with: .color(Color(red: 0.55, green: 0.85, blue: 1.0)))

            context.fill(
                blob,
                with: .radialGradient(
                    Gradient(stops: [
                        .init(color: Color(red: 0.97, green: 0.99, blue: 1.0).opacity(0.96), location: 0),
                        .init(color: Color(red: 0.62, green: 0.86, blue: 1.0).opacity(0.78), location: 0.34),
                        .init(color: Color(red: 0.36, green: 0.62, blue: 0.98).opacity(0.52), location: 0.74),
                        .init(color: Color(red: 0.28, green: 0.50, blue: 0.96).opacity(0.22), location: 1)
                    ]),
                    center: center,
                    startRadius: 0,
                    endRadius: baseR * 1.5
                )
            )

            context.stroke(
                blob,
                with: .linearGradient(
                    Gradient(colors: [
                        Color.white.opacity(0.65),
                        Color.white.opacity(0.12),
                        Color(red: 0.55, green: 0.82, blue: 1.0).opacity(0.40)
                    ]),
                    startPoint: CGPoint(x: center.x - baseR, y: center.y - baseR),
                    endPoint: CGPoint(x: center.x + baseR, y: center.y + baseR)
                ),
                lineWidth: max(0.9, baseR * 0.05)
            )

            let hx = center.x + CGFloat(cos(field.highlightAngle)) * baseR * 0.24
            let hy = center.y + CGFloat(sin(field.highlightAngle)) * baseR * 0.18
            let highlightR = baseR * (0.30 + 0.08 * field.glow)
            let highlight = Path(ellipseIn: CGRect(
                x: hx - highlightR,
                y: hy - highlightR * 0.7,
                width: highlightR * 2,
                height: highlightR * 1.4
            ))
            context.blendMode = .plusLighter
            context.fill(
                highlight,
                with: .radialGradient(
                    Gradient(colors: [
                        Color.white.opacity(0.50 + 0.28 * field.glow),
                        Color.white.opacity(0.06),
                        .clear
                    ]),
                    center: CGPoint(x: hx, y: hy),
                    startRadius: 0,
                    endRadius: highlightR * 1.55
                )
            )

            let coreR = baseR * (0.18 + 0.12 * field.glow)
            let core = Path(ellipseIn: CGRect(
                x: center.x - coreR,
                y: center.y - coreR,
                width: coreR * 2,
                height: coreR * 2
            ))
            context.fill(
                core,
                with: .radialGradient(
                    Gradient(colors: [
                        Color.white.opacity(0.90),
                        Color(red: 0.70, green: 0.92, blue: 1.0).opacity(0.38),
                        .clear
                    ]),
                    center: center,
                    startRadius: 0,
                    endRadius: coreR * 1.7
                )
            )
        }
        .frame(width: canvasSize, height: canvasSize)
        .scaleEffect(x: field.squashX, y: field.squashY)
        .frame(width: size, height: size)
    }

    private func softBlobPath(center: CGPoint, baseRadius: CGFloat, field: LiquidField) -> Path {
        var path = Path()
        let steps = 160
        for i in 0...steps {
            let t = Double(i) / Double(steps)
            let theta = t * 2 * Double.pi
            let r = baseRadius * CGFloat(field.radius(at: theta))
            let point = CGPoint(
                x: center.x + r * CGFloat(cos(theta)),
                y: center.y + r * CGFloat(sin(theta))
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

private struct LiquidField {
    var lobe: Double
    var lobePhase: Double
    var clover: Double
    var wobble: Double
    var wobblePhase: Double
    var scale: Double
    var glow: Double
    var squashX: CGFloat
    var squashY: CGFloat
    var highlightAngle: Double

    func radius(at theta: Double) -> Double {
        let peanut = lobe * cos(2 * theta + lobePhase)
        let petals = clover * cos(4 * theta + lobePhase * 0.55)
        let ripple = wobble * cos(3 * theta + wobblePhase)
        let shimmer = 0.035 * cos(5 * theta - lobePhase * 1.3)
        let fine = 0.018 * cos(7 * theta + wobblePhase * 0.6)
        return max(0.32, 1 + peanut + petals + ripple + shimmer + fine)
    }

    static func sample(at time: Double) -> LiquidField {
        let ω = time * 2 * Double.pi
        let lobePhase = ω * 0.55 + 0.28 * sin(ω * 0.45) + 0.08 * sin(ω * 1.1)
        let elongate = 0.5 + 0.5 * cos(ω * 0.9 + 0.2)
        let puffy = 0.5 + 0.5 * sin(ω * 0.9 + 0.9)
        let lobe = 0.18 + 0.22 * elongate - 0.06 * puffy
        let clover = 0.05 + 0.18 * puffy * puffy + 0.04 * sin(ω * 1.4)
        let wobble = 0.05 + 0.07 * (0.5 + 0.5 * sin(ω * 1.35 + 0.5))
        let wobblePhase = ω * 1.85 + 0.3 * sin(ω * 0.6)
        let scale = 1.0
            + 0.08 * sin(ω * 0.85 + 0.4)
            + 0.045 * sin(ω * 1.7 + 1.2)
            + 0.02 * sin(ω * 2.6)
        let glow = 0.40 + 0.34 * puffy + 0.14 * sin(ω * 1.6 + 0.7) + 0.08 * sin(ω * 0.5)
        let stretch = 0.05 * cos(ω * 0.9) + 0.02 * sin(ω * 1.8)
        let squashX = CGFloat(1 + stretch * cos(lobePhase))
        let squashY = CGFloat(1 + stretch * sin(lobePhase))
        let highlightAngle = ω * 0.9 + 0.55 * sin(ω * 0.65)

        return LiquidField(
            lobe: lobe,
            lobePhase: lobePhase,
            clover: clover,
            wobble: wobble,
            wobblePhase: wobblePhase,
            scale: scale,
            glow: min(1, max(0, glow)),
            squashX: squashX,
            squashY: squashY,
            highlightAngle: highlightAngle
        )
    }
}

#Preview("Feature loading") {
    FeatureLoadingView()
}

#Preview("Orb mark") {
    DotMatrixLoader.feature
        .padding()
}
