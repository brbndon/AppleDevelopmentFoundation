@testable import ComponentKit
import SwiftUI
import XCTest

final class ComponentKitTests: XCTestCase {
    func testDownloadControllerPhaseTransitions() {
        let controller = DownloadController()
        XCTAssertEqual(controller.phase, .idle)
        controller.phase = .downloading
        XCTAssertEqual(controller.phase, .downloading)
        controller.phase = .completed
        XCTAssertEqual(controller.phase, .completed)
    }

    func testLikePaletteDefaultConstructs() {
        XCTAssertFalse(LikeButtonPalette.default.particles.isEmpty)
    }

    func testCarouselStateClampsIndex() {
        let state = CarouselState(activeIndex: -1)
        state.activeIndex = 99
        state.clampIndex(itemCount: 3)
        XCTAssertEqual(state.activeIndex, 2)
        state.clampIndex(itemCount: 0)
        XCTAssertEqual(state.activeIndex, 0)
    }

    @MainActor
    func testCarouselCardWidthUsesContainerGeometry() {
        XCTAssertEqual(SnapCarousel<EmptyView>.cardWidth(containerWidth: 400, peekWidth: 32, spacing: 16), 304)
    }

    @MainActor
    func testAppleGlassSliderInitializationAndAccessibility() {
        let binding = Binding.constant(0.5)
        let slider = AppleGlassSlider(value: binding, in: 0.0...10.0, step: 1.0, label: "Volume")
        
        XCTAssertNotNil(slider)
        // Check that accessibility properties don't crash
        let _ = slider.body
    }
}

