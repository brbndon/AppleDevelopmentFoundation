import XCTest

final class FoundationTasksUITests: XCTestCase {
    @MainActor
    func testCanCreateTask() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-inMemory"]
        app.launch()
        XCTAssertTrue(app.tabBars.buttons["Tasks"].waitForExistence(timeout: 2))
        app.buttons["add-task"].tap()
        let title = app.textFields["task-title"]
        XCTAssertTrue(title.waitForExistence(timeout: 2))
        title.tap()
        title.typeText("Buy groceries")
        app.buttons["save-task"].tap()
        XCTAssertTrue(app.staticTexts["Buy groceries"].waitForExistence(timeout: 2))
    }
}
