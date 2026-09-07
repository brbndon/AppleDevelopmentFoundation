import SwiftUI

// MARK: - Drop-in template (portable)
//
// Source of truth: Templates/LiquidOrbLoader/DotMatrixLoader.swift (drop-in template).
// Soft-glow orb (no hard square clip). Micro uses economy draw (30 Hz, fewer path steps).
// Defaults use system colors — map tint to app tokens.
// See Templates/LiquidOrbLoader/README.md for layout, anti-box checklist, and wiring.
//

/// 3×3 dot-matrix loading animation.
///
/// Eight dots sweep a smooth highlight around the ring while the center plays
/// a distinct role. The ring highlight is a continuous cosine wave; the orb
/// center is a continuous liquid-glass morph (no discrete keyframe holds).
struct DotMatrixLoader: View {
    enum Center {
        case plain
        case pulse
        case symbol(String)
        case emoji(String)
        /// Continuous liquid-glass orb (primary loading mark).
        case orb
    }

    private static let ring: [SIMD2<Int>] = [
        .init(-1, -1), .init(0, -1), .init(1, -1),
        .init(1, 0),
        .init(1, 1), .init(0, 1), .init(-1, 1),
        .init(-1, 0)
    ]

    let center: Center
    var dotSize: CGFloat
    var spacing: CGFloat
    var period: TimeInterval
    var tint: Color
    var idleTint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(
        center: Center = .orb,
        dotSize: CGFloat = 12,
        spacing: CGFloat = 10,
        period: TimeInterval = 1.8,
        tint: Color = .accentColor,
        idleTint: Color = Color.secondary
    ) {
        self.center = center
        self.dotSize = dotSize
        self.spacing = spacing
        self.period = period
        self.tint = tint
        self.idleTint = idleTint
    }

    /// Recommended full-surface loading mark (generous air around the orb).
    static var feature: DotMatrixLoader {
        DotMatrixLoader(center: .orb, dotSize: 11, spacing: 28, period: 2.8)
    }

    /// Compact mark for cards, forms, and detail sections.
    static var compact: DotMatrixLoader {
        DotMatrixLoader(center: .orb, dotSize: 7, spacing: 14, period: 2.8)
    }

    /// Tiny mark for poster tiles and dense chrome (fits ~52pt compact posters).
    static var micro: DotMatrixLoader {
        DotMatrixLoader(center: .orb, dotSize: 4, spacing: 6, period: 2.8)
    }

    /// True for dense tile marks — cheaper timeline + simpler orb draw.
    private var isMicroOrb: Bool {
        if case .orb = center { return dotSize <= 4.5 }
        return false
    }

    /// Ring step. Orb mode pushes the ring out so the liquid mark has room.
    private var step: CGFloat {
        switch center {
        case .orb: max(dotSize + spacing, orbSize * 0.82)
        default: dotSize + spacing
        }
    }

    /// Scales with `dotSize` so `.feature` / `.compact` / `.micro` stay proportional.
    private var orbSize: CGFloat {
        switch center {
        case .orb: isMicroOrb ? max(dotSize * 4.5, 18) : max(dotSize * 5.2, 24)
        default: dotSize
        }
    }

    private var ringDotSize: CGFloat {
        switch center {
        case .orb: dotSize * 0.82
        default: dotSize
        }
    }

    private var layoutScale: CGFloat {
        isMicroOrb ? LiquidOrbMorph.microLayoutScale : LiquidOrbMorph.layoutScale
    }

    private var bounds: CGFloat {
        let ringExtent = step * 2 + ringDotSize
        switch center {
        // Canvas is oversized for soft glow falloff — must not clip to a square.
        case .orb: return max(ringExtent, orbSize * layoutScale)
        default: return ringExtent
        }
    }

    private var timelineInterval: TimeInterval {
        // Many micros can appear during progressive poster load; 30 Hz is enough there.
        isMicroOrb ? 1 / 30 : 1 / 60
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: timelineInterval, paused: reduceMotion)) { context in
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
            LiquidOrbMorph(time: time, size: orbSize, economy: isMicroOrb)
        }
    }

    private func wave(angle: Double, time: Double) -> Double {
        let cursor = time * 2 * .pi
        let delta = min(abs(angle - cursor), 2 * .pi - abs(angle - cursor))
        return 0.5 + 0.5 * cos(delta)
    }
}

// MARK: - Feature loading surface

/// Full-surface loading chrome used by `FeatureStateView` and the developer preview.
struct FeatureLoadingView: View {
    var title: String = "Loading"
    var detail: String = "Just a moment."
    var compact: Bool = false

    var body: some View {
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
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(detail)")
        .accessibilityIdentifier("feature.loading")
    }
}

/// Inline loading row for forms, detail panels, and banners (compact orb + message).
struct InlineLoadingRow: View {
    var message: String
    var micro: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            if micro {
                DotMatrixLoader.micro
            } else {
                DotMatrixLoader.compact
            }
            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message)
    }
}

// MARK: - Continuous liquid orb

/// Always-moving liquid-glass orb driven by overlapping harmonics.
///
/// Glow is drawn on an oversized canvas and never forced through a tight
/// square frame (that was the hard box edge). Stretch is baked into the path
/// instead of `scaleEffect`, which also clips.
private struct LiquidOrbMorph: View {
    let time: Double
    let size: CGFloat
    /// Fewer path samples + single blur for dense tile marks (multi-poster load).
    var economy: Bool = false

    /// Layout size / visual body size — room for blur falloff past the orb edge.
    static let layoutScale: CGFloat = 2.6
    /// Tighter pad for micro so the mark fits compact poster tiles (~52pt).
    static let microLayoutScale: CGFloat = 2.0

    private var canvasSize: CGFloat {
        size * (economy ? Self.microLayoutScale : Self.layoutScale)
    }

    var body: some View {
        let field = LiquidField.sample(at: time)
        let side = canvasSize
        Canvas { context, canvasSize in
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            // Body radius relative to the *logical* orb, not the padded canvas.
            let baseR = size * 0.36 * field.scale
            let blob = softBlobPath(center: center, baseRadius: baseR, field: field)

            // Soft ambient halo — large radial fill that fades to clear (no hard edge).
            let haloR = baseR * (economy ? 1.85 : 2.25)
            let halo = Path(ellipseIn: CGRect(
                x: center.x - haloR,
                y: center.y - haloR,
                width: haloR * 2,
                height: haloR * 2
            ))
            context.fill(
                halo,
                with: .radialGradient(
                    Gradient(stops: [
                        .init(color: Color(red: 0.45, green: 0.75, blue: 1.0).opacity(0.20 + 0.16 * field.glow), location: 0),
                        .init(color: Color(red: 0.40, green: 0.70, blue: 1.0).opacity(0.08), location: 0.42),
                        .init(color: .clear, location: 1)
                    ]),
                    center: center,
                    startRadius: 0,
                    endRadius: haloR
                )
            )

            // Blurred body glow — kept moderate so it dies out before the canvas edge.
            var glow = context
            glow.opacity = 0.28 + 0.30 * field.glow
            glow.addFilter(.blur(radius: baseR * (economy ? 0.40 : 0.55)))
            glow.fill(blob, with: .color(Color(red: 0.42, green: 0.74, blue: 1.0)))

            if !economy {
                var bloom = context
                bloom.opacity = 0.12 + 0.16 * field.glow
                bloom.addFilter(.blur(radius: baseR * 0.9))
                bloom.fill(blob, with: .color(Color(red: 0.55, green: 0.86, blue: 1.0)))
            }

            // Liquid body — gradient ends transparent so the rim doesn't print a hard cut.
            context.fill(
                blob,
                with: .radialGradient(
                    Gradient(stops: [
                        .init(color: Color(red: 0.97, green: 0.99, blue: 1.0).opacity(0.96), location: 0),
                        .init(color: Color(red: 0.62, green: 0.86, blue: 1.0).opacity(0.78), location: 0.32),
                        .init(color: Color(red: 0.36, green: 0.62, blue: 0.98).opacity(0.45), location: 0.66),
                        .init(color: Color(red: 0.30, green: 0.55, blue: 0.96).opacity(0.10), location: 0.88),
                        .init(color: .clear, location: 1)
                    ]),
                    center: center,
                    startRadius: 0,
                    endRadius: baseR * 1.12
                )
            )

            // Very soft rim
            context.stroke(
                blob,
                with: .color(Color.white.opacity(0.22 + 0.14 * field.glow)),
                lineWidth: max(0.7, baseR * 0.035)
            )

            let hx = center.x + CGFloat(cos(field.highlightAngle)) * baseR * 0.24 * field.squashX
            let hy = center.y + CGFloat(sin(field.highlightAngle)) * baseR * 0.18 * field.squashY
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
        .frame(width: side, height: side)
        // Feather any residual canvas-edge hardness so glow never reads as a box.
        .mask(
            RadialGradient(
                colors: [
                    .white,
                    .white,
                    .white.opacity(0.85),
                    .white.opacity(0.35),
                    .clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: side * 0.50
            )
        )
        .allowsHitTesting(false)
    }

    private func softBlobPath(center: CGPoint, baseRadius: CGFloat, field: LiquidField) -> Path {
        var path = Path()
        let steps = economy ? 64 : 160
        for i in 0...steps {
            let t = Double(i) / Double(steps)
            let theta = t * 2 * Double.pi
            let r = baseRadius * CGFloat(field.radius(at: theta))
            // Bake squash into the path (avoids scaleEffect clipping).
            let point = CGPoint(
                x: center.x + r * CGFloat(cos(theta)) * field.squashX,
                y: center.y + r * CGFloat(sin(theta)) * field.squashY
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

/// Continuous liquid field — every channel is a sum of sines, so nothing holds.
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
    FeatureLoadingView(detail: "Refreshing your library.")
}

#Preview("Orb mark") {
    DotMatrixLoader.feature
        .padding()
}

#Preview("Compact + inline") {
    VStack(spacing: 24) {
        DotMatrixLoader.compact
        InlineLoadingRow(message: "Searching…")
        InlineLoadingRow(message: "Loading posters…", micro: true)
    }
    .padding()
}
