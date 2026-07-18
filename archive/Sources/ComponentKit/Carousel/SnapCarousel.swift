import FeedbackKit
import SwiftUI

/// A geometry-aware horizontally snapping carousel with rubber-band drag feedback.
public struct SnapCarousel<ItemContent: View>: View {
    private let itemCount: Int
    private let spacing: CGFloat
    private let peekWidth: CGFloat
    private let state: CarouselState
    private let onIndexChanged: ((Int) -> Void)?
    private let content: ItemContent

    /// Creates a carousel whose item content is supplied by a view builder.
    public init(
        itemCount: Int,
        spacing: CGFloat = 16,
        peekWidth: CGFloat = 32,
        state: CarouselState,
        onIndexChanged: ((Int) -> Void)? = nil,
        @ViewBuilder content: () -> ItemContent
    ) {
        self.itemCount = max(0, itemCount)
        self.spacing = max(0, spacing)
        self.peekWidth = max(0, peekWidth)
        self.state = state
        self.onIndexChanged = onIndexChanged
        self.content = content()
    }

    /// The measured carousel layout and swipe interaction.
    public var body: some View {
        GeometryReader { geometry in
            let cardWidth = Self.cardWidth(containerWidth: geometry.size.width, peekWidth: peekWidth, spacing: spacing)
            let step = cardWidth + spacing
            let leading = (geometry.size.width - cardWidth) / 2
            let offset = leading - CGFloat(state.activeIndex) * step + state.dragTranslation

            HStack(spacing: spacing) {
                content
            }
            .offset(x: offset)
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged { value in
                state.dragTranslation = value.translation.width
            }.onEnded { value in
                defer { state.dragTranslation = 0 }
                guard itemCount > 0 else { return }
                let oldIndex = state.activeIndex
                if value.translation.width < -50 { state.activeIndex += 1 }
                if value.translation.width > 50 { state.activeIndex -= 1 }
                state.clampIndex(itemCount: itemCount)
                guard oldIndex != state.activeIndex else { return }
                if let onIndexChanged { onIndexChanged(state.activeIndex) }
                else { ADFHaptics.selection() }
            })
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: state.activeIndex)
        }
    }

    /// Calculates the card width from the available container rather than the device screen.
    public static func cardWidth(containerWidth: CGFloat, peekWidth: CGFloat, spacing: CGFloat) -> CGFloat {
        max(0, containerWidth - (peekWidth * 2) - (spacing * 2))
    }
}

/// A standard card slot for use inside `SnapCarousel`.
public struct SnapCarouselItem<Content: View>: View {
    private let width: CGFloat
    private let height: CGFloat
    private let content: Content

    /// Creates a fixed-size carousel item.
    public init(width: CGFloat, height: CGFloat, @ViewBuilder content: () -> Content) {
        self.width = width
        self.height = height
        self.content = content()
    }

    /// The item content constrained to its slot.
    public var body: some View {
        content.frame(width: width, height: height)
    }
}

#Preview {
    let state = CarouselState()
    SnapCarousel(itemCount: 3, state: state) {
        ForEach(0..<3, id: \.self) { index in
            SnapCarouselItem(width: 280, height: 180) {
                RoundedRectangle(cornerRadius: 20)
                    .fill([Color.blue, .purple, .orange][index].gradient)
                    .overlay(Text("Card \(index + 1)").foregroundStyle(.white).font(.title.bold()))
            }
        }
    }
    .frame(height: 220)
}
