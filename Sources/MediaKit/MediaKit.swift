import AppFoundation
import FileKit
import Foundation
import UniformTypeIdentifiers

/// Explicit image-loading policy. This foundation never silently resizes or strips metadata.
public struct ImageLoadPolicy: Sendable {
    public let maximumBytes: Int; public let allowedTypes: [UTType]
    public init(maximumBytes: Int = 25_000_000, allowedTypes: [UTType] = [.image]) { self.maximumBytes = maximumBytes; self.allowedTypes = allowedTypes }
}

public actor ImageDataCache {
    private var values: [URL: Data] = [:]
    public init() {}
    public func data(for url: URL) -> Data? { values[url] }
    public func insert(_ data: Data, for url: URL) { values[url] = data }
    public func removeAll() { values.removeAll() }
}

public enum ImageLoader {
    /// Reads mapped data after validating type and file size. Callers opt into any later conversion.
    public static func load(from url: URL, policy: ImageLoadPolicy = .init(), cache: ImageDataCache? = nil) async throws -> Data {
        if let cached = await cache?.data(for: url) { return cached }
        try Task.checkCancellation()
        try FileImportPolicy(allowedTypes: policy.allowedTypes, maximumBytes: policy.maximumBytes).validate(url)
        let data = try Data(contentsOf: url, options: .mappedIfSafe)
        try Task.checkCancellation()
        await cache?.insert(data, for: url)
        return data
    }
}
