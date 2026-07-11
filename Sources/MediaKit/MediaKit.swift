import FileKit
import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Explicit image-loading policy. This foundation never silently resizes or strips metadata.
public struct ImageLoadPolicy: Sendable {
    /// The maximum accepted input size in bytes.
    public let maximumBytes: Int

    /// The accepted decoded image types.
    public let allowedTypes: [UTType]

    /// Creates an image policy. The size is also enforced by ``FileImportPolicy``.
    public init(maximumBytes: Int = 25_000_000, allowedTypes: [UTType] = [.image]) {
        self.maximumBytes = maximumBytes
        self.allowedTypes = allowedTypes
    }
}

/// Errors emitted when data cannot be decoded as an allowed image type.
public enum ImageLoadError: LocalizedError, Equatable, Sendable {
    /// The bytes cannot be decoded as an image.
    case invalidImageData

    /// The decoded image type is not permitted by the policy.
    case unsupportedImageType

    /// A non-sensitive description suitable for user presentation.
    public var errorDescription: String? {
        switch self {
        case .invalidImageData: "The selected file is not a valid image."
        case .unsupportedImageType: "This image type is not supported."
        }
    }
}

/// An actor-isolated, bounded LRU cache of image data.
public actor ImageDataCache {
    /// The default encoded-byte capacity for an image cache.
    public static let defaultCapacity = 32 * 1024 * 1024

    fileprivate struct Fingerprint: Sendable, Equatable {
        let size: Int
        let modificationDate: Date?
        let resourceIdentifier: String?
    }

    private struct Entry: Sendable {
        let data: Data
        let fingerprint: Fingerprint?
    }

    private let capacity: Int
    private var values: [URL: Entry] = [:]
    private var recency: [URL] = []
    private var byteCount = 0

    /// Creates an empty cache with a deterministic encoded-byte capacity.
    public init(capacity: Int = ImageDataCache.defaultCapacity) {
        self.capacity = max(0, capacity)
    }

    /// Returns cached data for `url`, if present, updating its LRU recency.
    ///
    /// Callers that enforce an image policy should use ``ImageLoader``; this compatibility
    /// accessor only exposes entries that passed the cache's basic image validation.
    public func data(for url: URL) -> Data? {
        guard let entry = values[url] else { return nil }
        touch(url)
        return entry.data
    }

    /// Inserts image data for `url` after basic encoded-image validation.
    @available(*, deprecated, message: "Use ImageLoader or validated cache insertion instead.")
    public func insert(_ data: Data, for url: URL) {
        guard (try? ImageLoader.validateEncodedData(data, allowedTypes: [.image])) != nil else { return }
        insertValidated(data, for: url, fingerprint: fingerprint(for: url))
    }

    /// Removes one cached value.
    public func removeValue(for url: URL) {
        guard let entry = values.removeValue(forKey: url) else { return }
        byteCount -= entry.data.count
        recency.removeAll { $0 == url }
    }

    /// Removes every cached value.
    public func removeAll() {
        values.removeAll()
        recency.removeAll()
        byteCount = 0
    }

    fileprivate func validatedData(for url: URL, policy: ImageLoadPolicy) -> Data? {
        guard let entry = values[url] else { return nil }
        if let cachedFingerprint = entry.fingerprint,
           let currentFingerprint = fingerprint(for: url),
           cachedFingerprint != currentFingerprint {
            removeValue(for: url)
            return nil
        }
        guard (try? ImageLoader.validateEncodedData(entry.data, allowedTypes: policy.allowedTypes)) != nil,
              entry.data.count <= policy.maximumBytes else {
            removeValue(for: url)
            return nil
        }
        touch(url)
        return entry.data
    }

    fileprivate func insertValidated(_ data: Data, for url: URL, fingerprint: Fingerprint? = nil) {
        guard capacity > 0, data.count <= capacity else { return }
        removeValue(for: url)
        values[url] = Entry(data: data, fingerprint: fingerprint ?? self.fingerprint(for: url))
        recency.append(url)
        byteCount += data.count
        while byteCount > capacity, let oldest = recency.first {
            removeValue(for: oldest)
        }
    }

    private func touch(_ url: URL) {
        recency.removeAll { $0 == url }
        recency.append(url)
    }

    /// Returns best-effort freshness metadata, not a guaranteed file identity.
    private func fingerprint(for url: URL) -> Fingerprint? {
        guard url.isFileURL, FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attributes[.size] as? NSNumber else { return nil }
        let values = try? url.resourceValues(forKeys: [.fileResourceIdentifierKey])
        return Fingerprint(
            size: size.intValue,
            modificationDate: attributes[.modificationDate] as? Date,
            resourceIdentifier: values?.fileResourceIdentifier.map { String(describing: $0) }
        )
    }
}

private enum ImageFileReader {
    static func read(from url: URL) async throws -> Data {
        try Task.checkCancellation()
        let readTask = Task.detached(priority: .utility) {
            try Data(contentsOf: url, options: .mappedIfSafe)
        }
        let data = try await readTask.value
        try Task.checkCancellation()
        return data
    }
}

/// Explicit, cancellation-aware validated image loading.
public enum ImageLoader {
    /// Reads validated image data after checking the file's declared and decoded type and size.
    ///
    /// Disk I/O runs in an independent utility-priority task. Cancellation is observed before
    /// and after the blocking Foundation read; the operating-system read itself may finish after
    /// cancellation, but canceled data is discarded.
    public static func load(
        from url: URL,
        policy: ImageLoadPolicy = .init(),
        cache: ImageDataCache? = nil
    ) async throws -> Data {
        try Task.checkCancellation()
        if let cached = await cache?.validatedData(for: url, policy: policy) {
            try Task.checkCancellation()
            return cached
        }
        try FileImportPolicy(allowedTypes: policy.allowedTypes, maximumBytes: policy.maximumBytes).validate(url)
        let data = try await ImageFileReader.read(from: url)
        try Task.checkCancellation()
        try validateEncodedData(data, allowedTypes: policy.allowedTypes)
        await cache?.insertValidated(data, for: url, fingerprint: nil)
        return data
    }

    fileprivate static func validateEncodedData(_ data: Data, allowedTypes: [UTType]) throws {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let typeIdentifier = CGImageSourceGetType(source),
              let type = UTType(typeIdentifier as String)
        else {
            throw ImageLoadError.invalidImageData
        }
        guard allowedTypes.contains(where: { type.conforms(to: $0) }) else {
            throw ImageLoadError.unsupportedImageType
        }
        guard CGImageSourceCreateImageAtIndex(source, 0, nil) != nil else {
            throw ImageLoadError.invalidImageData
        }
    }
}
