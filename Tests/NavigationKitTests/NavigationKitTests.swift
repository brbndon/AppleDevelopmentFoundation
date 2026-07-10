import NavigationKit
import XCTest

final class NavigationKitTests: XCTestCase {
    private enum Route: String, Codable, Hashable { case home, detail, settings }

    @MainActor func testRouterChangesPathAndSheetState() {
        let router = NavigationRouter<Route>()
        router.show(.home)
        router.show(.detail)
        XCTAssertEqual(router.path, [.home, .detail])
        router.presentSheet(.settings)
        XCTAssertEqual(router.sheet, .settings)
        router.dismissSheet()
        XCTAssertNil(router.sheet)
        router.popToRoot()
        XCTAssertTrue(router.path.isEmpty)
    }

    @MainActor func testRouterEncodesAndRestoresTypedPath() throws {
        let router = NavigationRouter<Route>()
        router.prepare(deepLink: [.home, .detail])
        let state = try router.encodedPath()
        router.popToRoot()
        try router.restorePath(from: state)
        XCTAssertEqual(router.path, [.home, .detail])
    }

    @MainActor func testInvalidRestorationLeavesExistingPathUntouched() {
        let router = NavigationRouter<Route>()
        router.prepare(deepLink: [.home])
        XCTAssertThrowsError(try router.restorePath(from: Data("not json".utf8)))
        XCTAssertEqual(router.path, [.home])
    }
}
