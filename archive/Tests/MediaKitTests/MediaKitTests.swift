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
        await cache.insert(png, for: url)
        let insertedValue = await cache.data(for: url)
        XCTAssertEqual(insertedValue, png)
        await cache.removeAll()
        let clearedValue = await cache.data(for: url)
        XCTAssertNil(clearedValue)
    }

    func testInvalidPublicInsertionIsNotRetained() async {
        let cache = ImageDataCache()
        let url = URL(fileURLWithPath: "/tmp/invalid.png")
        await cache.insert(Data("not image".utf8), for: url)
        let value = await cache.data(for: url)
        XCTAssertNil(value)
    }

    func testCacheHitChecksStricterPolicyAndDecodedValidation() async throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("image.png")
        try png.write(to: url)
        let cache = ImageDataCache()
        _ = try await ImageLoader.load(from: url, policy: .init(maximumBytes: png.count), cache: cache)
        do {
            _ = try await ImageLoader.load(from: url, policy: .init(maximumBytes: png.count - 1), cache: cache)
            XCTFail("Expected stricter policy to reject cached bytes")
        } catch { }
    }

    func testModifiedFileInvalidatesCache() async throws {
        let directory = try TemporaryDirectory.make()
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("image.png")
        try png.write(to: url)
        let cache = ImageDataCache()
        _ = try await ImageLoader.load(from: url, cache: cache)
        try Data(repeating: 0, count: png.count + 1).write(to: url)
        do {
            _ = try await ImageLoader.load(from: url, cache: cache)
            XCTFail("Expected modified file to reload and fail validation")
        } catch { }
    }

    func testCacheEvictsLeastRecentlyUsedAndRejectsOversizedEntry() async {
        let cache = ImageDataCache(capacity: png.count * 2)
        let first = URL(fileURLWithPath: "/tmp/first.png")
        let second = URL(fileURLWithPath: "/tmp/second.png")
        let third = URL(fileURLWithPath: "/tmp/third.png")
        await cache.insert(png, for: first)
        await cache.insert(png, for: second)
        _ = await cache.data(for: first)
        await cache.insert(png, for: third)
        let firstValue = await cache.data(for: first)
        let secondValue = await cache.data(for: second)
        let thirdValue = await cache.data(for: third)
        XCTAssertNotNil(firstValue)
        XCTAssertNil(secondValue)
        XCTAssertNotNil(thirdValue)
        let small = ImageDataCache(capacity: png.count - 1)
        await small.insert(png, for: first)
        let oversizedValue = await small.data(for: first)
        XCTAssertNil(oversizedValue)
    }

    func testCancelledTaskCannotReturnCacheHit() async {
        let cache = ImageDataCache()
        let url = URL(fileURLWithPath: "/tmp/cancelled.png")
        await cache.insert(png, for: url)
        let task = Task { try await ImageLoader.load(from: url, cache: cache) }
        task.cancel()
        do { _ = try await task.value; XCTFail("Expected cancellation") }
        catch is CancellationError {}
        catch { XCTFail("Unexpected error: \(error)") }
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
        let imageData = png
        await withTaskGroup(of: Void.self) { group in
            for index in 0..<20 {
                group.addTask {
                    await cache.insert(imageData, for: URL(fileURLWithPath: "/tmp/\(index).png"))
                }
            }
        }
        for index in 0..<20 {
            let value = await cache.data(for: URL(fileURLWithPath: "/tmp/\(index).png"))
            XCTAssertEqual(value, imageData)
        }
    }
}
