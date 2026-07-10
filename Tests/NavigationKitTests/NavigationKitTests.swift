import NavigationKit
import XCTest

final class NavigationKitTests: XCTestCase {
    @MainActor func testRouterPreparesDeepLinkAndPops() { let router = NavigationRouter<String>(); router.prepare(deepLink: ["a", "b"]); XCTAssertEqual(router.path, ["a", "b"]); router.popToRoot(); XCTAssertTrue(router.path.isEmpty) }
}
