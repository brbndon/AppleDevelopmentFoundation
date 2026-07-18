import SwiftUI

/// A timer-free celebratory like control with a heart pop, burst, ring, and +1 bubble.
public struct LikeButton: View {
    @Binding private var isLiked: Bool
    private let palette: LikeButtonPalette
    private let particleCount: Int
    private let burstRadius: CGFloat
    private let onLike: (() -> Void)?
    @State private var heartScale: CGFloat = 1
    @State private var isBursting = false
    @State private var burstProgress: CGFloat = 0
    @State private var showPlusOne = false
    @State private var plusOneProgress: CGFloat = 0

    /// Creates a configurable like control.
    public init(
        isLiked: Binding<Bool>,
        palette: LikeButtonPalette = .default,
        particleCount: Int = 14,
        burstRadius: CGFloat = 150,
        onLike: (() -> Void)? = nil
    ) {
        _isLiked = isLiked
        self.palette = palette
        self.particleCount = max(0, particleCount)
        self.burstRadius = max(0, burstRadius)
        self.onLike = onLike
    }

    /// The animated like control.
    public var body: some View {
        Button(action: like) {
            ZStack {
                Circle()
                    .fill(RadialGradient(
                        colors: [palette.heart.opacity(isLiked ? 0.45 : 0), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 170
                    ))
                    .frame(width: 340, height: 340)

                Circle()
                    .stroke(palette.heart, lineWidth: 2)
                    .frame(width: 130, height: 130)
                    .scaleEffect(0.6 + burstProgress * 1.6)
                    .opacity(isBursting ? 1 - burstProgress : 0)

                if isBursting {
                    ForEach(0..<particleCount, id: \.self) { index in
                        let angle = Angle.degrees(Double(index) / Double(max(particleCount, 1)) * 360)
                        let travel = burstProgress * burstRadius
                        Capsule(style: .continuous)
                            .fill(particleColor(at: index))
                            .frame(width: 10, height: 26)
                            .scaleEffect(1 - burstProgress * 0.7)
                            .rotationEffect(angle + .degrees(90))
                            .offset(x: cos(angle.radians) * travel, y: sin(angle.radians) * travel)
                            .opacity(1 - burstProgress)
                    }
                }

                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .font(.system(size: 180, weight: .semibold))
                    .foregroundStyle(isLiked ? AnyShapeStyle(heartGradient) : AnyShapeStyle(.white.opacity(0.35)))
                    .contentTransition(.symbolEffect(.replace))
                    .scaleEffect(heartScale)

                if showPlusOne {
                    Text("+1")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(heartGradient))
                        .rotationEffect(.degrees(-6 + Double(plusOneProgress) * 12))
                        .scaleEffect(0.85 + (1 - plusOneProgress) * 0.15)
                        .offset(y: -70 - plusOneProgress * 170)
                        .opacity(1 - plusOneProgress)
                }
            }
            .offset(y: -60)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [palette.backgroundTop, palette.backgroundBottom], startPoint: .top, endPoint: .bottom))
        .contentShape(Rectangle())
        .accessibilityLabel(isLiked ? "Unlike" : "Like")
        .sensoryFeedback(trigger: isLiked) { _, liked in
            liked ? .success : .impact(weight: .light)
        }
    }

    private var heartGradient: LinearGradient {
        LinearGradient(colors: [palette.heart, palette.heartDeep], startPoint: .top, endPoint: .bottom)
    }

    private func particleColor(at index: Int) -> Color {
        guard !palette.particles.isEmpty else { return palette.heart }
        return palette.particles[index % palette.particles.count]
    }

    private func like() {
        guard !isLiked else { return }
        onLike?()
        withAnimation(.smooth(duration: 0.25)) { isLiked = true }
        withAnimation(.spring(response: 0.2, dampingFraction: 0.45)) { heartScale = 1.3 } completion: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { heartScale = 1 }
        }
        isBursting = true
        burstProgress = 0
        withAnimation(.easeOut(duration: 0.7)) { burstProgress = 1 } completion: { isBursting = false }
        showPlusOne = true
        plusOneProgress = 0
        withAnimation(.easeOut(duration: 0.9)) { plusOneProgress = 1 } completion: { showPlusOne = false }
    }
}

#Preview {
    LikeButton(isLiked: .constant(false))
        .frame(height: 500)
}
