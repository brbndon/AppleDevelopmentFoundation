import FileKit
import MediaKit
import TestingSupport
import XCTest

final class MediaKitTests: XCTestCase {
    private let png = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Wl4f90AAAAASUVORK5CYII=")!

    func testCacheInsertionRetrievalMissAndClear() async {
        let cache = ImageDataCache()
        let url = URL(fileURLWithPath: "/tmp/image.png")
        let initialValue = await cache.data(for: url)
        XCTAssertNil(initialValue)
        await cache.insert(Data("image".utf8), for: url)
        let insertedValue = await cache.data(for: url)
        XCTAssertEqual(insertedValue, Data("image".utf8))
        await cache.removeAll()
        let clearedValue = await cache.data(for: url)
        XCTAssertNil(clearedValue)
    }

    func testLoaderValidatesDataAndUsesCache() async throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("image.png")
        try png.write(to: url)
        let cache = ImageDataCache()
        let loaded = try await ImageLoader.load(from: url, cache: cache)
        XCTAssertEqual(loaded, png)
        try FileManager.default.removeItem(at: url)
        let cached = try await ImageLoader.load(from: url, cache: cache)
        XCTAssertEqual(cached, png)
    }

    func testLoaderRejectsInvalidImageData() async throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("not-an-image.png")
        try Data("not an image".utf8).write(to: url)
        do {
            _ = try await ImageLoader.load(from: url)
            XCTFail("Expected invalid image data")
        } catch let error as ImageLoadError {
            XCTAssertEqual(error, .invalidImageData)
        }
    }

    func testCancelledLoadStopsBeforeReading() async throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("image.png")
        try png.write(to: url)
        let task = Task {
            await Task.yield()
            return try await ImageLoader.load(from: url)
        }
        task.cancel()
        do {
            _ = try await task.value
        } catch is CancellationError {
            return
        }
        XCTFail("Expected cancellation")
    }

    func testConcurrentCacheAccessRetainsEachEntry() async {
        let cache = ImageDataCache()
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<20 {
                group.addTask {
                    await cache.insert(Data("\(index)".utf8), for: URL(fileURLWithPath: "/tmp/\(index).png"))
                }
            }
        }
        for index in 0..<20 {
            let value = await cache.data(for: URL(fileURLWithPath: "/tmp/\(index).png"))
            XCTAssertEqual(value, Data("\(index)".utf8))
        }
    }
}
