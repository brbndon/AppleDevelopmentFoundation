import PersistenceKit
import XCTest

final class PersistenceKitTests: XCTestCase {
    func testRemovingMissingStoreIsSafe() throws { try PersistenceReset.removeStore(at: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)) }
}
