import AppShellKit
import SwiftUI
import XCTest

final class AppShellKitTests: XCTestCase {
    @MainActor
    func testFoundationSettingsLinkIsPubliclyConstructible() {
        // View construction; full rendering tested in host apps or manually.
        let link = FoundationSettingsLink("Prefs") { }
        XCTAssertNotNil(link)
    }

    @MainActor
    func testAdaptiveAppShellIsPubliclyConstructible() {
        let shell = AdaptiveAppShell {
            Text("Sidebar")
        } detail: {
            Text("Detail")
        }
        XCTAssertNotNil(shell)
    }
}
