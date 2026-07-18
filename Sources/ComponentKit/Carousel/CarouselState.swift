import Observation
import SwiftUI

/// Observable state for a `SnapCarousel`.
@Observable
public final class CarouselState {
    /// The centered item index.
    public var activeIndex: Int
    /// Live horizontal drag translation.
    public var dragTranslation: CGFloat = 0

    /// Creates carousel state, clamping negative indexes to zero.
    public init(activeIndex: Int = 0) {
        self.activeIndex = max(0, activeIndex)
    }

    /// Clamps the active index to the valid range for an item count.
    public func clampIndex(itemCount: Int) {
        activeIndex = itemCount > 0 ? min(max(activeIndex, 0), itemCount - 1) : 0
    }
}
