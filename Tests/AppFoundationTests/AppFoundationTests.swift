import AppFoundation
import XCTest

final class AppFoundationTests: XCTestCase {
    func testSystemIdentifiersAreDistinct() { XCTAssertNotEqual(UUIDIdentifierProvider().makeID(), UUIDIdentifierProvider().makeID()) }
    func testErrorHasDescription() { XCTAssertNotNil(AppFoundationError.unavailable("Offline").errorDescription) }
}
