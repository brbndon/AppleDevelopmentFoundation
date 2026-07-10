import DesignSystem
import XCTest

final class DesignSystemTests: XCTestCase {
    func testTokensUsePositiveGeometry() { XCTAssertGreaterThan(FoundationTokens.Spacing.standard, 0); XCTAssertGreaterThan(FoundationTokens.Radius.card, 0) }
}
