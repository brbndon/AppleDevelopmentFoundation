import XCTest

final class FoundationTasksUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool { true }

    @MainActor
    func testLaunchesToTasks() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-inMemory"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Tasks"].waitForExistence(timeout: 2))
    }
}
