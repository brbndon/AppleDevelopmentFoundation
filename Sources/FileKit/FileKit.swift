import AppFoundation
import Foundation
import UniformTypeIdentifiers

public enum FileKitError: LocalizedError, Equatable, Sendable {
    case unsupportedType; case fileTooLarge(maximumBytes: Int); case inaccessible; case invalidFilename
    public var errorDescription: String? { switch self { case .unsupportedType: "This file type is not supported."; case .fileTooLarge: "This file is too large."; case .inaccessible: "The selected file is no longer accessible."; case .invalidFilename: "A safe filename could not be created." } }
}

/// A policy that validates imported documents before an application reads their contents.
public struct FileImportPolicy: Sendable {
    public let allowedTypes: [UTType]; public let maximumBytes: Int
    public init(allowedTypes: [UTType], maximumBytes: Int) { self.allowedTypes = allowedTypes; self.maximumBytes = maximumBytes }
    public func validate(_ url: URL, fileManager: FileManager = .default) throws {
        guard let type = UTType(filenameExtension: url.pathExtension), allowedTypes.contains(where: { type.conforms(to: $0) }) else { throw FileKitError.unsupportedType }
        let values = try url.resourceValues(forKeys: [.fileSizeKey])
        let size = values.fileSize ?? 0
        guard size <= maximumBytes else { throw FileKitError.fileTooLarge(maximumBytes: maximumBytes) }
    }
}

public enum SafeFilename {
    /// Produces a portable filename while preserving a requested extension when possible.
    public static func make(_ proposed: String, fallback: String = "document") throws -> String {
        let invalid = CharacterSet(charactersIn: "/\\:\u{0}")
        let cleaned = proposed.components(separatedBy: invalid).joined(separator: "-").trimmingCharacters(in: .whitespacesAndNewlines)
        let value = cleaned.isEmpty ? fallback : cleaned
        guard value != "." && value != ".." else { throw FileKitError.invalidFilename }
        return String(value.prefix(120))
    }
}

public enum FileLocations {
    public static func applicationSupport(fileManager: FileManager = .default) throws -> URL {
        let url = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }
    public static func temporaryFile(named name: String, fileManager: FileManager = .default) throws -> URL { fileManager.temporaryDirectory.appendingPathComponent(try SafeFilename.make(name)) }
}

public enum AtomicFileWriter {
    public static func write(_ data: Data, to url: URL) throws { try data.write(to: url, options: [.atomic]) }
}

/// Ensures security-scoped access is balanced even when the work throws.
public func withSecurityScopedAccess<Result>(_ url: URL, _ body: () throws -> Result) throws -> Result {
    guard url.startAccessingSecurityScopedResource() else { throw FileKitError.inaccessible }
    defer { url.stopAccessingSecurityScopedResource() }
    return try body()
}
