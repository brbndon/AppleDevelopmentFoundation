@testable import DesignSystem
import XCTest

final class DesignSystemTests: XCTestCase {
    func testTokensUsePositiveOrderedGeometry() {
        XCTAssertGreaterThan(FoundationTokens.Spacing.compact, 0)
        XCTAssertLessThan(FoundationTokens.Spacing.compact, FoundationTokens.Spacing.standard)
        XCTAssertLessThan(FoundationTokens.Spacing.standard, FoundationTokens.Spacing.roomy)
        XCTAssertGreaterThan(FoundationTokens.Radius.card, FoundationTokens.Radius.control)
    }

    func testStatusKindsAreSemanticAndComparable() {
        XCTAssertEqual(StatusBadge.Kind.success, .success)
        XCTAssertNotEqual(StatusBadge.Kind.warning, .danger)
    }

    func testStatusKindsHaveDistinctSymbols() {
        let symbols = [
            StatusBadge.Kind.neutral.systemImage,
            StatusBadge.Kind.success.systemImage,
            StatusBadge.Kind.warning.systemImage,
            StatusBadge.Kind.danger.systemImage,
        ]
        XCTAssertEqual(Set(symbols).count, 4)
    }
}
