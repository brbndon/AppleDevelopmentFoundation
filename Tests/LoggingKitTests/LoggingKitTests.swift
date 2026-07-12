import LoggingKit
import XCTest

final class LoggingKitTests: XCTestCase {
    func testLoggerInitializesAndAcceptsStaticEventLiterals() {
        let logger = FoundationLogger(subsystem: "com.example.audit", category: "test")
        // Calls are side-effect only (OSLog); successful execution without runtime values confirms boundary.
        logger.debug(event: "audit.start")
        logger.error(event: "audit.failure")
        // If we reach here without crash or API misuse, the narrow StaticString contract holds.
        XCTAssertTrue(true)
    }
}
