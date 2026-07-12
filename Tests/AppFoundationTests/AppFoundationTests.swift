import AppFoundation
import XCTest

final class AppFoundationTests: XCTestCase {
    func testFixedAppClockAlwaysReturnsConfiguredDate() {
        let date = Date(timeIntervalSinceReferenceDate: 42)
        XCTAssertEqual(FixedAppClock(date).now(), date)
    }

    func testFixedIdentifierProviderAlwaysReturnsConfiguredIdentifier() {
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000042")!
        let provider = FixedIdentifierProvider(id)
        XCTAssertEqual(provider.makeID(), id)
        XCTAssertEqual(provider.makeID(), id)
    }

    func testSystemIdentifiersAreDistinct() {
        XCTAssertNotEqual(UUIDIdentifierProvider().makeID(), UUIDIdentifierProvider().makeID())
    }

    func testEnvironmentOverridesAreDeterministic() {
        let environment = AppEnvironment(environment: [
            "XCODE_RUNNING_FOR_PREVIEWS": "1",
            "XCTestConfigurationFilePath": "/tmp/test.xctest",
        ])
        XCTAssertTrue(environment.isPreview)
        XCTAssertTrue(environment.isRunningTests)
    }

    func testErrorDescriptionNeverIncludesAssociatedDetails() {
        XCTAssertEqual(
            AppFoundationError.unavailable("private value").errorDescription,
            "This capability is unavailable."
        )
    }
}
