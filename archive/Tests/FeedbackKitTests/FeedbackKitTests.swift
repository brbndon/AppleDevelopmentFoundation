import FeedbackKit
import XCTest

final class FeedbackKitTests: XCTestCase {
    @MainActor func testCenterTransitionsBetweenVisibleAndEmptyState() {
        let center = FeedbackCenter()
        XCTAssertNil(center.message)
        let message = FeedbackMessage(kind: .error, text: "Try again.")
        center.show(message)
        XCTAssertEqual(center.message, message)
        center.dismiss()
        XCTAssertNil(center.message)
    }

    func testMessagesPreserveUserFacingKindAndText() {
        let message = FeedbackMessage(kind: .warning, text: "Connection is slow.")
        XCTAssertEqual(message.kind, .warning)
        XCTAssertEqual(message.text, "Connection is slow.")
    }
}
