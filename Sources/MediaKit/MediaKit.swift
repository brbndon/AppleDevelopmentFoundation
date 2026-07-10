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

/// An actor-isolated, in-memory cache of validated image data.
public actor ImageDataCache {
    private var values: [URL: Data] = [:]

    /// Creates an empty cache with no eviction policy.
    public init() {}

    /// Returns cached data for `url`, if present.
    public func data(for url: URL) -> Data? { values[url] }

    /// Inserts or replaces data for `url`.
    public func insert(_ data: Data, for url: URL) { values[url] = data }

    /// Removes every cached value.
    public func removeAll() { values.removeAll() }
}

private actor ImageFileReader {
    func read(from url: URL) throws -> Data {
        try Data(contentsOf: url, options: .mappedIfSafe)
    }
}

/// Explicit, cancellation-aware validated image loading.
public enum ImageLoader {
    private static let reader = ImageFileReader()

    /// Reads validated image data after checking the file's declared and decoded type and size.
    ///
    /// Disk I/O is isolated off the caller's actor. Callers opt into any later conversion or compression.
    public static func load(
        from url: URL,
        policy: ImageLoadPolicy = .init(),
        cache: ImageDataCache? = nil
    ) async throws -> Data {
        if let cached = await cache?.data(for: url) { return cached }
        try Task.checkCancellation()
        try FileImportPolicy(allowedTypes: policy.allowedTypes, maximumBytes: policy.maximumBytes).validate(url)
        let data = try await reader.read(from: url)
        try Task.checkCancellation()
        try validateDecodedType(of: data, allowedTypes: policy.allowedTypes)
        await cache?.insert(data, for: url)
        return data
    }

    private static func validateDecodedType(of data: Data, allowedTypes: [UTType]) throws {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil),
              let typeIdentifier = CGImageSourceGetType(source),
              let type = UTType(typeIdentifier as String)
        else {
            throw ImageLoadError.invalidImageData
        }
        guard allowedTypes.contains(where: { type.conforms(to: $0) }) else {
            throw ImageLoadError.unsupportedImageType
        }
    }
}
