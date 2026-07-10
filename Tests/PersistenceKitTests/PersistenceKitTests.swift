import PersistenceKit
import SwiftData
import XCTest

@Model private final class TestRecord {
    var title: String

    init(title: String) { self.title = title }
}

final class PersistenceKitTests: XCTestCase {
    @MainActor func testInMemoryContainersSaveFetchAndRemainIsolated() throws {
        let schema = Schema([TestRecord.self])
        let first = try PersistenceContainerFactory.make(schema: schema, inMemory: true)
        let second = try PersistenceContainerFactory.make(schema: schema, inMemory: true)
        first.mainContext.insert(TestRecord(title: "first"))
        try first.mainContext.save()

        let firstRecords = try first.mainContext.fetch(FetchDescriptor<TestRecord>())
        let secondRecords = try second.mainContext.fetch(FetchDescriptor<TestRecord>())
        XCTAssertEqual(firstRecords.map(\.title), ["first"])
        XCTAssertTrue(secondRecords.isEmpty)
    }

    func testResetRemovesStoreAndSQLiteSidecars() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = directory.appendingPathComponent("store.sqlite")
        for url in [store, URL(fileURLWithPath: store.path + "-wal"), URL(fileURLWithPath: store.path + "-shm")] {
            try Data().write(to: url)
        }
        try PersistenceReset.removeStore(at: store)
        XCTAssertFalse(FileManager.default.fileExists(atPath: store.path))
        XCTAssertFalse(FileManager.default.fileExists(atPath: store.path + "-wal"))
        XCTAssertFalse(FileManager.default.fileExists(atPath: store.path + "-shm"))
    }

    func testRemovingMissingStoreIsSafe() throws {
        try PersistenceReset.removeStore(at: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString))
    }
}
