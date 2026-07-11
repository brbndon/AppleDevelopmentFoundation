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

    func testSidecarsAreRemovedWhenMainStoreIsMissing() throws {
        let base = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: URL(fileURLWithPath: base.path + "-wal")); try? FileManager.default.removeItem(at: URL(fileURLWithPath: base.path + "-shm")) }
        try Data().write(to: URL(fileURLWithPath: base.path + "-wal"))
        try Data().write(to: URL(fileURLWithPath: base.path + "-shm"))
        try PersistenceReset.removeStore(at: base)
        XCTAssertFalse(FileManager.default.fileExists(atPath: base.path + "-wal"))
        XCTAssertFalse(FileManager.default.fileExists(atPath: base.path + "-shm"))
    }

    @MainActor func testExplicitConfigurationIsHonored() throws {
        let schema = Schema([TestRecord.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try PersistenceContainerFactory.make(schema: schema, configurations: [configuration])
        container.mainContext.insert(TestRecord(title: "memory"))
        try container.mainContext.save()
        XCTAssertEqual(try container.mainContext.fetch(FetchDescriptor<TestRecord>()).count, 1)
    }

    func testResetIsIdempotent() throws {
        let base = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try PersistenceReset.removeStore(at: base)
        try PersistenceReset.removeStore(at: base)
    }

    func testResetSurfacesUnsafeArtifactAndStillAttemptsOtherArtifacts() throws {
        let directory = try FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: FileManager.default.temporaryDirectory, create: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = directory.appendingPathComponent("store.sqlite")
        let wal = URL(fileURLWithPath: store.path + "-wal")
        let shm = URL(fileURLWithPath: store.path + "-shm")
        try Data().write(to: store)
        try Data().write(to: shm)
        try FileManager.default.createSymbolicLink(at: wal, withDestinationURL: shm)
        XCTAssertThrowsError(try PersistenceReset.removeStore(at: store)) { error in
            XCTAssertEqual(error as? PersistenceResetError, .removalFailed(.writeAheadLog))
            XCTAssertFalse(FileManager.default.fileExists(atPath: store.path))
            XCTAssertFalse(FileManager.default.fileExists(atPath: shm.path))
        }
    }

    func testResetReportsAllFailedArtifactsAndHandlesDanglingSymlink() throws {
        let directory = try FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: FileManager.default.temporaryDirectory, create: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let store = directory.appendingPathComponent("store.sqlite")
        let wal = URL(fileURLWithPath: store.path + "-wal")
        let shm = URL(fileURLWithPath: store.path + "-shm")
        try FileManager.default.createSymbolicLink(atPath: store.path, withDestinationPath: "/missing-store")
        try FileManager.default.createSymbolicLink(atPath: wal.path, withDestinationPath: "/missing-wal")
        try Data().write(to: shm)

        XCTAssertThrowsError(try PersistenceReset.removeStore(at: store)) { error in
            XCTAssertEqual(error as? PersistenceResetError, .multipleRemovalsFailed([.mainStore, .writeAheadLog]))
        }
        XCTAssertFalse(FileManager.default.fileExists(atPath: shm.path))
    }
}
